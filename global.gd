extends Node

signal money_changed(value: float)

var money: float = 0.0:
	set(value):
		if is_equal_approx(money, value):
			return
		money = value
		money_changed.emit(money)
