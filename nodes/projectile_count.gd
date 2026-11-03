extends Control

@export var _projectile_count : int = 10
@export var _label_count : Label

func updCount(value) -> void:
	_label_count.text = str(value) + " / 10"
