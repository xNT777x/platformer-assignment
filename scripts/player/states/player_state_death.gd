extends PlayerState
class_name PlayerStateDeath

const DEATH_KNOCKBACK_X: int = 500
const DEATH_KNOCKBACK_Y: int = 500

var death_anim_played: bool

func _ready() -> void:
	death_anim_played = false
	
	knockback()
	animation_player.play("death_hit")
	await wait(3)
	player.game_over.emit()
	
func _physics_process(delta: float) -> void:
	player.fall(delta)
	if player.is_on_floor() and !death_anim_played:
		death_anim_played = true
		player.velocity.x = 0
		animation_player.play("death_anim")
		
func knockback() -> void:
	player.velocity.y = -DEATH_KNOCKBACK_Y
	player.velocity.x = DEATH_KNOCKBACK_X if player.facing_left else -DEATH_KNOCKBACK_X

func wait(time_sec: int) -> void:
	await get_tree().create_timer(time_sec, false, false, true).timeout
