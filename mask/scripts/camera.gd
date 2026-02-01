extends Camera2D


@onready var background = $Sprite2D


func _process(_delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var level_size = Vector2(AStar.width, AStar.height) * AStar.SCALE
	var zoom_x = viewport_size.x / level_size.x
	var zoom_y = viewport_size.y / level_size.y
	var new_zoom = min(zoom_x, zoom_y)
	zoom = Vector2(new_zoom, new_zoom) * 0.95
	position = (level_size / 2) - Vector2(AStar.SCALE, AStar.SCALE) / 2
	
	var background_sprite_size = Vector2(320, 180)
	var desired_background_size = level_size
	background.scale = desired_background_size / background_sprite_size
