extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var timer: Timer = $Timer

@export var heal_amount: int = 1
@export var auto_free: bool = true # optionally free after pickup

func _ready() -> void:
	animated_sprite_2d.play("Idle")
	
func _on_body_entered(body:Node)->void:
	if(body.is_in_group("Player")):
		if body.heal(heal_amount):
			animated_sprite_2d.visible=false
			collision_shape_2d.disabled=true
		else:
			pass
func _take_effect()->void:
	pass
