extends Node2D

var spawnInterval = 8 #czas pomiedzy spawnieniem butelki
var bottleScene = preload("res://bootle.tscn")



func _ready() -> void:
	petlaSpawnu()

func petlaSpawnu():
	while true:
		var bottle = bottleScene.instantiate()
		add_child(bottle)
		bottle.global_position = global_position + Vector2(0, 20)
		await get_tree().create_timer(randf_range(1.0, spawnInterval)).timeout #losowy czas pomiedzy spawnami butelek
		
