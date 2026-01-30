class_name Ant extends RigidBody2D

var BASE_SPEED = 100

@export var health = 100
var speed = BASE_SPEED

var target: Vector2  # where ant wants to go


func _ready() -> void:
	AStar.init(100, 50, Vector2(49, 0))
	target = _find_target()


func _physics_process(delta: float) -> void:
	target = _find_target()
	var motion = (target - position).normalized() * delta * speed
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
