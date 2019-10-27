extends StaticBody2D


func _on_Area2D_body_entered(body):
    if body.is_in_group("player"):
        return get_tree().change_scene("res://scenes/levels/level2/Level2.tscn")