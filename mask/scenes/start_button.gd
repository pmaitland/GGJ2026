extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pressed.connect(_button_pressed)
	
	
func _button_pressed():
	print("Loading game...!")
	get_tree().change_scene_to_file("res://scenes/main.tscn")
