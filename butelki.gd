extends Node

# 1. Definicja flag bitowych za pomocą potęg dwójki (przesunięcie bitowe)
const FLAG_SZKLANA = 1 << 0    # 1 (binarnie: 01)
const FLAG_KAUCYJNA = 1 << 1  # 2 (binarnie: 10)
var graczScena = preload("res://player.tscn")
var value: float = 0.0
@onready var bottle_sprite: AnimatedSprite2D = $AnimatedSprite2D

var spritesheet: Texture2D = preload("res://BottleSpriteSheet.png")

# Baza danych 6 typów butelek (współrzędne na spritesheet w pikselach: Rect2(x, y, szerokość, wysokość))
# Załóżmy, że każda ikonka butelki ma wymiary 32x64 piksele i leżą one w rzędzie obok siebie.
var bottle_types = [
	{
		"flags": FLAG_KAUCYJNA, # Szklana (1) + Kaucyjna (2) = 3
		"base_value": 1.0, 
		"region": Rect2(0, 0, 13, 18)
	},
	{
		"flags": FLAG_KAUCYJNA, # Kaucyjna
		"base_value": 1.0,
		"region": Rect2(13, 0, 13, 18)
	},
	{
		"flags": FLAG_KAUCYJNA,                # Tylko Kaucyjna (2)
		"base_value": 1.0,
		"region": Rect2(26, 0, 13, 18)
	},
	{
		"flags": FLAG_SZKLANA,                            # Zwykła (ani szklana, ani kaucyjna - np. plastykowa jednorazowa)
		"base_value": 1.0,
		"region": Rect2(39, 0, 13, 18)
	},
	{
		"flags": FLAG_SZKLANA, # Niekaucyjna
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
	var dane_butelki = losuj_butelke()
	value = dane_butelki["value"]
	var klatki_animacji: SpriteFrames = bottle_sprite.sprite_frames.duplicate() as SpriteFrames
	klatki_animacji.set_frame(&"bootle", 0, dane_butelki["texture"])
	bottle_sprite.sprite_frames = klatki_animacji
	get_tree().create_timer(6.0).timeout.connect(queue_free)

func losuj_butelke() -> Dictionary:
	var kaucyjne = []
	var niekaucyjne = []
	for typ_butelki in bottle_types:
		if (typ_butelki["flags"] & FLAG_KAUCYJNA) != 0:
			kaucyjne.append(typ_butelki)
		else:
			niekaucyjne.append(typ_butelki)

	var dane_butelki
	if randf() < 0.25:
		dane_butelki = niekaucyjne.pick_random()
	else:
		dane_butelki = kaucyjne.pick_random()
	
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
	var obliczona_wartosc = base_value
	
	# Sprawdzamy, czy flaga SZKLANA jest ustawiona (operacja bitowa AND: &)
	if flags & FLAG_SZKLANA:
		obliczona_wartosc *= 2.0 # Wartość dwukrotnie wyższa
		
	# Sprawdzamy, czy flaga KAUCYJNA jest ustawiona
	if not (flags & FLAG_KAUCYJNA):
		# Jeśli NIE jest kaucyjna, stosujemy karę -3 zł (lub ustawiamy sztywno -3)
		obliczona_wartosc *= -3.0 
		# Uwaga: jeśli chcesz, aby kara -3 była niezależna od bazy, możesz dać np. value -= 3.0
		
	return obliczona_wartosc


func _on_body_entered(_body: Node2D) -> void:
	queue_free()
