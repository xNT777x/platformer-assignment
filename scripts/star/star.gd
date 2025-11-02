extends CharacterBody2D
class_name Star

enum State {MOVING, HURT, DEATH}

@onready var star_animation: AnimatedSprite2D = %StarAnimation

var current_state: StarState = null
var state_factory := StarStateFactory.new()
var facing_left = false

@export var speed: int = 500
@export var gravity: int = 2000

func _ready() -> void:
	switch_state(State.MOVING)

func _physics_process(_delta: float) -> void:
	handle_facing()
	flip_sprite()
	move_and_slide()

func switch_state(state: State) ->  void:
	if current_state != null:
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, star_animation)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "StarStateMachine: " + str(state)
	call_deferred("add_child", current_state)

func handle_facing() -> void:
	if velocity.x < 0:
		facing_left = true
	elif velocity.x > 0:
		facing_left = false

func flip_sprite() -> void:
	# player_animation.flip_h = facing_left
	pass
