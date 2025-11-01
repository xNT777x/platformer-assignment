extends OptionButton
class_name DifficultySelector

enum Difficulty { EASY, MEDIUM, HARD }

func _ready() -> void:
	clear()
	add_item("Easy",   Difficulty.EASY)
	add_item("Medium", Difficulty.MEDIUM)
	add_item("Hard",   Difficulty.HARD)

	select(get_item_index(GameSettings.difficulty))

	item_selected.connect(_on_level_item_selected)

func _on_level_item_selected(index:int) -> void:
	GameSettings.set_difficulty(get_item_id(index))
