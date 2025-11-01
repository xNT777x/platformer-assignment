extends CharacterBody2D
class_name Player

enum State {MOVING, JUMPING, FALLING, IN_COYOTE, IDLING, ATTACK, HURT, DEATH}

@onready var player_animation: AnimatedSprite2D = %PlayerAnimation

var current_state: Node =null
var state_factory := PlayerStateFactory.new()
var facing_left = false

@export var speed: int = 500
@export var gravity: int = 2000
@export var jump_power: float = 1000
@export var max_health: int = 3 # TODO: Make health sprites scalable

var current_health: int
var hearts_list: Array[TextureRect]

const GRAVITY_MULT: float = 1.5 # Fast falling

func _ready() -> void:
	current_health = max_health
	
	# Add hearts to list. Initially make them all invisible
	var hearts_parent = $HealthBar/HBoxContainer
	for child in hearts_parent.get_children():
		hearts_list.append(child)
		child.visible = false
	
	# Make hearts visible according to max health
	for i in range(max_health):
		hearts_list[i].visible = true
	
	connect("body_entered", Callable(self, "_on_hurtbox_entered"))
	
	switch_state(State.IDLING)

func _physics_process(_delta: float) -> void:
	_debug()
	#process_current_health()
	
	handle_facing()
	flip_sprite(facing_left)
	move_and_slide()

func switch_state(state: State) ->  void:
	if current_state != null:
		current_state.queue_free()
	
	current_state = state_factory.get_fresh_state(state)
	current_state.setup(self, player_animation)
	current_state.state_transition_requested.connect(switch_state.bind())
	current_state.name = "PlayerStateMachine: " + str(state)
	call_deferred("add_child", current_state)

func handle_facing() -> void:
	if velocity.x < 0:
		facing_left = true
	elif velocity.x > 0:
		facing_left = false

func flip_sprite(flag: bool) -> void:
	player_animation.flip_h = flag
	
func _on_hurtbox_entered(body: Node) -> void:
	if body.is_in_group("Enemy"):
		if current_health > 0:
			switch_state(State.HURT)
		
func fall(delta: float) -> void:
	velocity.y += gravity * GRAVITY_MULT * delta

func _debug() -> void:
	if Input.is_action_just_pressed("debug_hurt_player"):
		switch_state(State.HURT)

func process_current_health() -> void:
	pass
