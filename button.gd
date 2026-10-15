extends Label

func _ready() -> void:
	_update_money(global.money)
	global.money_changed.connect(_update_money)

func _update_money(value: float) -> void:
	text = "MONEY  %.2f PLN" % value
