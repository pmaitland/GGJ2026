extends ProgressBar


var style_box: StyleBoxFlat


func _ready() -> void:
	style_box = StyleBoxFlat.new()
	add_theme_stylebox_override("fill", style_box)
	style_box.bg_color = Color("00ff00")
	style_box.set_corner_radius_all(2)
	style_box.anti_aliasing = false


func _process(_delta) -> void:
	global_position = owner.position + Vector2(-6, -11)
	rotation = -owner.rotation
	if value <= max_value * 0.25:
		style_box.bg_color = Color("ff0000")
	elif value <= max_value * 0.5:
		style_box.bg_color = Color("ffff00")
