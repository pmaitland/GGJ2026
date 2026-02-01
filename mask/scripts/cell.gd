extends Node2D


func disable() -> void:
	AStar.set_disabled(AStar.global_to_cell(global_position), true)
	if disabled():
		get_parent().place_cinnamon(global_position)


func disabled() -> bool:
	return AStar.is_disabled(AStar.global_to_cell(global_position))


func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		disable()
