extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var state: StringName = &"idle"
var already_hit: bool = false

func _ready() -> void:
	# Ensure there is an animation named "Idle" initially
	if anim.sprite_frames and anim.sprite_frames.has_animation("Idle"):
		anim.play("Idle")
	connect("body_entered", Callable(self, "_on_body_entered"))
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))

func _on_body_entered(body: Node) -> void:
	if already_hit:
		return
	# If body is in Player group, react
	if body.is_in_group("Player"):
		already_hit = true
		state = &"hit"
		if anim.sprite_frames.has_animation("Hit"):
			anim.play("Hit")
		else:
			queue_free() # Fallback if missing animation

func _on_animation_finished() -> void:
	# Called whenever the current animation finishes
	if state == &"hit":
		state = &"destroyed"
		# Optionally disable collision so it doesn't trigger again
		if is_instance_valid(collision):
			collision.disabled = true
		if anim.sprite_frames.has_animation("Destroyed"):
			anim.play("Destroyed")
		else:
			queue_free()
	elif state == &"destroyed":
		# After destroyed animation, remove the node
		queue_free()
