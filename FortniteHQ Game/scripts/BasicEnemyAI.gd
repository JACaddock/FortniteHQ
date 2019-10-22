extends KinematicBody2D

signal health_updated(health)
signal killed()

const GRAVITY = 10
const FLOOR = Vector2(0, -1)
var speed = 10
var velocity = Vector2()
var target
var direction

var alive = true
var max_health = 15
onready var health = max_health setget _set_health

func _ready():
    anim_switch("Still L")


func _on_Detector_body_entered(body):
    if body.is_in_group("player"):
        target = body
        

func _on_Detector_body_exited(body):
    if body.is_in_group("player"):
        target = null
        if direction == 1:
            anim_switch("Still R")
        else:
            anim_switch("Still L")
        

func movement_loop():
    if target != null and target.position.x < position.x:
        if position.x - target.position.x < 300 and $Cooldown.is_stopped():
            anim_switch("Attack L")
            $Cooldown.start()
        elif not $AnimationPlayer.current_animation == "Attack L":
            anim_switch("Walk L")
            
        direction = -1
        velocity.x = speed * direction
        
    elif target != null and target.position.x > position.x:
        if target.position.x - position.x < 300 and $Cooldown.is_stopped():
            anim_switch("Attack R")
            $Cooldown.start()
        elif not $AnimationPlayer.current_animation == "Attack R":
            anim_switch("Walk R")
            
        direction = 1
        velocity.x = speed * direction
        
    else:
        velocity.x = 0
        
    velocity = move_and_slide( velocity, FLOOR )
    

func _physics_process(delta):
    if alive:
        velocity.y += GRAVITY + (delta * 10)
        movement_loop()
            
    elif not $AnimationPlayer.is_playing():
        queue_free()
        
        
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
    $EffectsPlayer.play("Death")


func _set_health(value):
    var prev_health = health
    health = clamp(value, 0, max_health)
    if health != prev_health:
        emit_signal("health_updated", health)
        if health == 0:
            kill()
            emit_signal("killed")