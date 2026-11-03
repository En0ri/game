extends CharacterBody2D
class_name Player

@onready var scene = get_tree().current_scene
const projectile = preload("res://nodes/Projectile.tscn")
@onready var _animation_player = $AnimationPlayer

@export var projectile_counter_ui : Control
@export var projectile_count = 10:
	set(value):
		projectile_count = value
		if projectile_counter_ui:
			projectile_counter_ui.updCount(value)
		
@export var _label_count : Label
const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var JUMP_AVAILIBLE = true
var facing_dir = 1

func _ready() -> void:
	projectile_counter_ui.updCount(value)
	
func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		if event.is_action_pressed("M1"): print("Mouse 1 Click")
		if event.is_action_pressed("M2"): print("Mouse 2 Click")
		if event.is_action_released("M1"): print("Mouse 1 unclick")
		if event.is_action_released("M2"): print("Mouse 2 unclick")
		print("Viewport Resolution is: ", get_viewport().get_visible_rect().size)
	elif event is InputEventMouseMotion:
		print("Mouse Motion at: ", get_viewport().get_mouse_position())# physic process pārcelt

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

	# projectiles
	if Input.is_action_just_pressed("Interact") and projectile_count:
		var projectileInstance = projectile.instantiate()
		projectileInstance.global_position = position
		projectileInstance.speed = 200
		projectileInstance.direction = -1 if facing_dir < 0 else 1
		scene.add_child.call_deferred(projectileInstance)
		projectile_count -= 1
	
	move_and_slide()
