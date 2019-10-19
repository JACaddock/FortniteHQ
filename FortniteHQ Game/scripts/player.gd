extends KinematicBody2D

const SPEED = 200

var movedir = Vector2(0,0)

func _physics_process(delta):
    controls_loop()
    movement_loop()
    
    if movedir != Vector2(0,0):
        anim_switch("walk")
    else:
        anim_switch("idle")


func controls_loop():
    var LEFT = Input.is_action_pressed("ui_left")
    var RIGHT = Input.is_action_pressed("ui_right")
    
    movedir.x = -int(LEFT) + int(RIGHT)
    
    
func movement_loop():
    var motion = movedir.normalized() * SPEED
    move_and_slide(motion, Vector2(0,-1))


func anim_switch(animation):
    var newanim = str(animation)
    if $AnimationPlayer.current_animation != newanim:
        $AnimationPlayer.play(newanim)