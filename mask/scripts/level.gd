extends Node

enum AntType { None, Basic, Fast, Bulky }

var current_level = 1


class AntGroup extends Object:
	var type: Level.AntType
	var count: int
	
	func _init(t: Level.AntType, c: int):
		self.type = t
		self.count = c


class AntHoard:
	var groups: Array[AntGroup]
	var current_group: int = 0
	var count_in_group: int = 0

	func _init(g: Array[AntGroup]):
		self.groups = g

	func should_continue():
		return (current_group < groups.size())

	func next():
		self.count_in_group += 1
		if self.count_in_group >= self.groups[self.current_group].count:
			self.current_group += 1
			self.count_in_group = 0
		return should_continue()

	func get_ant():
		return self.groups[self.current_group].type
	
	func reset():
		current_group = 0
		count_in_group = 0



class LevelConfig:
	var ants: AntHoard
	var grid_size: Vector2i
	var spray_bottles: Array[Vector2i]
	var cinnamon_limit: int


func get_level(level_number: int) -> Dictionary:
	return levels[level_number - 1]


func get_current_level() -> Dictionary:
	return get_level(current_level)


func is_more_levels() -> int:
	return current_level < levels.size()


func next_level() -> void:
	current_level += 1


func reset_level() -> void:
	get_current_level()["ants"].reset()


var levels = [
	{ # 1
		"ants": AntHoard.new([
			AntGroup.new(Level.AntType.None, 1),
			AntGroup.new(Level.AntType.Basic, 3),
		]),
		"grid": Vector2i(11, 4),
		"sprays": [
			Vector2i(5, 3),
		],
		"cinnamon": 11,
		"end": Vector2i(9, 2),
		"kiwi_health": 2,
	},
	{ # 2
		"ants": AntHoard.new([
			AntGroup.new(Level.AntType.None, 5),
			AntGroup.new(Level.AntType.Basic, 5),
			AntGroup.new(Level.AntType.None, 1),
			AntGroup.new(Level.AntType.Bulky, 1),
		]),
		"grid": Vector2i(16, 8),
		"sprays": [
			Vector2i(4, 6),
			Vector2i(12, 1),
		],
		"cinnamon": 7,
		"kiwi_health": 3,
	}
]
