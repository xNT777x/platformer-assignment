extends PlayerState
class_name PlayerStateHurt

func _ready() -> void:
	var new_health = player.current_health - 1
	
	player.current_health = new_health
	
	if new_health <= 0:
		state_transition_requested.emit(Player.State.DEATH)
	
	print(player.current_health)
	animation_player.play("hurt")
	
func _physics_process(_delta: float) -> void:
	
	if animation_player.is_playing():
		pass
	else:
		_on_hurt_anim_finished()
		

func _on_hurt_anim_finished() -> void:
	print("Hurt done")
	state_transition_requested.emit(Player.State.IDLING)
