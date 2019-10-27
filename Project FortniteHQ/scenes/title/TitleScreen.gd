extends Control


func _ready():
    $AnimationPlayer.play("Jell")
    

func _on_TextureButton_pressed():
    return get_tree().change_scene("scenes/levels/level1/Level1.tscn")