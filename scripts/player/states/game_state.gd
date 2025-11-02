extends Node
signal coins_changed(value: int)
var coins: int = 0

func add_coins(n: int = 1) -> void:
	coins += n
	emit_signal("coins_changed", coins)
