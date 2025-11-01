extends Node2D

@onready var options: Panel = $opt/Options/opts
@onready var back: Button = $opt/Options/opts/back
@onready var quit: Button = $setting/quit
@onready var options_menu: Control = $opt/Options

func _ready() -> void:
	options.visible = false	
	quit.visible = false
	
	options_menu.request_close.connect(on_options_close)

func _on_button_pressed() -> void:
	print("Setting Button pressed")
	options.visible = true	
	quit.visible = true
	get_tree().paused = true

func _on_quit_pressed() -> void:
	quit.visible = false	
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	
func on_options_close():
	quit.visible = false	
	
