class_name Ant extends RigidBody2D

var BASE_SPEED = 10

@export var health = 100
var current_health: int
@export var speed = BASE_SPEED
var rotation_speed = 1
@onready var animation = $AnimatedSprite2D

var target: Vector2  # where ant wants to go

@onready var health_bar: ProgressBar = $ProgressBar

signal got_da_kiwi

func _ready() -> void:
	current_health = health
	health_bar.max_value = health
	health_bar.value = current_health


func _physics_process(delta: float) -> void:
	if AStar.is_goal(AStar.global_to_cell(global_position)):
		got_da_kiwi.emit()
		die()
	target = _find_target()
	var target_direction = (target - position).normalized()
	var motion = target_direction * delta * speed
	var target_angle = target_direction.angle()
	# Smoothly rotate towards the target angle
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	move_and_collide(motion)


func _find_target() -> Vector2:
	return AStar.get_next_cell_in_path(position)


func apply_damage(dmg: int) -> void:
	current_health -= dmg
	health_bar.value = current_health
	if current_health <= 0:
		die()


func die():
	print('Dead!')
	queue_free()
