extends CharacterBody2D


var bootle: PackedScene = preload("res://bootle.tscn")

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var time = 0.0

func _process(delta: float) -> void:
	time += delta
	if time >= 20:
		time = 0.0
		get_parent().add_child(bootle.instantiate())
		