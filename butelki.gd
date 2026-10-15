extends Node

# Flagi bitowe zdefiniowane jako kolejne potęgi dwójki.
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
		"flags": FLAG_KAUCYJNA,
		"base_value": 1.0, 
		"region": Rect2(0, 0, 13, 18)
	},
	{
		"flags": FLAG_KAUCYJNA, # Butelka objęta kaucją
		"base_value": 1.0,
		"region": Rect2(13, 0, 13, 18)
	},
	{
		"flags": FLAG_KAUCYJNA, # Butelka objęta kaucją
		"base_value": 1.0,
		"region": Rect2(26, 0, 13, 18)
	},
	{
		"flags": FLAG_SZKLANA, # Butelka nieobjęta kaucją
		"base_value": 1.0,
		"region": Rect2(39, 0, 13, 18)
	},
	{
		"flags": FLAG_SZKLANA, # Butelka nieobjęta kaucją
		"base_value": 1.5,
		"region": Rect2(52, 0, 13, 18)
	},
	{
		"flags": FLAG_SZKLANA, # Kolejny wariant butelki nieobjętej kaucją
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
	
	# Oblicz ostateczną wartość na podstawie flag.
	var ostateczna_wartosc = oblicz_wartosc(dane_butelki["flags"], dane_butelki["base_value"])
	
	# Wytnij odpowiedni fragment arkusza tekstur.
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
	
	# Szklane butelki mają podwojoną wartość.
	if flags & FLAG_SZKLANA:
		obliczona_wartosc *= 2.0
		
	if not (flags & FLAG_KAUCYJNA):
		# Butelki nieobjęte kaucją obniżają wynik.
		obliczona_wartosc *= -3.0
		
	return obliczona_wartosc


func _on_body_entered(_body: Node2D) -> void:
	queue_free()
