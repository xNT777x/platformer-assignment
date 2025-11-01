extends PlayerState
class_name PlayerStateHurt

const HURT_KNOCKBACK_X: int = 500
const HURT_KNOCKBACK_Y: int = 500
var has_knocked_back = false

func _ready() -> void:
	knockback()
	var new_health = player.current_health - 1
	
	player.current_health = new_health
	
	if new_health <= 0:
		state_transition_requested.emit(Player.State.DEATH)
	
	print(player.current_health)
	animation_player.play("hurt")
	
func _physics_process(delta: float) -> void:
	if player.is_on_floor():
		state_transition_requested.emit(Player.State.IDLING)
		
	player.flip_sprite(!player.facing_left)
	player.fall(delta)

func knockback() -> void:
	player.velocity.y = -HURT_KNOCKBACK_Y
	player.velocity.x = HURT_KNOCKBACK_X if player.facing_left else -HURT_KNOCKBACK_X

func _exit_tree() -> void:
	player.velocity.x = 0
	player.flip_sprite(!player.facing_left)
