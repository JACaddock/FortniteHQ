extends KinematicBody2D


const GRAVITY = 10
const FLOOR = Vector2(0, -1)
var velocity = Vector2()
var target
var direction
var hasHealth = true
var health = 1
        

func _on_Detector_body_exited(body):
    if body.is_in_group("player"):
        target = null


func movement_loop():
    if target != null and target.position.x < position.x:
        $AnimationPlayer.play("Walk L")
        direction = -1
        velocity.x = (position.x - $Body.position.x) * 0.05 * direction
        
    elif target != null and target.position.x > position.x:
        $AnimationPlayer.play("Walk R")
        direction = 1
        velocity.x = ( position.x - $Body.position.x) * 0.05 * direction
        
    else:
        velocity.x = 0
        
    velocity = move_and_slide( velocity, FLOOR )
    

func _physics_process(delta):
    velocity.y += GRAVITY + (delta * 10)
    movement_loop()