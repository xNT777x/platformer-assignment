extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sfx: AudioStreamPlayer = $CollectCoinSfx

var collected := false

func _ready() -> void:
	anim.play("Idle")

func _on_body_entered(body: Node) -> void:
	if collected:
		return
	if not body.is_in_group("Player"):
		return

	collected = true                       
	collision.disabled = true
	set_deferred("monitoring", false)       
	set_deferred("monitorable", false)

	GameState.add_coins(1)
	anim.visible = false
	sfx.play()
	await sfx.finished
	queue_free()
