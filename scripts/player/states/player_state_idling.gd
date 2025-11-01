extends PlayerState
class_name PlayerStateIdling

func _physics_process(_delta: float) -> void:
	animation_player.play("idle")
	
	if !player.is_on_floor():
		state_transition_requested.emit(Player.State.FALLING)
	elif Input.is_action_pressed("jump"):
		state_transition_requested.emit(Player.State.JUMPING)
	elif Input.is_action_pressed("left") || Input.is_action_pressed("right"):
		state_transition_requested.emit(Player.State.MOVING)
	elif Input.is_action_just_pressed("attack"):
		player.attack()
