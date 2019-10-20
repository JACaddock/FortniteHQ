extends "res://scripts/player.gd"

func _get_input():
    if onGround:
        if Input.is_action_just_pressed("attack"):
            attacking = true
            if $AnimationPlayer.current_animation == "Still R" or $AnimationPlayer.current_animation == "Walk R" or $AnimationPlayer.current_animation == "Jump R":
                $AnimationPlayer.play("Attack R")
            elif $AnimationPlayer.current_animation == "Still L" or $AnimationPlayer.current_animation == "Walk L" or $AnimationPlayer.current_animation == "Jump L":
                $AnimationPlayer.play("Attack L")


func _physics_process(delta):
    _get_input()
    
    if $Player.frame == 17 :
        attacking = false