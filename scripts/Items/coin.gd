extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var collect_coin_sfx: AudioStreamPlayer = $CollectCoinSfx

func _ready() -> void:
	anim.play("Idle")

func _on_body_entered(body:Node)->void:
	if(body.is_in_group("Player")):
		anim.visible=false
		collision.disabled=true
		collect_coin_sfx.play() 


func _on_collect_coin_sfx_finished() -> void:
	queue_free()
