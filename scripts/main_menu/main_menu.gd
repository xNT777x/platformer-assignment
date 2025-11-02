extends Control

@onready var options: Panel = $Options/opts
# @onready var back_btn: Button = $Options/Options/back
@onready var main_buttons: VBoxContainer = $VBoxContainer
@onready var audio_control: HSlider = $Options/AudioControl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	options.visible = false
	# audio_control

func _on_start_pressed() -> void:
	print("Start Button pressed")
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_options_pressed() -> void:
	print("Options Button pressed")
	main_buttons.visible = false
	options.visible = true
	
func _on_exit_pressed() -> void:
	print("Exit Button pressed")
	get_tree().quit()
