extends Node2D


func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		AStar.set_disabled(AStar.global_to_cell(global_position), true)
		visible = !AStar.is_disabled(AStar.global_to_cell(global_position))
