extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	anim.play("Idle")

func _on_body_entered(body:Node)->void:
	if(body.is_in_group("Player")):
		queue_free()
		#Update UI later
	
