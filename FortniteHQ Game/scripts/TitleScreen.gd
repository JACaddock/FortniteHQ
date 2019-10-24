extends Control


func _ready():
    $AnimationPlayer.play("Jell")
    

func _on_TextureButton_pressed():
    get_tree().change_scene("scenes/Level1.tscn")
