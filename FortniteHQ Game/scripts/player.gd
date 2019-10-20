extends KinematicBody2D

var speed = 200
#const scene_up = Vector2(0, -1)
const JUMP_POWER = -300
const GRAVITY = 10
const FLOOR = Vector2(0, -1)
var onGround = true
var velocity = Vector2()
var direction
var hasHealth = true
var attacking = false


func get_input():                
    if Input.is_action_pressed('ui_right'):
        velocity.x = speed
        $Player.flip_h = false
        
    elif Input.is_action_pressed("ui_left"):
        velocity.x = -speed
        $Player.flip_h = true
        
    else:
        velocity.x = 0
        
    if Input.is_action_pressed("jump"):
        if onGround:
            velocity.y = JUMP_POWER
            onGround = false


func _physics_process(delta):
    get_input()
    
    if onGround and not attacking:
        if velocity.x != 0:
        	if velocity.x > 0:
                anim_switch("Walk R")
                direction = 1
        	else:
        		anim_switch("Walk L")
        		direction = -1
        else: 
        	if direction == 1:
        		anim_switch("Still R")
        	else:
        		anim_switch("Still L")
        
    else:
        if velocity.x > 0 and velocity.y < 0:
            anim_switch("Jump R")
        elif velocity.y < 0:
            anim_switch("Jump L")
            
    velocity.y += GRAVITY + (delta * 10)
        
    if is_on_floor():
        onGround = true
    else:
        onGround = false
            
    velocity = move_and_slide( velocity, FLOOR )
                

func anim_switch(animation):
    var newanim = str(animation)
    if $AnimationPlayer.current_animation != newanim:
        $AnimationPlayer.play(newanim)

func _on_Hitbox_body_entered(body):
    if body.is_in_group("enemies"):
        queue_free()       