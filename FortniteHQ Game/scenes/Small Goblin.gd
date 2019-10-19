extends KinematicBody2D

const GRAVITY = 10
const FLOOR = Vector2(0, -1)
const SPEED = 200

var velocity = Vector2()
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    if velocity.x == 0:
        $AnimationPlayer.play("Still")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    if direction == 1:
        $Goblin.flip_h = true
    else:
        $Goblin.flip_h = false
    
    velocity.x = SPEED * direction
    velocity.y += GRAVITY
    
    if $AnimationPlayer.current_animation != "Attack":
        $AnimationPlayer.play("Walk")

     
    if is_on_wall():
        direction = direction * -1
        $Body.position.x *= -1
        $Punch.position.x *= -1
        $Punch.rotation_degrees *= -1


func movement_loop():
    velocity = move_and_slide(velocity, FLOOR)
    

func _on_Timer_timeout():
    $AnimationPlayer.play("Attack")
