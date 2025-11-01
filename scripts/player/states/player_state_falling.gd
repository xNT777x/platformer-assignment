extends PlayerState
class_name PlayerStateFalling

func _physics_process(delta: float) -> void:
	player.fall(delta)
	handle_horizontal_movement()
	animation_player.play("fall")
	
	if player.is_on_floor():
		if player.velocity.x != 0:
			state_transition_requested.emit(Player.State.MOVING)
		else:
			state_transition_requested.emit(Player.State.IDLING)
		
# When player is no longer falling, set velocity to 0
func _exit_tree() -> void:
	player.velocity = Vector2.ZERO
