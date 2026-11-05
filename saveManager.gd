extends Node

const SAVE_PATH := "user://savegame.tres"

var data: SaveData = SaveData.new()

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func new_game() -> void:
	data = SaveData.new()

func save_game() -> void:
	var err := ResourceSaver.save(data, SAVE_PATH)
	if err != OK:
		printerr("Saglabāšana neizdevās!!!")

func load_game() -> bool:
	if not has_save():
		return false
	var loaded := ResourceLoader.load(
		SAVE_PATH) as SaveData
	if loaded == null:
		printerr("Saglabājuma fails ir bojāts vai nelasāms.")
		return false
	print("viss ok!")
	data = loaded
	return true
