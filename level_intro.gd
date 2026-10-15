extends CanvasLayer

@export var dialogue_title := ""
@export_multiline var dialogue_text := ""

@onready var title_label: Label = $Center/Card/Padding/Content/Title
@onready var body_label: Label = $Center/Card/Padding/Content/Body
@onready var continue_button: Button = $Center/Card/Padding/Content/ContinueButton

var _dismissed := false

func _ready() -> void:
	title_label.text = dialogue_title
	body_label.text = dialogue_text
	get_tree().paused = true
	continue_button.grab_focus()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept", false):
		_dismiss()

func _on_continue_pressed() -> void:
	_dismiss()

func _dismiss() -> void:
	if _dismissed:
		return
	_dismissed = true
	get_tree().paused = false
	queue_free()
