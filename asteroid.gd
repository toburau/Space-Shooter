extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	var rect = get_viewport_rect()
	var cx = rect.size.x / 2
	var cy = rect.size.y / 2
	var tx = randi_range(cx - 100, cx + 100)
	var ty = randi_range(cy - 100, cy + 100)
	velocity.x = tx - position.x
	velocity.y = ty - position.y
	velocity = velocity.normalized() * randi_range(100, 300)

func _physics_process(delta: float) -> void:

	move_and_slide()
