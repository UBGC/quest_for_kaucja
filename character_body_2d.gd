extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

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


func _on_area_2d_area_entered(area: Area2D) -> void:
	global.money += area.value
	area.queue_free()
