extends PlayerState
class_name PlayerStateDeath

var death_anim_finished: bool

func _ready() -> void:
	death_anim_finished = false
	
	animation_player.play("death_hit")
	
func _physics_process(delta: float) -> void:
	player.fall(delta)
	if player.is_on_floor() and death_anim_finished == false:
		death_anim_finished = true
		animation_player.play("death_anim")
