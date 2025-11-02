extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

@export var speed_multiplier: float = 1.5
@export var duration_sec: float = 10.0
@export var consume_immediately: bool = true

func _ready() -> void:
	animated_sprite_2d.play("Idle")

func _on_body_entered(body:Node)->void:
	if(body.is_in_group("Player")):
		body.apply_speed_boost(speed_multiplier, duration_sec)
		animated_sprite_2d.visible=false
		collision_shape_2d.disabled=true
