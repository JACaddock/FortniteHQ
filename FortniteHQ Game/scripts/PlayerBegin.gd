extends KinematicBody2D

var speed = 200
#const scene_up = Vector2(0, -1)
const JUMP_POWER = -250
const GRAVITY = 10
const FLOOR = Vector2(0, -1)
var onGround = false
var velocity = Vector2()
var direction
var pos = $Player.position.x


func _ready():
    velocity.x = speed
    anim_switch("Walk R")


func _physics_process(delta):

    velocity = move_and_slide( velocity, FLOOR )
    pos += delta + $Player.position.x 
    print(pos)
    
    if pos >= 1000 and pos < 2200:
        velocity.x = 0
        anim_switch("Still R")
        
    elif pos >= 2200 and pos < 3200:
        velocity.x = speed
        anim_switch("Walk R")
    
    elif pos >= 3200:
        velocity.x = 0
        anim_switch("Still R")
         

"""
func get_input():                
    if Input.is_action_pressed('ui_right'):

        
    elif Input.is_action_pressed("ui_left"):
        velocity.x = -speed
        $Player.flip_h = true
        
    else:
        velocity.x = 0
        
    if Input.is_action_just_pressed("jump"):
        if onGround:
            velocity.y = JUMP_POWER
            onGround = false


func _physics_process(delta):
    get_input()
    
    if velocity.x != 0:
	    if velocity.x > 0:

	    else:
		    anim_switch("Walk L")
		    direction = -1
    else: 
	    if direction == 1:
		    anim_switch("Still R")
	    else:
		    anim_switch("Still L")
        
    velocity.y += GRAVITY + (delta * 10)
    
    if is_on_floor():
        onGround = true
    else:
        onGround = false
  """ 

            

func anim_switch(animation):
    var newanim = str(animation)
    if $AnimationPlayer.current_animation != newanim:
        $AnimationPlayer.play(newanim)