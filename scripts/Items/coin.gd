extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var collect_coin_sfx: AudioStreamPlayer = $CollectCoinSfx

"""
@onready var coin_label: Label = $"../../../setting/Label"
var num_coin_collected := 0
"""

func _ready() -> void:
	anim.play("Idle")

func _on_body_entered(body:Node)->void:
	if(body.is_in_group("Player")):
		anim.visible=false
		collision.disabled=true
		collect_coin_sfx.play() 
		# add_coin()
		GameState.add_coins(1)
		await collect_coin_sfx.finished
		
func _on_collect_coin_sfx_finished() -> void:
	queue_free()

"""
func add_coin(amount := 1):
	num_coin_collected += amount
	update_text()

func update_text():
	if is_instance_valid(coin_label):
		coin_label.text = "x%d" % num_coin_collected
"""		
