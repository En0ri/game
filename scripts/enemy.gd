extends StaticBody2D
class_name Enemy

@export var damage = 10;

var stats : EnemyData
var save_signal: Signal

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.health -= damage
	if body is Projectile:
		$".".queue_free()
