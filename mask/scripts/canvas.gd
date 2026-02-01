extends CanvasLayer


@onready var game_over_label: Label = $GameOver
@onready var level_complete_label: Label = $LevelComplete
@onready var ant_count_label: Label = $AntCount
@onready var cinnamon_count_label: Label = $CinnamonCount
@onready var level_label: Label = $Level


func _ready() -> void:
	var grid: Node2D = get_parent().find_child("Grid")
	grid.connect("level_complete", _level_complete)
	grid.connect("game_over", _game_over)
	grid.connect("ant_got_in_da_kiwi", _increase_ant_count)
	grid.connect("cinnamon_used", _cinnamon_used)


func _process(_delta) -> void:
	level_label.text = str(Level.current_level)


func _level_complete() -> void:
	level_complete_label.visible = true


func _game_over() -> void:
	game_over_label.visible = true


func _increase_ant_count(current: int, max: int) -> void:
	ant_count_label.text = "ants in your kiwi: %s/%s" % [current, max]
	

func _cinnamon_used(remaining: int) -> void:
	cinnamon_count_label.text = "cinnamon in your pocket: %s" % [remaining]
