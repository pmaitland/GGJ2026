extends Node


var _a_star: AStar2D
var _start_id: int
var _goal_id: int
const SCALE: float = 16 # must match cell sprite size!!!
var width: int = 0
var height: int = 0


func init(w: int, h: int, start: Vector2, goal: Vector2) -> void:
	if start.x < 0 or start.y < 0 or start.x >= w or start.y >= h:
		push_error("Start is outside bounds.")
		return
	if goal.x < 0 or goal.y < 0 or goal.x >= w or goal.y >= h:
		push_error("Goal is outside bounds.")
		return
	width = w
	height = h
	_a_star = AStar2D.new()
	for y in height:
		for x in width:
			var id: int = _a_star.get_available_point_id()
			var coords: Vector2 = Vector2(x, y)
			_a_star.add_point(id, coords)
			if coords == start:
				_start_id = id
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
			if x > 0:
				neighbour_id = _a_star.get_closest_point(Vector2(x-1, y))
				_a_star.connect_points(id, neighbour_id)


func is_disabled(cell: Vector2) -> bool:
	return _a_star.is_point_disabled(_a_star.get_closest_point(cell, true))


func set_disabled(cell: Vector2, disabled: bool) -> void:
	var id: int = _a_star.get_closest_point(cell, true)
	_a_star.set_point_disabled(id, disabled)
	if !_path_possible():
		_a_star.set_point_disabled(id, false)


func toggle_disabled(cell: Vector2) -> void:
	var id: int = _a_star.get_closest_point(cell, true)
	_a_star.set_point_disabled(id, !_a_star.is_point_disabled(id))
	if !_path_possible():
		_a_star.set_point_disabled(id, false)


func _path_possible() -> bool:
	return _a_star.get_point_path(_start_id, _goal_id).size() > 0


func global_to_cell(pos: Vector2) -> Vector2:
	return pos / SCALE


func cell_to_global(cell: Vector2) -> Vector2:
	return cell * SCALE


func get_next_cell_in_path(pos: Vector2) -> Vector2:
	var current_cell: Vector2 = global_to_cell(pos)
	var current_cell_id: int = _a_star.get_closest_point(current_cell)
	var path: PackedVector2Array = _a_star.get_point_path(current_cell_id, _goal_id)
	return cell_to_global(path[1] if path.size() > 1 else path[0])


func is_goal(cell: Vector2) -> bool:
	return _a_star.get_closest_point(cell) == _goal_id
