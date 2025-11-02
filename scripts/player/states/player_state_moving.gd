extends Node
# class_name Player

signal state_transition_requested(next_state: int)

@export_node_path("CharacterBody2D") var player_path: NodePath
var player: Player
var animation_player: AnimatedSprite2D

func _ready() -> void:
	if player_path != NodePath():
		player = get_node(player_path) as Player
	else:
		player = owner as Player

	assert(player != null)

	animation_player = player.get_node("PlayerAnimation") as AnimatedSprite2D
	assert(animation_player != null)

	player.velocity.y = 0

func _physics_process(_delta: float) -> void:
	handle_horizontal_movement()
	animation_player.play("run")

	if player.velocity == Vector2.ZERO:
		state_transition_requested.emit(Player.State.IDLING)
	elif Input.is_action_pressed("up"):
		state_transition_requested.emit(Player.State.JUMPING)
<<<<<<< Updated upstream:scripts/player/states/player_state_moving.gd
	elif !player.is_on_floor():
		state_transition_requested.emit(Player.State.IN_COYOTE)
	elif Input.is_action_just_pressed("attack"):
		player.attack()
=======
	elif not player.is_on_floor():
		state_transition_requested.emit(Player.State.FALLING)

func handle_horizontal_movement() -> void:
	var dir := Input.get_axis("left", "right")
	player.velocity.x = dir * player.speed
	if dir != 0:
		player.facing_right = dir > 0
		player.anim.flip_h = not player.facing_right
>>>>>>> Stashed changes:scripts/player/player_state_moving.gd
