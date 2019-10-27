extends KinematicBody2D

var speed = 200
#const scene_up = Vector2(0, -1)
const GRAVITY = 10
const FLOOR = Vector2(0, -20)
var velocity = Vector2()
var direction
var pos = velocity.x


func _ready():
    velocity.x = 0
    anim_switch("Walk L")


func _physics_process(delta):
    
    velocity.y += GRAVITY + (delta * 10)
    velocity = move_and_slide( velocity, FLOOR )
    pos -= delta - velocity.x 
    print("slime : ", pos )
    
    if pos <= -4.5 and pos > -34000:
        velocity.x = -speed
    
    else:
        velocity.x = 0
                     

func anim_switch(animation):
    var newanim = str(animation)
    if $AnimationPlayer.current_animation != newanim:
        $AnimationPlayer.play(newanim)