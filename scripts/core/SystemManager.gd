extends Node

signal corruption_changed(new_value)
signal sync_changed(new_value)
signal system_warning(message)
signal game_over()

var corruption_level: float = 0.0:
	set(value):
		corruption_level = clamp(value, 0.0, 100.0)
		corruption_changed.emit(corruption_level)
		if corruption_level >= 100.0:
			game_over.emit()

var sync_level: float = 100.0:
	set(value):
		sync_level = clamp(value, 0.0, 100.0)
		sync_changed.emit(sync_level)

var mic_threshold: float = 0.05
var is_listening: bool = false
var audio_bus_idx: int = -1
var tts_voice_id: String = ""

func _ready():
	audio_bus_idx = AudioServer.get_bus_index("Mic")
	# Initialize TTS Voice
	var voices = DisplayServer.tts_get_voices_for_language("vi")
	if voices.is_empty():
		voices = DisplayServer.tts_get_voices()
	if not voices.is_empty():
		tts_voice_id = voices[0]

func _process(delta):
	if is_listening and audio_bus_idx >= 0:
		var peak_volume_db = AudioServer.get_bus_peak_volume_left_db(audio_bus_idx, 0)
		var linear_vol = db_to_linear(peak_volume_db)
		if linear_vol > mic_threshold:
			is_listening = false
			increase_corruption(35, "LỖI! PHÁT HIỆN TIẾNG ỒN! HỆ THỐNG GIA TĂNG THA HÓA!")

func trigger_system_warning(message: String, require_silence: bool = false):
	system_warning.emit(message)
	if tts_voice_id != "":
		DisplayServer.tts_speak(message, tts_voice_id)
		
	if require_silence:
		is_listening = true
		get_tree().create_timer(5.0).timeout.connect(func(): is_listening = false)

func increase_corruption(amount: float, reason: String = ""):
	corruption_level += amount
	sync_level -= amount * 0.5
	if reason != "":
		trigger_system_warning(reason, false)
