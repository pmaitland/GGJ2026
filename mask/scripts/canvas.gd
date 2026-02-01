extends CanvasLayer


@onready var game_over_label: Label = $GameOver
@onready var ant_count_label: Label = $AntCount
@onready var cinnamon_count_label: Label = $CinnamonCount


func _ready() -> void:
	var grid: Node2D = get_parent().find_child("Grid")
	grid.connect("game_over", _game_over)
	grid.connect("ant_got_in_da_kiwi", _increase_ant_count)
	grid.connect("cinnamon_used", _cinnamon_used)


func _game_over() -> void:
	game_over_label.visible = true


func _increase_ant_count(current: int, max: int) -> void:
	ant_count_label.text = "ants in your kiwi: %s/%s" % [current, max]
	

func _cinnamon_used(remaining: int) -> void:
	cinnamon_count_label.text = "cinnamon in your pocket: %s" % [remaining]
