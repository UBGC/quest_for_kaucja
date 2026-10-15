extends Control

@onready var menu_center: CenterContainer = $Center
@onready var controls_center: CenterContainer = $ControlsCenter

func _ready() -> void:
	$Center/Card/Padding/Content/PlayButton.grab_focus()

func _on_play_pressed() -> void:
	var error := get_tree().change_scene_to_file("res://node_2d.tscn")
	if error != OK:
		push_error("Unable to load the game scene: %s" % error_string(error))

func _on_controls_pressed() -> void:
	menu_center.hide()
	controls_center.show()
	$ControlsCenter/Card/Padding/Content/BackButton.grab_focus()

func _on_back_pressed() -> void:
	controls_center.hide()
	menu_center.show()
	$Center/Card/Padding/Content/PlayButton.grab_focus()

func _on_quit_pressed() -> void:
	get_tree().quit()
