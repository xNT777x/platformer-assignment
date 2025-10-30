extends Node2D
@onready var golden_skull: Area2D = $GoldenSkull
@onready var red_potion: Area2D = $RedPotion
@onready var blue_potion: Area2D = $BluePotion


var items:Array =[]
func _ready() -> void:
	_set_item_active(golden_skull,false)
	_set_item_active(red_potion,false)
	_set_item_active(blue_potion,false)
	items = [golden_skull, red_potion, blue_potion]
	
func spawn_item_at(pos: Vector2) -> void:
	var chosen_item = items[randi() % items.size()]
	if chosen_item:
		var spawned_item = chosen_item.duplicate()
		get_parent().add_child(spawned_item)
		spawned_item.global_position = pos
		_set_item_active(spawned_item, true)

func _set_item_active(item: Area2D, active: bool):
	if !is_instance_valid(item):
		return
	item.visible = active
	item.monitoring = active
	item.monitorable = active
	
