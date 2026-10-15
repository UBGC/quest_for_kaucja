class_name Bottle
extends Area2D

# 1. Definicja flag bitowych za pomocą potęg dwójki (przesunięcie bitowe)
const FLAG_SZKLANA = 1 << 0    # 1 (binarnie: 01)
const FLAG_KAUCYJNA = 1 << 1  # 2 (binarnie: 10)
var graczScena = preload("res://player.tscn")

var spritesheet: Texture2D = preload("res://BottleSpriteSheet.png")
var value: float = 0.0

# Baza danych 6 typów butelek (współrzędne na spritesheet w pikselach: Rect2(x, y, szerokość, wysokość))
# Załóżmy, że każda ikonka butelki ma wymiary 32x64 piksele i leżą one w rzędzie obok siebie.
var bottle_types = [
	{
		"flags": FLAG_SZKLANA | FLAG_KAUCYJNA, # Szklana (1) + Kaucyjna (2) = 3
		"base_value": 1.0, 
		"region": Rect2(0, 0, 13, 18)
	},
	{
		"flags": FLAG_SZKLANA,                 # Tylko Szklana (1)
		"base_value": 1.0,
		"region": Rect2(13, 0, 13, 18)
	},
	{
		"flags": FLAG_KAUCYJNA,                # Tylko Kaucyjna (2)
		"base_value": 1.0,
		"region": Rect2(26, 0, 13, 18)
	},
	{
		"flags": 0,                            # Zwykła (ani szklana, ani kaucyjna - np. plastykowa jednorazowa)
		"base_value": 1.0,
		"region": Rect2(39, 0, 13, 18)
	},
	{
		"flags": FLAG_SZKLANA | FLAG_KAUCYJNA, # Kolejny wariant szklanej kaucyjnej
		"base_value": 1.5,
		"region": Rect2(52, 0, 13, 18)
	},
	{
		"flags": FLAG_SZKLANA,                 # Kolejny wariant szklanej niekaucyjnej
		"base_value": 1.2,
		"region": Rect2(65, 0, 13, 18)
	}
]

func _ready() -> void:
	var bottle_data := losuj_butelke()
	value = float(bottle_data["value"])

	var frames: SpriteFrames = $AnimatedSprite2D.sprite_frames.duplicate()
	frames.set_frame(&"bootle", 0, bottle_data["texture"] as Texture2D)
	$AnimatedSprite2D.sprite_frames = frames
	losuj_butelke()

func losuj_butelke() -> Dictionary:
	# 1. Losujemy jeden z 6 słowników z tablicy (Godot 4 ma wygodną funkcję pick_random())
	var dane_butelki = bottle_types.pick_random()
	
	# 2. Obliczamy ostateczną cenę na podstawie flag
	var ostateczna_wartosc = oblicz_wartosc(dane_butelki["flags"], dane_butelki["base_value"])
	
	# 3. Tworzymy dynamicznie AtlasTexture, żeby wyciąć odpowiedni fragment ze spritesheetu
	var atlas_texture = AtlasTexture.new()
	atlas_texture.atlas = spritesheet
	atlas_texture.region = dane_butelki["region"]
	
	return {
		"texture": atlas_texture,
		"value": ostateczna_wartosc,
		"flags": dane_butelki["flags"]
	}

func oblicz_wartosc(flags: int, base_value: float) -> float:
	var value = base_value
	
	# Sprawdzamy, czy flaga SZKLANA jest ustawiona (operacja bitowa AND: &)
	if flags & FLAG_SZKLANA:
		value *= 2.0 # Wartość dwukrotnie wyższa
		
	# Sprawdzamy, czy flaga KAUCYJNA jest ustawiona
	if not (flags & FLAG_KAUCYJNA):
		# Jeśli NIE jest kaucyjna, stosujemy karę -3 zł (lub ustawiamy sztywno -3)
		value *= -3.0 
		# Uwaga: jeśli chcesz, aby kara -3 była niezależna od bazy, możesz dać np. value -= 3.0
		
	return value


func _on_body_entered(_body: Node2D) -> void:
	queue_free()
