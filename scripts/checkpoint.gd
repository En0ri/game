extends Area2D
class_name Checkpoint

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		SaveManager.data.saving_data.emit()
		SaveManager.save_game()
		print("game saved")
