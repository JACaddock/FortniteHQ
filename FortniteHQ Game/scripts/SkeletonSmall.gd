extends "BasicEnemyAI.gd"


func _ready():
    speed = 70
    $AnimationPlayer.play("Still L")