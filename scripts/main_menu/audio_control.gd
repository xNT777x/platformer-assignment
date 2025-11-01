# res://scripts/audio_control.gd
extends HSlider

@export_enum("Master", "Background", "In_Game") var bus_idx: int = 0
const BUS: Array[String] = ["Master", "Background", "In_Game"]

func _ready() -> void:
	var bus := BUS[bus_idx]
	# Debug để chắc chắn mỗi slider có bus khác nhau
	print("[AudioSlider]", get_path(), " bus=", bus)

	# 1) Sync UI từ GameSettings mà KHÔNG phát signal
	if GameSettings.volumes.has(bus):
		set_value_no_signal(GameSettings.volumes[bus])

	# 2) Kéo slider -> lưu đúng bus
	value_changed.connect(func(v: float) -> void:
		GameSettings.set_volume(bus, v))

	# 3) Chỗ khác đổi -> chỉ cập nhật nếu cùng bus
	GameSettings.vol_changed.connect(func(ch_bus: String, db: float) -> void:
		if ch_bus == bus and value != db:
			set_value_no_signal(db));
