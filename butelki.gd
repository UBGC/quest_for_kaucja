class_name Bottle
extends Area2D

signal form_changed(value: float)

const FLAG_SZKLANA := 1 << 0
const FLAG_KAUCYJNA := 1 << 1
const SPRITESHEET: Texture2D = preload("res://BottleSpriteSheet.png")
const BOTTLE_TYPES: Array[Dictionary] = [
	{"flags": FLAG_SZKLANA | FLAG_KAUCYJNA, "base_value": 1.0, "region": Rect2(0, 0, 13, 18)},
	{"flags": FLAG_SZKLANA, "base_value": 1.0, "region": Rect2(13, 0, 13, 18)},
	{"flags": FLAG_KAUCYJNA, "base_value": 1.0, "region": Rect2(26, 0, 13, 18)},
	{"flags": 0, "base_value": 1.0, "region": Rect2(39, 0, 13, 18)},
	{"flags": FLAG_SZKLANA | FLAG_KAUCYJNA, "base_value": 1.5, "region": Rect2(52, 0, 13, 18)},
	{"flags": FLAG_SZKLANA, "base_value": 1.2, "region": Rect2(65, 0, 13, 18)}
]

@export_range(0.2, 2.0, 0.05) var shape_cycle_interval := 0.75
@export_range(5.0, 30.0, 1.0) var lifetime_seconds := 12.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var value: float = 0.0
var _current_type := 0

func _ready() -> void:
	_current_type = randi_range(0, BOTTLE_TYPES.size() - 1)
	_set_type(_current_type)
	_cycle_shapes()
	_expire_after_lifetime()

func _set_type(index: int) -> void:
	var type_data: Dictionary = BOTTLE_TYPES[index]
	value = _calculate_value(int(type_data["flags"]), float(type_data["base_value"]))

	var texture := AtlasTexture.new()
	texture.atlas = SPRITESHEET
	texture.region = type_data["region"]

	var frames := animated_sprite.sprite_frames.duplicate(true) as SpriteFrames
	frames.set_frame(&"bootle", 0, texture)
	animated_sprite.sprite_frames = frames
	form_changed.emit(value)

func _cycle_shapes() -> void:
	while is_inside_tree():
		await get_tree().create_timer(shape_cycle_interval).timeout
		if not is_inside_tree():
			return
		_current_type = (_current_type + 1) % BOTTLE_TYPES.size()
		_set_type(_current_type)

func _expire_after_lifetime() -> void:
	await get_tree().create_timer(lifetime_seconds).timeout
	if is_inside_tree():
		queue_free()

func _calculate_value(flags: int, base_value: float) -> float:
	var bottle_value := base_value
	if flags & FLAG_SZKLANA:
		bottle_value *= 2.0
	if not (flags & FLAG_KAUCYJNA):
		bottle_value *= -3.0
	return bottle_value
