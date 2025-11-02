extends Node2D

@onready var victory_screen = $game_result/victory
@onready var game_over_screen = $game_result/game_over

var game_end: bool = false

func _ready() -> void:
	victory_screen.visible = false
	game_over_screen.visible = false

func _on_game_win() -> void:
	victory_screen.visible = true
	game_end = true


func _on_game_over() -> void:
	game_over_screen.visible = true
	game_end = true

func _process(_delta: float) -> void:
	if game_end and Input.is_action_just_pressed("restart"):
		victory_screen.visible = false
		game_over_screen.visible = false
		game_end = false
		get_tree().reload_current_scene()
