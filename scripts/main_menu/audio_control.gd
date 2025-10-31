extends HSlider

@export var audio_bus_name: String
var audio_id

func _ready() -> void:
	audio_id = AudioServer.get_bus_index(audio_bus_name)
	

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(audio_id, value)
