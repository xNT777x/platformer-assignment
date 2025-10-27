class_name StarStateFactory

var states: Dictionary

func _init() -> void:
	states = {
		Star.State.MOVING: StarStateMoving,
		Star.State.HURT: StarStateHurt,
		Star.State.DEATH: StarStateDeath,
	}
	
func get_fresh_state(state: Star.State) -> StarState:
	assert(states.has(state), "State (Star) doesn't exist.")
	return states.get(state).new()
