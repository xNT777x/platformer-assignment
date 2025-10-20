extends PlayerState
class_name PlayerStateFalling

const GRAVITY_MULT: float = 1.5 # Fast falling

func _physics_process(delta: float) -> void:
	fall(delta)
	handle_horizontal_movement()
	animation_player.play("fall")
	
	if player.is_on_floor():
		if player.velocity.x != 0:
			state_transition_requested.emit(Player.State.MOVING)
		else:
			state_transition_requested.emit(Player.State.IDLING)
		

func fall(delta: float) -> void:
	player.velocity.y += player.gravity * GRAVITY_MULT * delta

# When player is no longer falling, set velocity to 0
func _exit_tree() -> void:
	player.velocity = Vector2.ZERO
