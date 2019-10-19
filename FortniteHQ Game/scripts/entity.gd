extends KinematicBody2D

const SPEED = 0

var movedir = Vector2(0,0)


func movement_loop():
    var motion = movedir.normalized() * SPEED
    move_and_slide(motion, Vector2(0,-1))


func anim_switch(animation):
    var newanim = str(animation)
    if $AnimationPlayer.current_animation != newanim:
        $AnimationPlayer.play(newanim)