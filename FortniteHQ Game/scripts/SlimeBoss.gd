extends KinematicBody2D

signal health_updated(health)
signal killed()

const GRAVITY = 10
const FLOOR = Vector2(0, -1)
var jump_power = -500
var velocity = Vector2()
var target
var direction
var onGround = true
var cycle = 1

var alive = true
export (float) var max_health = 15
onready var health = max_health setget _set_health


func _ready():
    $AnimationPlayer.play("Walk L")
           
        
func _on_Detector_body_entered(body):
    if body.is_in_group("player"):
        target = body
        

func _on_Detector_body_exited(body):
    if body.is_in_group("player"):
        target = null


func movement_loop(cycle):
    if onGround:
        if cycle == 1:
            if target != null and target.position.x < position.x:
                anim_switch("Walk L")
                direction = -1
                velocity.x = (position.x - $Body.position.x) * 0.005 * direction
                
            elif target != null and target.position.x > position.x:
                anim_switch("Walk R")
                direction = 1
                velocity.x = ( position.x - $Body.position.x) * 0.005 * direction
                
            else:
                velocity.x = 0
            
        if cycle == -1:
            jump_power = (rand_range(-6, -3)) * 100
            if target != null and target.position.x < position.x:
                anim_switch("Jump L")
                direction = -1
                velocity.x = (position.x - $Body.position.x) * 0.05 * direction
            elif target != null and target.position.x > position.x:
                anim_switch("Jump R")
                direction = 1
                velocity.x = ( position.x - $Body.position.x) * 0.05 * direction
                
            velocity.y = jump_power
            onGround = false
        
        
    if is_on_floor():
        onGround = true
    else:
        onGround = false
        
    velocity = move_and_slide( velocity, FLOOR )


func _physics_process(delta):
    if alive:
        velocity.y += GRAVITY + (delta * 10)
        movement_loop(cycle)
            
        for i in get_slide_count():
            var collision = get_slide_collision(i)
            if collision.collider_shape.is_in_group("weapon"):
                damage(1)
                
    elif not $AnimationPlayer.is_playing():
        queue_free()
                

func _on_Jumper_timeout():
    cycle *= -1
    $Jumper.start(rand_range(1,5))
    
    
func anim_switch(animation):
    var newanim = str(animation)
    if $AnimationPlayer.current_animation != newanim:
        $AnimationPlayer.play(newanim)
      
    
func damage(amount):
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

