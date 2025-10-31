class_name PlayerStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.JUMPING: PlayerStateJumping,
		Player.State.FALLING: PlayerStateFalling,
		Player.State.IN_COYOTE: PlayerStateInCoyote,
		Player.State.IDLING: PlayerStateIdling,
		Player.State.HURT: PlayerStateHurt,
		Player.State.DEATH: PlayerStateDeath,
	}

func get_fresh_state(state: Player.State) -> PlayerState:
	assert(states.has(state), "State (Player) doesn't exist.")
	return states.get(state).new()
