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
		# Ảnh gốc nhân vật đang quay mặt sang trái, nên:
		# Đi sang phải (direction > 0) thì phải Flip (true) để quay sang phải
		# Đi sang trái (direction < 0) thì KHÔNG Flip (false) để giữ nguyên mặt trái
		sprite.flip_h = direction > 0
		
		# Procedural Walk Animation (Nhún nhảy mạnh hơn vì không có chân)
		time_passed += delta * 18.0
		sprite.position.y = -150.0 + sin(time_passed) * 20.0
		sprite.rotation = sin(time_passed * 0.5) * 0.15
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
		# Procedural Idle Animation (Breathing)
		time_passed += delta * 3.0
		sprite.position.y = -150.0 + sin(time_passed) * 4.0
		sprite.rotation = 0.0

	move_and_slide()
