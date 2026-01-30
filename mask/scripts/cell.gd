extends Node2D


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_released():
		AStar.set_disabled(AStar.global_to_cell(global_position), true)
		visible = !AStar.is_disabled(AStar.global_to_cell(global_position))
