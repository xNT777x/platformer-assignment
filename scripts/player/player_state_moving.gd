extends PlayerState
class_name PlayerStateMoving

func _ready() -> void:
	player.velocity.y = 0
	
func _physics_process(_delta: float) -> void:
	handle_horizontal_movement()
	animation_player.play("move")
	
	if player.velocity == Vector2.ZERO:
		state_transition_requested.emit(Player.State.IDLING)
	elif Input.is_action_pressed("jump"):
		state_transition_requested.emit(Player.State.JUMPING)
	elif !player.is_on_floor():
		state_transition_requested.emit(Player.State.IN_COYOTE)
