extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var take_damage: Area2D = $TakeDamage
@onready var character_shape: CollisionShape2D = $CharacterShape
@onready var timer: Timer = $Timer
@onready var wall_detector: Area2D = $WallDetector
@onready var hearts_parent: HBoxContainer = $HBoxContainer


@export var move_speed: float =120.0
@export var idle_time: float =2.0

@export var attack_damage: float = 0.5
@export var anticipation_duration: float = 0.7
@export var attack_duration: float = 0.25
@export var attack_hit_time: float = 0.1

@export var max_health: int = 5 # Default 5
var current_health: int = 5
var hearts_list: Array[TextureRect] = []
var _death_stage := 0
var is_dead :bool= false

@export var hurt_invuln_time: float = 1.0
var invulnerable := false
var _invuln_timer: Timer

var direction: int =1
var is_waiting: bool =false

var is_attacking: bool = false
var player_in_range: Node = null
var attack_timer: Timer
var anticipation_timer: Timer
var damage_applied_this_attack: bool = false

signal game_win

func _ready() -> void:
	for child in hearts_parent.get_children():
		if child is TextureRect or child is Control:
			hearts_list.append(child)
			current_health = max_health
			_apply_health_ui()
	timer.one_shot = true
	timer.wait_time = idle_time
	animated_sprite_2d.play("Run")
	wall_detector.area_entered.connect(_on_wall_detector_area_entered)
	timer.timeout.connect(_on_timer_timeout)
	if attack_area.has_signal("body_entered"):
	
		attack_area.body_entered.connect(_on_attack_area_entered_body)
		attack_area.body_exited.connect(_on_attack_area_exited_body)

# Timers for anticipation and attack
	anticipation_timer = Timer.new()
	anticipation_timer.one_shot = true
	add_child(anticipation_timer)
	anticipation_timer.timeout.connect(_on_anticipation_finished)

	attack_timer = Timer.new()
	attack_timer.one_shot = true
	add_child(attack_timer)
	attack_timer.timeout.connect(_on_attack_finished)
	
	_invuln_timer = Timer.new()
	_invuln_timer.one_shot = true
	add_child(_invuln_timer)
	_invuln_timer.timeout.connect(func(): invulnerable = false)
func _physics_process(_delta: float) -> void:
	if is_waiting or is_attacking:
		velocity.x = 0.0
	else:
		velocity.x = direction * move_speed
	move_and_slide()
# Flip the sprite based on direction (assuming right is default)
	animated_sprite_2d.flip_h = direction > 0

	if is_attacking and player_in_range and attack_timer.time_left > 0.0:
		var elapsed := attack_duration - attack_timer.time_left
		if not damage_applied_this_attack and elapsed >= attack_hit_time:
			_apply_attack_damage()

func _on_wall_detector_area_entered(area: Area2D) -> void:
# Ignore walls if currently attacking
	if is_attacking:
		return
	if area.name == "Wall" or area.is_in_group("Wall"):
		_begin_wait_and_turn()

func _begin_wait_and_turn() -> void:
	if is_waiting or is_attacking:
		return
	is_waiting = true
	animated_sprite_2d.play("Idle")
	velocity.x = 0.0
	timer.start()

func _on_timer_timeout() -> void:
# After waiting, flip direction and run
	direction *= -1
	is_waiting = false
	if not is_attacking:
		animated_sprite_2d.play("Run")

func _on_attack_area_entered_body(body: Node) -> void:
# Adjust this condition to your player type/group
	if body.is_in_group("Player"):
		player_in_range = body
		_start_attack_sequence()

func _on_attack_area_exited_body(body: Node) -> void:
	if player_in_range == body:
		player_in_range = null

func _start_attack_sequence() -> void:
	if is_attacking:
		return
	is_attacking = true
	damage_applied_this_attack = false
	velocity.x = 0.0

# Play anticipation animation if exists, otherwise use "Attack" directly
	animated_sprite_2d.play("Anticipation")
	

	anticipation_timer.start(anticipation_duration)
func _on_anticipation_finished() -> void:
# Start the actual attack window
	animated_sprite_2d.play("Attack")
	attack_timer.start(attack_duration)

func _on_attack_finished() -> void:
# End attack, reset state and animation
	is_attacking = false
	damage_applied_this_attack = false

# If still waiting (e.g., because of wall pause), stay idle. Else resume run.
	if is_waiting:
		animated_sprite_2d.play("Idle")
	else:
		animated_sprite_2d.play("Run")
func _apply_attack_damage() -> void:

	if "take_damage" in player_in_range:
		player_in_range.take_damage(attack_damage)
	elif player_in_range.has_method("take_damage"):
		player_in_range.take_damage(attack_damage)
	else:
		pass
	damage_applied_this_attack = true

func _apply_health_ui() -> void:
# current_health = clamp(current_health, 0, max_health)

# Show only as many containers as max_health
	for i in range(hearts_list.size()):
		hearts_list[i].visible = i < max_health

	# Update filled vs empty hearts safely
	for i in range(min(max_health, hearts_list.size())):
		var heart = hearts_list[i]
		var filled = heart.get_node_or_null("heart")
		var empty = heart.get_node_or_null("heart_bg")
		if filled:
			filled.visible = i < current_health
		if empty:
			empty.visible = i >= current_health

func _on_hurtbox_area_entered(area: Area2D) -> void:
# Only react to sword hitboxes
	if area.is_in_group("Sword_hitbox"):
		taken_damage(1)

func taken_damage(amount: int) -> void:
	if invulnerable or current_health <= 0 or is_dead:
		return

	current_health = max(0, current_health - amount)
	_apply_health_ui()

	# Grant brief invulnerability
	invulnerable = true
	_invuln_timer.start(hurt_invuln_time)

	if current_health > 0:
		_play_hurt()
	else:
		is_dead = true
		_cancel_attack_and_wait()
		_play_death_sequence()
func _play_hurt() -> void:
	animated_sprite_2d.play("Hit")
	animated_sprite_2d.animation_finished.connect(_on_hurt_anim_finished, CONNECT_ONE_SHOT)

func _on_hurt_anim_finished() -> void:
	if current_health <= 0:
		return
	if is_attacking:
		animated_sprite_2d.play("Attack") # or whatever is appropriate
	elif is_waiting:
		animated_sprite_2d.play("Idle")
	else:
		animated_sprite_2d.play("Run")
func _play_death_sequence() -> void:
	_death_stage = 0
	animated_sprite_2d.animation_finished.connect(_on_death_anim_finished)
	animated_sprite_2d.play("Dead_hit")

func _on_death_anim_finished() -> void:
	if _death_stage == 0:
		_death_stage = 1
		animated_sprite_2d.play("Dead_ground")
	elif _death_stage == 1:
		animated_sprite_2d.animation_finished.disconnect(_on_death_anim_finished)
	game_win.emit()
	queue_free()

func _cancel_attack_and_wait() -> void:
# stop all timers and states that could revert animations
	is_attacking = false
	is_waiting = false
	damage_applied_this_attack = false
	if anticipation_timer: anticipation_timer.stop()
	if attack_timer: attack_timer.stop()
	if timer: timer.stop()
