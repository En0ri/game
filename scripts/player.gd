extends CharacterBody2D
class_name Player

const projectile = preload("res://nodes/Projectile.tscn")
@onready var projectile_texture = $ProjectileTexture
@onready var _animation_player = $AnimationPlayer

@export var projectile_counter_ui : Control
@export var projectile_count = 10:
	set(value):
		projectile_count = value
		if projectile_counter_ui:
			projectile_counter_ui.updCount(value)

@export var health_bar : Control
@export var health :int = 100:
	set(value):
		health = value
		if health_bar:
			health_bar.health = value
		if health <= 0:
			get_tree().reload_current_scene()
@export var max_health :int = 100:
	set(value):
		max_health = value
		if health_bar:
			health_bar.max_health = value

@export var throw_speed = 300
var AIMING = false
const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var JUMP_AVAILIBLE = true
var facing_dir = 1

var stats : PlayerData
var save_signal: Signal

func _ready() -> void:
	projectile_counter_ui.updCount(projectile_count)
	projectile_texture.visible = false
	
	stats = SaveManager.data.player
	_load_data()
	SaveManager.data.saving_data.connect(_save_data)
	#SaveManager.data.saving_data.emit()
	#SaveManager.save_game()

func _load_data():
	health = stats.hp
	max_health = stats.max_hp
	position = stats.position
	projectile_count = stats.projectile_count
func _save_data():
	stats.hp = health
	stats.max_hp = max_health
	stats.position = global_position
	stats.projectile_count = projectile_count

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		JUMP_AVAILIBLE = true
		velocity.y = JUMP_VELOCITY
	if not is_on_floor() and JUMP_AVAILIBLE and Input.is_action_just_pressed("Jump"):
		JUMP_AVAILIBLE = false
		velocity.y = JUMP_VELOCITY

	# movement
	var direction := Input.get_axis("Left", "Right")
	if direction:
		facing_dir = direction
		velocity.x = direction * SPEED
		$Sprite2D.flip_h = direction < 0
		_animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		_animation_player.stop()
	
	if Input.is_action_just_pressed("Interact"): pass
	
	# Projectile shooting and aiming
	if Input.is_action_just_pressed("M1") and AIMING: shoot_projectile()
	if Input.is_action_just_pressed("M2"): AIMING = true
	if Input.is_action_just_released("M2"): AIMING = false
	
	if AIMING and projectile_count:
		projectile_texture.visible = true
		rotate_projectile(projectile_texture)
	elif !AIMING and projectile_texture.visible:
		projectile_texture.visible = false
	
	move_and_slide()

func shoot_projectile():
	if projectile_count:
		var projectileInstance = projectile.instantiate()
		projectileInstance.global_position = position
		projectileInstance.speed = throw_speed
		rotate_projectile(projectileInstance)
		get_tree().current_scene.add_child.call_deferred(projectileInstance)
		projectile_count -= 1
		AIMING = false 

func rotate_projectile(body):
	body.look_at(get_global_mouse_position())
	var p_rotation = rad_to_deg(body.rotation)
	if abs(rad_to_deg(body.rotation)) > 90:
		body.scale = Vector2(1,-1)
	else: body.scale = Vector2(1,1)
