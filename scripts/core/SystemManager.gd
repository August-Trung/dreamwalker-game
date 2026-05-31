extends Node

signal corruption_changed(new_value)
signal sync_changed(new_value)
signal system_warning(message)

var corruption_level: float = 0.0:
	set(value):
		corruption_level = clamp(value, 0.0, 100.0)
		corruption_changed.emit(corruption_level)

var sync_level: float = 3.0:
	set(value):
		sync_level = clamp(value, 0.0, 100.0)
		sync_changed.emit(sync_level)

var mic_player: AudioStreamPlayer
var record_effect: AudioEffectRecord
var is_listening: bool = false
var mic_threshold: float = 0.05 # Âm lượng vượt mức này sẽ tính là phát ra tiếng

func _ready():
	print("Dreamwalker System Initiated.")
	_setup_microphone()

func _setup_microphone():
	mic_player = AudioStreamPlayer.new()
	var mic_stream = AudioStreamMicrophone.new()
	mic_player.stream = mic_stream
	mic_player.bus = "Mic"
	add_child(mic_player)
	mic_player.play()
	
	var bus_idx = AudioServer.get_bus_index("Mic")
	if bus_idx >= 0:
		record_effect = AudioServer.get_bus_effect(bus_idx, 0)

func _process(delta):
	if is_listening and record_effect:
		var bus_idx = AudioServer.get_bus_index("Mic")
		if bus_idx >= 0:
			var peak_volume_db = AudioServer.get_bus_peak_volume_left_db(bus_idx, 0)
			var linear_vol = db_to_linear(peak_volume_db)
			
			if linear_vol > mic_threshold:
				is_listening = false # Ngừng nghe sau khi phát hiện
				increase_corruption(25, "PHẢN HỒI SAI: BẠN ĐÃ PHÁT RA TIẾNG ĐỘNG!")

func start_listening_mic():
	is_listening = true
	show_message("[Hệ thống đang lắng nghe... Khuyến nghị: HÃY NÍN THỞ]")

func stop_listening_mic():
	is_listening = false

func increase_corruption(amount: float, reason: String = ""):
	corruption_level += amount
	if reason != "":
		system_warning.emit("[Cảnh báo: " + reason + "]")
	
func show_message(msg: String):
	system_warning.emit(msg)
