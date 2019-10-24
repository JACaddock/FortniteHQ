extends KinematicBody2D

signal health_updated(health)
signal max_health_updated(max_health)
signal killed()

const GRAVITY = 10
const FLOOR = Vector2(0, -1)
const SPEED = 10
var jump_power = -250
var velocity = Vector2()
var target
var distance
var onGround = false
var cycle = 0
var alive = true

export (float) var max_health = 15
export (float) var strength = 2

onready var health = max_health setget _set_health


func _ready():
    $AnimationPlayer.play("Walk L")
    emit_signal("max_health_updated", max_health)
           
        
func _on_Detector_body_entered(body):
    if body.is_in_group("player"):
        target = body
        

func _on_Detector_body_exited(body):
    if body.is_in_group("player"):
        target = null


func movement_loop(cycle):
    if onGround and target != null:
        distance = position.x - target.position.x
        if cycle == 0:
            if distance > 0:
                anim_switch("Walk L")
                velocity.x = -SPEED
            elif distance < 0:
                anim_switch("Walk R")
                velocity.x = SPEED             
            else:
                velocity.x = 0
            
        elif cycle > 0:
            jump_power = -300
            if distance > 0:
                anim_switch("Jump L")
                if distance >= 200: #Catch Up Jump
                    velocity.x = -distance * 0.5
                elif cycle == 1 and distance > 50 and distance < 200:  #Jump Over
                    velocity.x = -distance * 2
                elif cycle == 2:  #Big Jump
                    jump_power = -450
                    velocity.x = -SPEED * 5
                elif cycle == 3:  #Random Jump
                    jump_power = rand_range(3, 6) * -50
                    velocity.x = -SPEED * 5
                    
            elif distance < 0:
                anim_switch("Jump R")
                if -distance > 300: #Catch Up Jump
                    velocity.x = -distance * 0.5
                elif cycle == 1 and -distance > 100 and -distance < 300:  #Jump Over
                    velocity.x = -distance * 2
                elif cycle == 2:  #Big Jump
                    jump_power = -450
                    velocity.x = SPEED * 5
                elif cycle == 3:  #Random Jump
                    jump_power = rand_range(3, 6) * -50
                    velocity.x = SPEED * 5
            
            velocity.y = jump_power
            onGround = false
        
    velocity = move_and_slide( velocity, FLOOR )
    
    
func _physics_process(delta):
    if alive:
        velocity.y += GRAVITY + (delta * 10)
        movement_loop(cycle)
        
        if is_on_floor():
            cycle = 0
            onGround = true
        else:
            onGround = false
            
        for i in get_slide_count():
            var collision = get_slide_collision(i)
            if collision.collider_shape.is_in_group("player"):
                collision.collider.damage(strength)
                
    elif not $AnimationPlayer.is_playing():
        queue_free()
                

func _on_CycleTimer_timeout():
    cycle = randi()%3+1
    $CycleTimer.start(rand_range(1,3))
    
    
func anim_switch(animation):
    var newanim = str(animation)
    if $AnimationPlayer.current_animation != newanim:
        $AnimationPlayer.play(newanim)
      
    
func damage(amount):
    if $IFrames.is_stopped():
        $IFrames.start()
        _set_health(health - amount)
        $EffectsPlayer.play("Damage")
          

func kill():
    alive = false
    $EffectsPlayer.play("Damage")


func _set_health(value):
    var prev_health = health
    health = clamp(value, 0, max_health)
    if health != prev_health:
        emit_signal("health_updated", health)
        if health == 0:
            kill()
            emit_signal("killed")