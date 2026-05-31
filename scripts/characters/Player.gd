extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var time_passed: float = 0.0
var is_dead: bool = false

@onready var sprite = $Sprite2D

func _ready():
	SystemManager.game_over.connect(_on_game_over)

func _on_game_over():
	is_dead = true

func _physics_process(delta):
	if is_dead:
		return
		
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
		
		# Procedural Walk Animation (Bobbing and rotation)
		time_passed += delta * 15.0
		sprite.position.y = -150.0 + sin(time_passed) * 15.0
		sprite.rotation = sin(time_passed * 0.5) * 0.08
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Procedural Idle Animation (Breathing)
		time_passed += delta * 3.0
		sprite.position.y = -150.0 + sin(time_passed) * 4.0
		sprite.rotation = 0.0

	move_and_slide()
