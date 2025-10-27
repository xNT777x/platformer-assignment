extends Node
class_name StarState

signal state_transition_requested(new_state: Star.State)

var enemy: Star = null
var animation_player: AnimatedSprite2D = null

func setup(ctx_enemy: Star, ctx_anim: AnimatedSprite2D) -> void:
	enemy = ctx_enemy
	animation_player = ctx_anim
	
