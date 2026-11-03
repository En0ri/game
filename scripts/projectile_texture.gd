extends Node2D

@export var animation_player : AnimationPlayer

#func _ready() -> void:
	#animation_player = $AnimationPlayer

func _physics_process(delta: float) -> void:
	# locks rotation from -180 to 180
	if rad_to_deg(self.rotation) <= -180: self.rotation = deg_to_rad(180)
	elif rad_to_deg(self.rotation) >= 180: self.rotation = deg_to_rad(-180)
