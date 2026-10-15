extends Node

@export var required_money: float = 15.0
@export_file("*.tscn") var next_level_path: String

var is_transitioning := false


func _ready() -> void:
	global.money_changed.connect(_on_money_changed)
	_on_money_changed(global.money)


func _on_money_changed(value: float) -> void:
	if is_transitioning or value < required_money:
		return

	is_transitioning = true
	call_deferred("_change_level")


func _change_level() -> void:
	var error := get_tree().change_scene_to_file(next_level_path)
	if error != OK:
		is_transitioning = false
		push_error("Nie można załadować następnego poziomu: %s" % error_string(error))
