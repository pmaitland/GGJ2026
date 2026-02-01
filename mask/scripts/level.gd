extends Node

enum AntType { None, Basic, Fast, Bulky }


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



var level1 = AntHoard.new([
	AntGroup.new(Level.AntType.None, 5),
	AntGroup.new(Level.AntType.Basic, 10),
	AntGroup.new(Level.AntType.None, 5),
	AntGroup.new(Level.AntType.Fast, 2),
	AntGroup.new(Level.AntType.None, 5),
	AntGroup.new(Level.AntType.Bulky, 2),
])
