extends Node


@export var width: int = 10
@export var height: int = 10
@export var start: Vector2i = Vector2i(0, 0)
@export var end: Vector2i = Vector2i(9, 9)
@export var ant_count: int = 10
@export var spray_bottles: Array[Vector2i]

var ant_scene: PackedScene

var ant_spawn_timer: Timer
var ant_spawn_cooldown: float = 2
var ants_spawned_count: int = 0

var cells: Array[Node2D] = []


func _ready() -> void:
	ant_scene = load("res://scenes/ant.tscn")
	ant_spawn_timer = Timer.new()
	ant_spawn_timer.one_shot = true
	add_child(ant_spawn_timer)
	AStar.init(width, height, start, end)
	var cell_scene = load("res://scenes/cell.tscn")
	for y in AStar.height:
		for x in AStar.width:
			var cell: Node2D = cell_scene.instantiate()
			cell.global_position = AStar.cell_to_global(Vector2(x, y))
			cells.append(cell)
			add_child(cell)
	_create_spray_bottles()


func _process(_delta) -> void:
	if ant_spawn_timer.is_stopped() and ants_spawned_count < ant_count:
		var ant: Node2D = ant_scene.instantiate()
		ant.position = start
		add_child(ant)
		ants_spawned_count += 1
		ant_spawn_timer.start(ant_spawn_cooldown)


func _create_spray_bottles() -> void:
	var spray_bottle_scene: PackedScene = load("res://scenes/tower.tscn")
	for coords in spray_bottles:
		var spray_bottle: Node2D = spray_bottle_scene.instantiate()
		spray_bottle.position = AStar.cell_to_global(coords)
		add_child(spray_bottle)
		for cell in cells:
			if cell.position == spray_bottle.position:
				cell.disable()
