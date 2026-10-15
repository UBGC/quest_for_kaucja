extends CanvasLayer

@export var location_title: String
@export_multiline var dialogue: String

@onready var title_label: Label = $Panel/Margin/Content/Title
@onready var dialogue_label: Label = $Panel/Margin/Content/Dialogue


func _ready() -> void:
	title_label.text = location_title
	dialogue_label.text = dialogue
