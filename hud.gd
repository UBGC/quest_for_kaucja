extends CanvasLayer

@onready var hint_label: Label = $HintLabel

func _ready() -> void:
	global.interaction_hint_changed.connect(_on_interaction_hint_changed)

func _on_interaction_hint_changed(message: String) -> void:
	hint_label.text = message
