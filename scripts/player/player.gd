extends CharacterBody2D
class_name Player

<<<<<<< Updated upstream
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

@export var speed: int = 500
@export var gravity: int = 2000
@export var jump_power: float = 1000
@export var max_health: int 

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
	_invuln_timer.timeout.connect(func(): invulnerable = false) 

	# Make hearts visible according to max health
	"""
	for i in range(max_health):
		hearts_list[i].visible = true
	"""
	
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
=======
enum State { IDLING, MOVING, JUMPING, FALLING, IN_COYOTE }

@export var speed: float = 240.0
@export var jump_force: float = 480.0
@export var gravity: float = 1200.0
@export var max_hp: int = 5
@export var invincibility_duration: float = 0.8

var facing_right := true
var hp: int = 0
var invincibility_time_left := 0.0
var spawn_position := Vector2.ZERO
@onready var anim: AnimatedSprite2D = $PlayerAnimation

func _ready() -> void:
	spawn_position = global_position
	hp = max_hp

func _physics_process(delta: float) -> void:
	if invincibility_time_left > 0.0:
		invincibility_time_left = max(invincibility_time_left - delta, 0.0)

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0.0

	# Movement (match your Input Map: left/right/up)
	var dir := Input.get_axis("left", "right")
	velocity.x = dir * speed

	if dir != 0:
		facing_right = dir > 0
		anim.flip_h = not facing_right

	if invincibility_time_left <= 0.0:
		if dir != 0:
			anim.play("run")
		else:
			anim.play("idle")

	# Jump
	if Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = -jump_force
		if invincibility_time_left <= 0.0:
			anim.play("jump")

	move_and_slide()

func bounce(force: float = 420.0) -> void:
	velocity.y = -force

func take_damage(from_pos: Vector2) -> void:
	if invincibility_time_left > 0.0 or hp <= 0:
		return

	hp = max(hp - 1, 0)
	if hp == 0:
		_die()
		return

	invincibility_time_left = invincibility_duration
	var dir: int = int(global_position.x > from_pos.x) - int(global_position.x < from_pos.x)
	velocity = Vector2(220.0 * dir, -320.0)   # knockback
	anim.play("hurt")

func _die() -> void:
	reborn()

func reborn() -> void:
	hp = max_hp
	invincibility_time_left = invincibility_duration
	global_position = spawn_position
	velocity = Vector2.ZERO
	facing_right = true
	anim.flip_h = false
	anim.play("idle")
>>>>>>> Stashed changes
