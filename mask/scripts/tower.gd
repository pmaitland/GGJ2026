extends Node2D

@onready var attack_node = $Attack
@onready var range_cast = $Attack/RangeCast
@onready var attack_area = $Attack/AttackArea
@onready var attack_animation = $Attack/AnimatedSprite2D
@onready var bottle_animation = $AnimatedSprite2D
@onready var attack_cooldown: Timer = $AttackCooldown
@onready var attack_duration: Timer = $AttackDuration

@export var damage: int = 25

var attack_ready = true


func _ready() -> void:
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)
	attack_duration.timeout.connect(_on_attack_duration_timeout)


func _physics_process(_delta: float) -> void:
	if attack_ready:
		_attack()


func _attack() -> void:
	if not _is_ant_in_range():
		return
	
	attack_ready = false
	attack_cooldown.start()
	
	_target_ant()
	attack_animation.play()
	
	attack_area.monitoring = true
	attack_duration.start()


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

func _on_attack_duration_timeout() -> void:
	attack_area.monitoring = false


func _on_attack_area_body_entered(body: Node2D) -> void:
	if body is Ant and not body.is_dead():
		(body as Ant).apply_damage(damage)
