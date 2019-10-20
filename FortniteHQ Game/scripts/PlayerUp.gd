extends "res://scripts/player.gd"

func _get_input():
    if onGround:
        if Input.is_action_just_pressed("attack"):
            attacking = true
            if $AnimationPlayer.current_animation == "Still R" or $AnimationPlayer.current_animation == "Jump R" or $AnimationPlayer.current_animation == "Walk R":
                $AnimationPlayer.play("Attack R")
            else:
                $AnimationPlayer.play("Attack L")


func _physics_process(delta):
    _get_input()
    
    if $Player.frame == 17:
        attacking = false