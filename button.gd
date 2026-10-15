extends Button

func _process(delta: float) -> void:
	text = "Money: " + str(global.money)
