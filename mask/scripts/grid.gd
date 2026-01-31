extends Node


func _ready() -> void:
	AStar.init(10, 20, Vector2(0, 0), Vector2(9, 19))
	var cell_scene = load("res://scenes/cell.tscn")
	for y in AStar.height:
		for x in AStar.width:
			var cell: Node2D = cell_scene.instantiate()
			cell.global_position = AStar.cell_to_global(Vector2(x, y))
			add_child(cell)
