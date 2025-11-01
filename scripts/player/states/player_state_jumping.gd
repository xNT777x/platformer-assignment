extends PlayerState
class_name PlayerStateJumping
	
func _ready() -> void:
	jump()
	animation_player.play("jump")

func _physics_process(delta: float) -> void:
	handle_gravity_on_jump(delta)
	handle_horizontal_movement()
	
	if !Input.is_action_pressed("jump") || player.velocity.y >= 0:
		state_transition_requested.emit(Player.State.FALLING)

func jump() -> void:
	player.velocity.y = -player.jump_power

func handle_gravity_on_jump(delta: float) -> void:
	player.velocity.y += player.gravity * delta

func _exit_tree() -> void:
	player.velocity.y = 0
