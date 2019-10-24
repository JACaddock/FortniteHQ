extends StaticBody2D


func _on_Area2D_body_entered(body):
    if body.is_in_group("player"):
        get_tree().change_scene("scenes/Level2.tscn")