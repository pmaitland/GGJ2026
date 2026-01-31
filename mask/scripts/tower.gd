extends Node2D

@onready var attack_node = $Attack
@onready var range_cast = $Attack/RangeCast
@onready var attack_cast = $Attack/AttackCast
@onready var attack_animation = $Attack/AnimatedSprite2D
@onready var bottle_animation = $AnimatedSprite2D
@onready var attack_cooldown: Timer = $AttackCooldown

@export var damage: int = 25

var attack_ready = true


func _ready() -> void:
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)


func _physics_process(delta: float) -> void:
	if attack_ready:
		_attack()


func _attack() -> void:
	if not _is_ant_in_range():
		return
	
	attack_ready = false
	attack_cooldown.start()
	_target_ant()
	attack_animation.play()
	
	for i in attack_cast.get_collision_count():
		var ant = attack_cast.get_collider(i) as Ant
		ant.apply_damage(damage)


func _target_ant() -> void:
	attack_node.look_at(range_cast.get_collider(0).position)

	var idx = posmod(round(snapped(attack_node.rotation_degrees, 90) / 90), 4)
	match idx:
		0: bottle_animation.play("right")
		1: bottle_animation.play("down")
		2: bottle_animation.play("left")
		3: bottle_animation.play("up")


func _is_ant_in_range() -> bool:
	return range_cast.is_colliding()


func _on_attack_cooldown_timeout() -> void:
	attack_ready = true
