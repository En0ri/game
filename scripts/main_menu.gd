extends Control


@export var scene_to_launch : PackedScene

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_packed(scene_to_launch)


func _on_load_game_pressed() -> void:
	SaveManager.load_game()
	get_tree().change_scene_to_packed(scene_to_launch)


func _on_quit_pressed(what) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()
#func escape() -> void:
	#if Input.is_action_just_pressed("Main menu"):
		#get_tree().change_scene_to_packed(application/run/main_scene)
