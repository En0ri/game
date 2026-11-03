extends Control

@onready var Progress_bar : ProgressBar = %ProgressBar

@export var accuracy : float = 0.1
@export var speed : float = 0.01
@export var normal_health_color : Color = Color(0.76, 0.111, 0.763, 0.82)
@export var low_health_color : Color = Color(0.518, 0.0, 0.067, 0.82)
@export var background_color : Color = Color(0.388, 0.004, 0.608, 0.608)

@export var health : float = 100:
	set(value):
		health = value
@export var max_health : float = 100:
	set(value):
		max_health = value

var time : float = 0

func _ready() -> void:
	Progress_bar.get_theme_stylebox("fill").bg_color = normal_health_color
	Progress_bar.get_theme_stylebox("background").bg_color = background_color

func _process(delta: float) -> void:
	time += delta * speed
	if abs(Progress_bar.value - health) > accuracy:
		Progress_bar.value = lerp(Progress_bar.value, health, time)
		
		var r = remap(Progress_bar.value, 0, max_health, low_health_color.r, normal_health_color.r)
		var g = remap(Progress_bar.value, 0, max_health, low_health_color.g, normal_health_color.g)
		var b = remap(Progress_bar.value, 0, max_health, low_health_color.b, normal_health_color.b)
		var a = remap(Progress_bar.value, 0, max_health, low_health_color.a, normal_health_color.a)
		Progress_bar.get_theme_stylebox("fill").bg_color = Color(r,g,b,a)
