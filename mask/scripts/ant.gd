class_name Ant extends RigidBody2D

var BASE_SPEED = 100

@export var health = 100
var speed = BASE_SPEED
var rotation_speed = 1
@onready var animation = $AnimatedSprite2D

var target: Vector2  # where ant wants to go


func _ready() -> void:
	AStar.init(100, 200, Vector2(99, 199))
	target = _find_target()


func _physics_process(delta: float) -> void:
	target = _find_target()
	var target_direction = (target - position).normalized()
	var motion = target_direction * delta * speed
	var target_angle = target_direction.angle()
	# Smoothly rotate towards the target angle
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	print(position, target)
	move_and_collide(motion)


func _find_target() -> Vector2:
	return AStar.get_next_cell_in_path(position)


func apply_damage(dmg: int) -> void:
	health -= dmg
	if health < 0:
		die()


func die():
	print('Dead!')
	queue_free()
