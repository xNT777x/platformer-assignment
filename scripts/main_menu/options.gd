extends Control

@onready var options: Panel = %opts
@onready var container: VBoxContainer = $"../VBoxContainer"
signal request_close

func _on_back_pressed() -> void:
	print("Back Button pressed")
	options.visible = false	
	if container:
		container.visible = true
	get_tree().paused = false
	
	emit_signal("request_close")
