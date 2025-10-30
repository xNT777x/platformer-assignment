extends Node
@onready var golden_skull: Area2D = $GoldenSkull
@onready var red_potion: Area2D = $RedPotion
@onready var blue_potion: Area2D = $BluePotion

var chosen_item: Area2D

func _ready() -> void:
	_set_item_active(golden_skull,false)
	_set_item_active(red_potion,false)
	_set_item_active(blue_potion,false)

var items := [golden_skull, red_potion, blue_potion]
chosen_item = items[randi() % items.size()]
func activate_chosen_item() -> void:
	if chosen_item:
		_set_item_active(chosen_item, true)

func _set_item_active(item: Area2D, active: bool):
	if !is_instance_valid(item):
		return
	item.visible = active
	item.monitoring = active
	item.monitorable = active
	# If they have CollisionShape2D child, enable/disable it
	var col := item.get_node_or_null("CollisionShape2D")
	if col:
		col.disabled = !active
