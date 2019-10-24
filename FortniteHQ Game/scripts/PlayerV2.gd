extends KinematicBody2D


signal health_updated(health)
signal max_health_updated(max_health)
signal killed()

const JUMP_POWER = -200
const GRAVITY = 10
const FLOOR = Vector2(0, -1)
var onGround = false
var velocity = Vector2()
var direction = 1
var attacking = false
var alive = true

export (float) var max_health = 5
export (float) var strength = 2
export (float) var speed = 100

onready var health = max_health setget _set_health
onready var IFrameTimer = $IFrames
onready var effectsplayer = $EffectsPlayer

func _ready():
    anim_switch("Still R")
    emit_signal("max_health_updated", max_health)
    

func get_input():                
    if Input.is_action_pressed('ui_right'):
        direction = 1
        velocity.x = speed
        
    elif Input.is_action_pressed("ui_left"):
        direction = -1
        velocity.x = -speed
        
    else:
        velocity.x = 0
        
    if Input.is_action_pressed("jump"):
        if onGround:
            velocity.y = JUMP_POWER
            onGround = false
            
    if Input.is_action_just_pressed("attack"):
        attacking = true
        $SwordSwing.start()
        
        
func get_anim():
    if onGround and not attacking:
        if velocity.x != 0:
            if velocity.x > 0:
                anim_switch("Walk R")
                direction = 1
            else:
                 anim_switch("Walk L")
                 direction = -1
        elif velocity.x == 0: 
            if direction == 1:
            	anim_switch("Still R")
            else:
            	anim_switch("Still L")
            
    elif attacking:
        if direction == 1:
            anim_switch("Attack R")
        else:
            anim_switch("Attack L")
                        
    else:
        if direction == 1 and velocity.y < 0:
            anim_switch("Jump R")
        elif velocity.y < 0:
            anim_switch("Jump L")
    


func _physics_process(delta):
    if alive:
        get_input()
        get_anim()
        
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
      

func damage(amount):
    if IFrameTimer.is_stopped():
        IFrameTimer.start()
        _set_health(health - amount)
        effectsplayer.play("Damage")
        effectsplayer.queue("IFrame")
    
        
func kill():
    alive = false
    anim_switch("Dead")
    IFrameTimer.stop()
    effectsplayer.stop()

    
func _set_health(value):
    var prev_health = health
    health = clamp(value, 0, max_health)
    if health != prev_health:
        emit_signal("health_updated", health)
        if health == 0:
            kill()
            emit_signal("killed")
            

func _on_IFrames_timeout():
    $EffectsPlayer.stop()


func _on_SwordSwing_timeout():
    attacking = false


func _on_SwordArea_body_entered(body):
    if body.is_in_group("enemies"):
        body.damage(strength)