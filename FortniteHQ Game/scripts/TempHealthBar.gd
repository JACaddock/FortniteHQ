extends Control

onready var healthbarover = $HealthBarOver
onready var healthbarunder = $HealthBarUnder
onready var updatetween = $UpdateTween

export (Color) var healthy_colour = Color.green
export (Color) var caution_colour = Color.yellow
export (Color) var danger_colour = Color.red
export (float, 0, 1, 0.05) var caution_zone = 0.5
export (float, 0, 1, 0.05) var danger_zone = 0.2


func _on_health_updated(health):
    healthbarover.value = health
    updatetween.interpolate_property(healthbarunder, "value", healthbarunder.value, health, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.4)
    updatetween.start()
    
    _assign_colour(health)
        
        
func _assign_colour(health):
    if health < healthbarover.max_value * danger_zone:
        healthbarover.tint_progress = danger_colour
    elif health < healthbarover.max_value * caution_zone:
        healthbarover.tint_progress = caution_colour
    else:
        healthbarover.tint_progress = healthy_colour
        

func _on_max_health_updated(max_health):
    healthbarover.max_value = max_health
    healthbarunder.max_value = max_health
    healthbarunder.value = max_health
    healthbarover.value = max_health