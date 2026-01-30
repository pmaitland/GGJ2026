extends Node


var _a_star: AStar2D
var _goal_id: int


func init(width: int, height: int, goal: Vector2) -> void:
	if goal.x < 0 or goal.y < 0 or goal.x >= width or goal.y >= height:
		push_error("Goal is outside bounds.")
		return
	_a_star = AStar2D.new()
	for y in height:
		for x in width:
			var id: int = _a_star.get_available_point_id()
			var coords: Vector2 = Vector2(x, y)
			_a_star.add_point(id, coords)
			if coords == goal:
				_goal_id = id
			var neighbour_id: int
			if y > 0:
				neighbour_id = _a_star.get_closest_point(Vector2(x, y-1))
				_a_star.connect_points(id, neighbour_id)
				if x < width-2:
					neighbour_id = _a_star.get_closest_point(Vector2(x+1, y-1))
					_a_star.connect_points(id, neighbour_id)
				if x > 0:
					neighbour_id = _a_star.get_closest_point(Vector2(x-1, y-1))
					_a_star.connect_points(id, neighbour_id)
			if x < width-2:
				neighbour_id = _a_star.get_closest_point(Vector2(x+1, y))
				_a_star.connect_points(id, neighbour_id)
			if y < height-2:
				neighbour_id = _a_star.get_closest_point(Vector2(x, y+1))
				_a_star.connect_points(id, neighbour_id)
				if x < width-2:
					neighbour_id = _a_star.get_closest_point(Vector2(x+1, y+1))
					_a_star.connect_points(id, neighbour_id)
				if x > 0:
					neighbour_id = _a_star.get_closest_point(Vector2(x-1, y+1))
					_a_star.connect_points(id, neighbour_id)
			if x > 0:
				neighbour_id = _a_star.get_closest_point(Vector2(x-1, y))
				_a_star.connect_points(id, neighbour_id)


func set_disabled(coords: Vector2, disabled: bool) -> void:
	var id: int = _a_star.get_closest_point(coords)
	_a_star.set_point_disabled(id, disabled)


func get_next_cell_in_path(current_cell: Vector2) -> Vector2:
	var current_cell_id: int = _a_star.get_closest_point(current_cell)
	var path: PackedVector2Array = _a_star.get_point_path(current_cell_id, _goal_id)
	return path[1]
