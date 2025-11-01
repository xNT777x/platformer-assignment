extends Node

enum Difficulty { EASY, MEDIUM, HARD }
signal difficulty_changed(value: int)
var difficulty: int = Difficulty.EASY

signal vol_changed(bus: StringName, db: float)
var volumes := {
	&"Master": 0.0,
	&"BGM":    0.0,
	&"SFX":    0.0,
}

func _ready() -> void:
	_load()
	_apply_audio()

func set_difficulty(d: int) -> void:
	difficulty = d
	emit_signal("difficulty_changed", d)
	_save()

func get_max_health() -> int:
	match difficulty:
		Difficulty.EASY:   return 5
		Difficulty.MEDIUM: return 3
		Difficulty.HARD:   return 1
	return 3

func set_volume(bus: String, db: float) -> void:
	volumes[bus] = db
	emit_signal("vol_changed", bus, db)
	_apply_audio()
	_save()

func _apply_audio() -> void:
	for bus_name in volumes.keys():
		var idx := AudioServer.get_bus_index(bus_name)
		if idx != -1:
			AudioServer.set_bus_volume_db(idx, float(volumes[bus_name]))

func _save() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("game", "difficulty", difficulty)
	for bus_name in volumes.keys():
		cfg.set_value("audio", str(bus_name), volumes[bus_name])
	cfg.save("user://settings.cfg")

func _load() -> void:
	var cfg := ConfigFile.new()
	if cfg.load("user://settings.cfg") == OK:
		difficulty = int(cfg.get_value("game", "difficulty", difficulty))
		for bus_name in volumes.keys():
			volumes[bus_name] = float(cfg.get_value("audio", str(bus_name), volumes[bus_name]))
