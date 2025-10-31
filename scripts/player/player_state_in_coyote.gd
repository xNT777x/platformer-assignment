extends PlayerState
class_name PlayerStateInCoyote

const COYOTE_TIME := 0.08     # 80 ms
const JUMP_BUFFER := 0.10     # 100 ms

var coyote_left := 0.0
var jump_buffer_left := 0.0

func enter(_prev):
	coyote_left = COYOTE_TIME

func _physics_process(delta: float) -> void:
	handle_horizontal_movement()
	play_animation()

	if Input.is_action_just_pressed("jump"):
		jump_buffer_left = JUMP_BUFFER
	elif jump_buffer_left > 0.0:
		jump_buffer_left -= delta

	if coyote_left > 0.0:
		coyote_left -= delta

	if (coyote_left > 0.0 or player.is_on_floor()) and jump_buffer_left > 0.0:
		state_transition_requested.emit(Player.State.JUMPING)
		return

	if coyote_left <= 0.0 and not player.is_on_floor():
		state_transition_requested.emit(Player.State.FALLING)

func play_animation() -> void:
	if abs(player.velocity.x) < 0.01:
		animation_player.play("idle")
	else:
		animation_player.play("move")
