extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer
@export var duration_sec: float = 5.0
func _ready() -> void:
	animated_sprite_2d.play("Idle")
	
func _on_body_entered(body:Node)->void:
	if(body.is_in_group("Player")):
		body.apply_golden_skull()
		animated_sprite_2d.visible=false
		collision_shape_2d.disabled=true

func _take_effect()->void:
	pass
