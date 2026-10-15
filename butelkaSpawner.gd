extends Node2D

const BOTTLE_SCENE: PackedScene = preload("res://bootle.tscn")

@export_range(0.5, 10.0, 0.1) var min_spawn_delay := 2.5
@export_range(0.5, 15.0, 0.1) var max_spawn_delay := 4.0
@export_range(1, 40, 1) var max_live_bottles := 14
@export_range(0.2, 2.0, 0.05) var shape_cycle_interval := 0.75


func _ready() -> void:
	_spawn_loop()

func _spawn_loop() -> void:
	while is_inside_tree():
		if get_tree().get_nodes_in_group("Bottle").size() < max_live_bottles:
			var bottle := BOTTLE_SCENE.instantiate() as Bottle
			bottle.shape_cycle_interval = shape_cycle_interval
			add_child(bottle)
			bottle.global_position = global_position + Vector2(0, 20)
		await get_tree().create_timer(randf_range(min_spawn_delay, max_spawn_delay)).timeout
		
