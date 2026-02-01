extends Node2D


@onready var sprites: AnimatedSprite2D = $AnimatedSprite2D


func be_eaten() -> void:
	sprites.play("being_eaten")
