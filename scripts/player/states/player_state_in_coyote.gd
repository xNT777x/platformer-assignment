extends PlayerState
class_name PlayerStateInCoyote

const MAX_COYOTE_FRAMES_60: int = 5

var time_start = Time.get_ticks_msec()

func _physics_process(_delta: float) -> void:
	handle_horizontal_movement()
	play_animation()
	
	var curr_time = Time.get_ticks_msec()
	var max_coyote_time: float = MAX_COYOTE_FRAMES_60 / 60.0 * 1000
	if curr_time - time_start >= max_coyote_time:
		state_transition_requested.emit(Player.State.FALLING)
	elif Input.is_action_pressed("jump"):
		state_transition_requested.emit(Player.State.JUMPING)
	
func play_animation() -> void:
	if player.velocity.x == 0:
		animation_player.play("idle")
	else:
		animation_player.play("move")
