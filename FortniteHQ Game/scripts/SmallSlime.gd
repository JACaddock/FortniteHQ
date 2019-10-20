extends "res://scripts/entity.gd"

func _on_Head_body_entered(body):
    if body.is_in_group("player"):
        queue_free()    
