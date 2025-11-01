extends Node2D

@onready var options: Panel = $opt/Options/Options

func _ready() -> void:
	options.visible = false	

func _on_button_pressed() -> void:
	print("Setting Button pressed")
	options.visible = true	
