extends CharacterBody2D
class_name Projectile

@onready var ProjectileTexture = %ProjectileTexture.animation_player
@export var speed : float

func _physics_process(delta: float) -> void:
	velocity = transform.x * speed
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body != self and not body is Player:
		ProjectileTexture.queue("hit")
		#ProjectileTexture.queue("break")
		
		collision_layer = 4 # 3 layer
		set_physics_process(false)
