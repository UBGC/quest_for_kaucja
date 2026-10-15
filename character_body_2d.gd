extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var nearby_bottles: Array[Bottle] = []

func _ready() -> void:
	_update_interaction_hint()

func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * SPEED

	if direction.is_zero_approx():
		animated_sprite.play("idle")
	else:
		animated_sprite.play("walk")
		if direction.x != 0.0:
			animated_sprite.flip_h = direction.x > 0.0

	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Interact", false):
		_collect_nearest_bottle()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Bottle:
		var bottle := area as Bottle
		if not nearby_bottles.has(bottle):
			nearby_bottles.append(bottle)
			bottle.form_changed.connect(_on_bottle_form_changed)
		_update_interaction_hint()

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area is Bottle:
		var bottle := area as Bottle
		nearby_bottles.erase(bottle)
		if bottle.form_changed.is_connected(_on_bottle_form_changed):
			bottle.form_changed.disconnect(_on_bottle_form_changed)
		_update_interaction_hint()

func _on_bottle_form_changed(_value: float) -> void:
	_update_interaction_hint()

func _collect_nearest_bottle() -> void:
	var bottle := _get_nearest_bottle()
	if bottle == null:
		return

	global.money += bottle.value
	bottle.queue_free()
	nearby_bottles.erase(bottle)
	_update_interaction_hint()

func _get_nearest_bottle() -> Bottle:
	var nearest: Bottle
	var nearest_distance := INF

	for index in range(nearby_bottles.size() - 1, -1, -1):
		var bottle := nearby_bottles[index]
		if not is_instance_valid(bottle):
			nearby_bottles.remove_at(index)
			continue

		var distance := global_position.distance_squared_to(bottle.global_position)
		if distance < nearest_distance:
			nearest = bottle
			nearest_distance = distance

	return nearest

func _update_interaction_hint() -> void:
	var bottle := _get_nearest_bottle()
	if bottle == null:
		global.interaction_hint_changed.emit("WASD / ARROWS TO MOVE   |   E / SPACE TO CATCH")
	elif bottle.value >= 0.0:
		global.interaction_hint_changed.emit("E / SPACE: CATCH NOW FOR %.2f PLN" % bottle.value)
	else:
		global.interaction_hint_changed.emit("WAIT FOR A BETTER SHAPE   |   NOW: %.2f PLN" % bottle.value)
