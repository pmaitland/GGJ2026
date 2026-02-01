class_name Ant extends RigidBody2D

var BASE_SPEED = 10

@export var health = 100
var current_health: int
@export var speed = BASE_SPEED
var rotation_speed = 1
@onready var animation = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

var target: Vector2  # where ant wants to go

@onready var health_bar: ProgressBar = $ProgressBar

signal got_da_kiwi

var stuck_for_time: float = 0
@onready var stuck_pos: Vector2 = position
@export var stuck_timeout: float = 5.0

var dead = false

func _ready() -> void:
	animation.play()
	current_health = health
	health_bar.max_value = health
	health_bar.value = current_health


func _physics_process(delta: float) -> void:
	if dead:
		return
	
	if AStar.is_goal(AStar.global_to_cell(global_position)):
		got_da_kiwi.emit()
		queue_free()
	target = _find_target()
	var target_direction = (target - position).normalized()
	var motion = target_direction * delta * speed
	var target_angle = target_direction.angle()
	# Smoothly rotate towards the target angle
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)
	move_and_collide(motion)
	
	track_trapped_ant(delta)


func track_trapped_ant(delta: float) -> void:
	if position == stuck_pos:
		stuck_for_time += delta
	else:
		stuck_for_time = 0
		stuck_pos = position
	
	if stuck_for_time >= stuck_timeout:
		die()


func _find_target() -> Vector2:
	return AStar.get_next_cell_in_path(position)


func apply_damage(dmg: int) -> void:
	current_health -= dmg
	health_bar.value = current_health
	
	if current_health <= 0:
		die()


func is_dead():
	return dead

func die():
	dead = true
	set_collision_layer_value(1, false)
	
	print('Dead!')
	animation.play("death_" + animation.animation)
	health_bar.visible = false

	await get_tree().create_timer(1).timeout
	animation.modulate = Color(1, 1, 1, 0.9)
	await get_tree().create_timer(1).timeout
	animation.modulate = Color(1, 1, 1, 0.8)
	await get_tree().create_timer(1).timeout
	animation.modulate = Color(1, 1, 1, 0.6)
	await get_tree().create_timer(1).timeout
	animation.modulate = Color(1, 1, 1, 0.4)
