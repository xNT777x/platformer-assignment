extends CharacterBody2D
class_name Player

enum State {MOVING, JUMPING, FALLING, IN_COYOTE, IDLING}

@onready var player_animation: AnimatedSprite2D = %PlayerAnimation

var current_state: PlayerState = null
var state_factory := PlayerStateFactory.new()
var facing

@export var speed: int = 500
@export var gravity: int = 2000
@export var jump_power: float = 1000

func _ready() -> void:
	switch_state(State.IDLING)

func _physics_process(_delta: float) -> void:
	move_and_slide()

func switch_state(state: State) ->  void:
	if current_state != null:
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, player_animation)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerStateMachine: " + str(state)
	call_deferred("add_child", current_state)
