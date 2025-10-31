extends Control

@onready var options: Panel = %Options
@onready var container: VBoxContainer = $"../VBoxContainer"

func _on_back_pressed() -> void:
	print("Back Button pressed")
	options.visible = false	
	if container:
		container.visible = true
