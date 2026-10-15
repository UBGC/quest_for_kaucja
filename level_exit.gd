extends Area2D

const REQUIRED_MONEY := 0.0
const NEXT_LEVEL_PATH := "res://level_2.tscn"

@onready var exit_visual: Node2D = $ExitVisual

var is_open := false


func _ready() -> void:
	global.money_changed.connect(_on_money_changed)
	_update_open_state(global.money)


func _on_money_changed(value: float) -> void:
	_update_open_state(value)


func _update_open_state(value: float) -> void:
	var should_open := value >= REQUIRED_MONEY
	if should_open == is_open:
		return

	is_open = should_open
	exit_visual.visible = is_open
	set_deferred("monitoring", is_open)


func _on_body_entered(body: Node2D) -> void:
	if not is_open or not body.is_in_group("player"):
		return

	var error := get_tree().change_scene_to_file(NEXT_LEVEL_PATH)
	if error != OK:
		push_error("Unable to load the next level: %s" % error_string(error))
