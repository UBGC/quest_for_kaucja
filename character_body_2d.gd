extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 0

	var direction = Vector2(
	Input.get_axis("Left", "Right"),
	Input.get_axis("Up", "Down")
)
	if direction.y == -1:
		velocity.y = -1 * SPEED
		animated_sprite.play("run")
	elif direction.y == 1:
		velocity.y = SPEED
		animated_sprite.play("run")
	else:
		velocity.y = 0
	if direction.x == -1:
		velocity.x = -1 * SPEED
		animated_sprite.play("run")
		animated_sprite.flip_h = false
	elif direction.x == 1:
		velocity.x = SPEED
		animated_sprite.play("run")
		animated_sprite.flip_h = true
	else:
		velocity.x = 0
		animated_sprite.play("idle")



	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Bootle"):
		queue_free()
