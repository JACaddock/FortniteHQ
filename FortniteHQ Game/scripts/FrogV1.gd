extends KinematicBody2D

func _physics_process(delta):
    if not $AudioStreamPlayer2D2.is_playing():
        $AnimatedSprite.stop()


func _on_SlimeBoss_killed():
    $AudioStreamPlayer2D2.play()
    $AnimatedSprite.play("talk")