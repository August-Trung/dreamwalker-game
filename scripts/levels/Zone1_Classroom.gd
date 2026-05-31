extends Node2D

func _ready():
	# Cảnh báo đầu tiên
	await get_tree().create_timer(1.0).timeout
	SystemManager.show_message("[Dream Link Established. Sync: 3%]")
	
	# Sự kiện "Nguồn thứ ba" tiếp cận
	await get_tree().create_timer(4.0).timeout
	SystemManager.show_message("[Có người đang đến gần...]")
	
	# Bắt đầu kích hoạt lắng nghe Microphone đời thực
	await get_tree().create_timer(3.0).timeout
	SystemManager.start_listening_mic()

func _on_trigger_area_body_entered(body):
	if body.name == "Player":
		SystemManager.increase_corruption(10, "Định danh không đầy đủ.")
