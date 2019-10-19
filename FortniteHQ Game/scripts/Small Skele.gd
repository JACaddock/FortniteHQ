extends KinematicBody2D

const GRAVITY = 10
const FLOOR = Vector2(0, -1)
const SPEED = 200

var velocity = Vector2()
var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready():
    idle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    if direction == 1:
        $Idle.flip_h = false
    else:
        $Idle.flip_h = true
    
    velocity.x = SPEED * direction
    velocity.y += GRAVITY 
    walk()
    velocity = move_and_slide(velocity, FLOOR)
    
    if is_on_wall():
        direction = direction * -1
        $Body.position.x *= -1
        $Sword.position.x *= -1
        $Sword.rotation_degrees *= -1

# Functions for animations
func walk():
    $Idle.visible = false
    $Attack.visible = false
    $Walk.visible = true
    $AnimationPlayer.play("Walk")

func idle():
    $Walk.visible = false
    $Attack.visible = false
    $Idle.visible = true
    $AnimationPlayer.play("Idle")
    
func attack():
    $Idle.visible = false
    $Walk.visible = false
    $Attack.visible = true
    $AnimationPlayer.play("Attack")