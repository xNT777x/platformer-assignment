extends PlayerState
class_name PlayerStateAttack


func _ready() -> void:
	player.velocity.x = 0
	player.sword_hitbox.disabled = false
	
	animation_player.play("attack3")
	animation_player.connect("animation_finished", Callable(self, "_on_attack_finished"))
	
func _on_attack_finished() -> void:
	state_transition_requested.emit(Player.State.IDLING)

func _exit_tree() -> void:
	player.sword_hitbox.disabled = true
