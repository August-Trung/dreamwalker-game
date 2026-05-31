extends CanvasLayer

@onready var warning_label = $Control/WarningLabel

func _ready():
	warning_label.text = ""
	SystemManager.system_warning.connect(_on_system_warning)

func _on_system_warning(message: String):
	warning_label.text = message
	warning_label.visible_characters = 0
	warning_label.modulate.a = 1.0
	
	# Typewriter effect
	var tween = create_tween()
	tween.tween_property(warning_label, "visible_characters", message.length(), message.length() * 0.05)
	tween.tween_callback(func(): _fade_out_warning())

func _fade_out_warning():
	var tween = create_tween()
	tween.tween_property(warning_label, "modulate:a", 0.0, 2.0).set_delay(3.0)
	tween.tween_callback(func(): 
		warning_label.text = ""
		warning_label.modulate.a = 1.0
	)
