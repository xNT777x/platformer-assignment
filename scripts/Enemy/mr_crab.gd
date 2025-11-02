extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_area: Area2D = $AttackArea
@onready var take_damage: Area2D = $TakeDamage
@onready var character_shape: CollisionShape2D = $CharacterShape
@onready var timer: Timer = $Timer
@onready var wall_detector: Area2D = $WallDetector


@export var move_speed: float =120.0
@export var idle_time: float =2.0

var direction: int =1
var is_waiting: bool =false

func _ready() -> void:
	timer.one_shot = true
	timer.wait_time = idle_time
	animated_sprite_2d.play("Run")
	wall_detector.area_entered.connect(_on_wall_detector_area_entered)
	timer.timeout.connect(_on_timer_timeout)

func _physics_process(_delta: float) -> void:
	if is_waiting:
		velocity.x = 0.0
	else:
		velocity.x = direction * move_speed
	move_and_slide()
# Flip the sprite based on direction (assuming right is default)
	animated_sprite_2d.flip_h = direction > 0

func _on_wall_detector_area_entered(area: Area2D) -> void:
# Only react to areas named "Wall" or with group "Wall"
	if area.name == "Wall" or area.is_in_group("Wall"):
		_begin_wait_and_turn()

func _begin_wait_and_turn() -> void:
	if is_waiting:
		return
	is_waiting = true
	animated_sprite_2d.play("Idle")
	velocity.x = 0.0
	timer.start()

func _on_timer_timeout() -> void:
# After waiting, flip direction and run
	direction *= -1
	is_waiting = false
	animated_sprite_2d.play("Run")
