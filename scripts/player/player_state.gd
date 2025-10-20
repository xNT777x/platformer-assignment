extends Node
class_name PlayerState

signal state_transition_requested(new_state: Player.State)

var player: Player = null
var animation_player: AnimatedSprite2D = null

func setup(ctx_player: Player, ctx_anim: AnimatedSprite2D) -> void:
	player = ctx_player
	animation_player = ctx_anim

func handle_horizontal_movement() -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	
	player.velocity.x = direction.x * player.speed
	
