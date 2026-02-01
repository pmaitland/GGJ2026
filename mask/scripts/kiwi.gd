extends Node2D


@onready var sprites: AnimatedSprite2D = $AnimatedSprite2D


func be_eaten() -> void:
	sprites.play("being_eaten")


func be_fully_eaten() -> void:
	sprites.play("eaten")
