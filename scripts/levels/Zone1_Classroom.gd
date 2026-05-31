extends Node2D

var has_triggered_ghost = false
@onready var player = $Player
@onready var entity_sprite = $Entity

func _ready():
	entity_sprite.visible = false

func _process(delta):
	# Walk to x=1500 to trigger the ghost
	if not has_triggered_ghost and player.position.x > 1500:
		has_triggered_ghost = true
		spawn_ghost()

func spawn_ghost():
	# Place entity ahead of player
	entity_sprite.position.x = player.position.x + 1200
	entity_sprite.visible = true
	
	# Flicker entity to make it creepy
	var tween = create_tween()
	tween.tween_property(entity_sprite, "modulate:a", 0.5, 0.1)
	tween.tween_property(entity_sprite, "modulate:a", 0.1, 0.1)
	tween.tween_property(entity_sprite, "modulate:a", 0.8, 0.1)
	
	# Trigger system voice and warning!
	SystemManager.trigger_system_warning("PHÁT HIỆN DỊ THƯỜNG. GIAO THỨC IM LẶNG: NÍN THỞ NGAY LẬP TỨC!", true)
	
	# Disappear after 1 second
	get_tree().create_timer(1.0).timeout.connect(func(): entity_sprite.visible = false)
