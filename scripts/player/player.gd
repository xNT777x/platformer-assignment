extends CharacterBody2D
class_name Player

enum State {MOVING, JUMPING, FALLING, IN_COYOTE, IDLING, ATTACK, HURT, DEATH}

signal game_over

@onready var player_animation: AnimatedSprite2D = %PlayerAnimation
@onready var sword_hitbox = $PlayerAnimation/SwordHitbox/hitbox

var current_state: Node =null
var state_factory := PlayerStateFactory.new()
var facing_left = false
var _delay_timer: Timer

var invulnerable: bool = false
@export var hurt_invuln_time: float = 0.4
var _invuln_timer: Timer

var _invuln_tween: Tween
const COLOR_WHITE := Color(1, 1, 1, 1)
const COLOR_BOOST := Color(0.55, 0.75, 1.0, 1.0) # moderate blue

@export var speed: int = 500
@export var gravity: int = 2000
@export var jump_power: float = 1000
@export var max_health: int 
var _base_speed: int
var _speed_boost_timer: Timer
var _speed_multiplier: float = 1.0

var current_health: int
var hearts_list: Array[TextureRect]

const GRAVITY_MULT: float = 1.5 # Fast falling

func _ready() -> void:
	# Add hearts to list. Initially make them all invisible
	var hearts_parent = $HealthBar/HBoxContainer
	for child in hearts_parent.get_children():
		hearts_list.append(child)
		child.visible = false
	_apply_difficulty(GameSettings.difficulty)                 
	GameSettings.difficulty_changed.connect(_apply_difficulty)
	_invuln_timer = Timer.new()
	_invuln_timer.one_shot = true
	add_child(_invuln_timer)
	_invuln_timer.timeout.connect(_on_invuln_end)
	player_animation.modulate = COLOR_WHITE
	# Make hearts visible according to max health
	"""
	for i in range(max_health):
		hearts_list[i].visible = true
	"""
	_base_speed = speed
	_speed_boost_timer = Timer.new()
	_speed_boost_timer.one_shot = true
	add_child(_speed_boost_timer)
	_speed_boost_timer.timeout.connect(_end_speed_boost)
	current_health = max_health
	sword_hitbox.disabled = true
	
	
	connect("body_entered", Callable(self, "_on_hurtbox_entered"))
	
	switch_state(State.IDLING)

func _physics_process(_delta: float) -> void:
	_debug()
	_process_current_health()
	
	handle_facing()
	@warning_ignore("standalone_ternary")
	flip_sprite(facing_left) if current_state not in [State.HURT, State.DEATH] else flip_sprite(!facing_left)
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
	player_animation.scale.x = player_animation.scale.y * -1 if flag else player_animation.scale.y * 1
	

func apply_speed_boost(multiplier: float, duration: float) -> void:
# If already boosted, restart with the new parameters
	_speed_multiplier = max(0.0, multiplier)
	speed = int(round(_base_speed * _speed_multiplier))
	_speed_boost_timer.start(duration)
	_apply_visual_for_effects()
	
func _end_speed_boost() -> void:
	_speed_multiplier = 1.0
	speed = _base_speed
	_apply_visual_for_effects()
func _on_hurtbox_entered(body: Node) -> void:
	if body.is_in_group("Enemy"):
		if current_health > 0:
			switch_state(State.HURT)
		
func fall(delta: float) -> void:
	velocity.y += gravity * GRAVITY_MULT * delta

func _debug() -> void:
	if Input.is_action_just_pressed("debug_hurt_player"):
		switch_state(State.HURT)
	
# Health based on Level
func _apply_difficulty(d:int) -> void:
	match d:
		GameSettings.Difficulty.EASY:   max_health = 5
		GameSettings.Difficulty.MEDIUM: max_health = 3
		GameSettings.Difficulty.HARD:   max_health = 1
	_apply_health_ui()
	
func _apply_health_ui() -> void:
	for i in hearts_list.size():
		hearts_list[i].visible = i < max_health
		
	current_health = min(current_health, max_health)
	
func _process_current_health() -> void:
	for i in range(max_health):
		hearts_list[i].get_child(2).visible = false
	
	for i in range(current_health):
		hearts_list[i].get_child(2).visible = true
func apply_golden_skull() -> void:
	# Set invulnerability window to 5 seconds for future hits
	hurt_invuln_time = 4.0
	# Optionally make the player immediately invulnerable for 5s on pickup:
	invulnerable = true
	_invuln_timer.stop()
	_invuln_timer.start(hurt_invuln_time)
	_apply_visual_for_effects()
func heal(amount: int) -> bool:
	var old_health = current_health
	current_health = min(max_health, current_health + amount)
	if current_health != old_health:
		_apply_health_ui()
		return true
	return false
func take_damage(amount: int) -> void:
	if invulnerable:
		return
	current_health = max(0, current_health - amount)
	_apply_health_ui()
	invulnerable = true
	_invuln_timer.start(hurt_invuln_time)
	if current_health > 0:
		switch_state(State.HURT)
	else:
		switch_state(State.DEATH)
		
func attack():
	switch_state(State.ATTACK)
func _on_invuln_end() -> void:
	invulnerable = false
	_stop_invuln_color()
	_apply_visual_for_effects()

func _apply_visual_for_effects() -> void:
	if invulnerable:
		_start_invuln_color()
	elif _speed_boost_timer != null and not _speed_boost_timer.is_stopped():
		_stop_invuln_color()
		player_animation.modulate = COLOR_BOOST
	else:
		_stop_invuln_color()
		player_animation.modulate = COLOR_WHITE

func _start_invuln_color() -> void:
	# Start/ensure an RGB cycling tween while invulnerable
	if _invuln_tween and _invuln_tween.is_running():
		return
	_invuln_tween = create_tween()
	_invuln_tween.set_loops(0) # infinite; we'll stop it when invuln ends
	_invuln_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_invuln_tween.tween_property(player_animation, "modulate", Color(1.0, 0.35, 0.35, 1.0), 0.2)
	_invuln_tween.tween_property(player_animation, "modulate", Color(0.35, 1.0, 0.35, 1.0), 0.2)
	_invuln_tween.tween_property(player_animation, "modulate", Color(0.35, 0.35, 1.0, 1.0), 0.2)

func _stop_invuln_color() -> void:
	if _invuln_tween:
		_invuln_tween.kill()
		_invuln_tween = null
