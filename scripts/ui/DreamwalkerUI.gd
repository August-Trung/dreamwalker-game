extends CanvasLayer

@onready var warning_label = $Control/WarningLabel
@onready var hud_label = $Control/HUDLabel
@onready var glitch_overlay = $GlitchOverlay
@onready var game_over_panel = $Control/GameOverPanel

func _ready():
	warning_label.text = ""
	glitch_overlay.modulate.a = 0.05
	SystemManager.system_warning.connect(_on_system_warning)
	SystemManager.sync_changed.connect(_update_hud)
	SystemManager.corruption_changed.connect(_update_hud)
	SystemManager.game_over.connect(_on_game_over)
	_update_hud(0)

func _update_hud(_val):
	hud_label.text = "ĐỘ ĐỒNG BỘ (SYNC): " + str(SystemManager.sync_level) + "%\nTHA HÓA (CORRUPTION): " + str(SystemManager.corruption_level) + "%"

func _on_game_over():
	game_over_panel.visible = true
	# Restart after 3 seconds
	get_tree().create_timer(3.0).timeout.connect(func():
		SystemManager.corruption_level = 0
		SystemManager.sync_level = 100
		game_over_panel.visible = false
		get_tree().reload_current_scene()
	)

func _on_system_warning(message: String):
	warning_label.text = "[center]" + message + "[/center]"
	warning_label.visible_characters = 0
	warning_label.modulate.a = 1.0
	
	# Flicker Glitch
	var glitch_tween = create_tween()
	glitch_tween.tween_property(glitch_overlay, "modulate:a", 0.6, 0.1)
	glitch_tween.tween_property(glitch_overlay, "modulate:a", 0.05, 0.3)
	
	# Typewriter effect
	var tween = create_tween()
	tween.tween_property(warning_label, "visible_characters", message.length(), message.length() * 0.03)
	tween.tween_callback(func(): _fade_out_warning())

func _fade_out_warning():
	var tween = create_tween()
	tween.tween_property(warning_label, "modulate:a", 0.0, 2.0).set_delay(3.0)
	tween.tween_callback(func(): 
		warning_label.text = ""
		warning_label.modulate.a = 1.0
	)
