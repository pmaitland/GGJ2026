extends Node2D


@onready var outline: Sprite2D = $Outline
@onready var hover_outline: Sprite2D = $HoverOutline


func _ready() -> void:
	outline.modulate.a = 0.05


func disable() -> void:
	if disabled():
		return
	if not get_parent().has_cinnamon():
		return
	
	AStar.set_disabled(AStar.global_to_cell(global_position), true)
	if disabled():
		get_parent().place_cinnamon(global_position)


func disabled() -> bool:
	return AStar.is_disabled(AStar.global_to_cell(global_position))


func _on_area_2d_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		disable()


func _on_area_2d_mouse_entered() -> void:
	hover_outline.visible = true


func _on_area_2d_mouse_exited() -> void:
	hover_outline.visible = false
