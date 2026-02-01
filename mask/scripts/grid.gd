extends Node


@export var width: int = 10
@export var height: int = 10
@export var start: Vector2i = Vector2i(0, 0)
@export var end: Vector2i = Vector2i(9, 9)
@export var ant_count: int = 10
@export var spray_bottles: Array[Vector2i]

@onready var ant_scene: PackedScene  = load("res://scenes/ants/ant.tscn")
@onready var fast_ant_scene: PackedScene = load("res://scenes/ants/fast_ant.tscn")
@onready var bulky_ant_scene: PackedScene = load("res://scenes/ants/bulky_ant.tscn")
@onready var mapping = {
	Level.AntType.None: null,
	Level.AntType.Basic: ant_scene,
	Level.AntType.Fast: fast_ant_scene,
	Level.AntType.Bulky: bulky_ant_scene,
}

func _get_ant_scene(type: Level.AntType) -> PackedScene:
	return mapping[type]

var ant_spawn_timer: Timer
var ant_spawn_cooldown: float = 2
var current_level = Level.level1

var cells: Array[Node2D] = []
var cinnamon: TileMapLayer


func _ready() -> void:
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
	_create_cinnamon()


func _next_ant() -> PackedScene:
	var scene = _get_ant_scene(current_level.get_ant())
	current_level.next()
	return scene


func _process(_delta) -> void:
	if ant_spawn_timer.is_stopped() and current_level.should_continue():
		var scene = _next_ant()
		if scene:
			var ant: Node2D = scene.instantiate()
			ant.position = start
			add_child(ant)

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

func _create_cinnamon() -> void:
	cinnamon = TileMapLayer.new()
	cinnamon.tile_set = load("res://sprites/cinnamon/cinnamon.tres")
	cinnamon.global_position = Vector2(-8, -8)
	add_child(cinnamon)
	for cell in cells:
		if cell.disabled():
			cinnamon.set_cell(AStar.global_to_cell(cell.global_position), 0, Vector2(1, 1))


func place_cinnamon(pos: Vector2) -> void:
	var cell: Vector2 = AStar.global_to_cell(pos)
	_update_cinnamon(cell)
	if cell.y > 0:
		_update_cinnamon(Vector2(cell.x, cell.y-1))
	if cell.y < height-2:
		_update_cinnamon(Vector2(cell.x, cell.y+1))
	if cell.x < width-2:
		_update_cinnamon(Vector2(cell.x+1, cell.y))
		if cell.y < height-2:
			_update_cinnamon(Vector2(cell.x+1, cell.y+1))
		if cell.y > 0:
			_update_cinnamon(Vector2(cell.x+1, cell.y-1))
	if cell.x > 0:
		if cell.y < height-2:
			_update_cinnamon(Vector2(cell.x-1, cell.y+1))
		_update_cinnamon(Vector2(cell.x-1, cell.y))
		if cell.y > 0:
			_update_cinnamon(Vector2(cell.x-1, cell.y-1))


func _update_cinnamon(cell: Vector2) -> void:
	if cinnamon != null and AStar.is_disabled(cell):
		var n: bool = AStar.is_disabled(Vector2(cell.x, cell.y-1))
		var s: bool = AStar.is_disabled(Vector2(cell.x, cell.y+1))
		var e: bool = AStar.is_disabled(Vector2(cell.x+1, cell.y))
		var w: bool = AStar.is_disabled(Vector2(cell.x-1, cell.y))
		var sprite_cell: Vector2 = Vector2(3, 1)
		if n:
			if e:
				if s:
					if w:
						sprite_cell = Vector2(5, 1)
					else:
						sprite_cell = Vector2(4, 1)
				elif w:
					sprite_cell = Vector2(5, 2)
				else:
					sprite_cell = Vector2(4, 2)
			elif s:
				if w:
					sprite_cell = Vector2(6, 1)
				else:
					sprite_cell = Vector2(0, 1)
			elif w:
				sprite_cell = Vector2(2, 2)
			else:
				pass
		elif e:
			if s:
				if w:
					sprite_cell = Vector2(5, 0)
				else:
					sprite_cell = Vector2(0, 0)
			elif w:
				sprite_cell = Vector2(1, 0)
			else:
				pass
		elif s:
			if w:
				sprite_cell = Vector2(2, 0)
			else:
				pass
		elif w:
			pass
		cinnamon.set_cell(cell, 0, sprite_cell)
