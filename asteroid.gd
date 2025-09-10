extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:

	velocity.y = 0;
	velocity.x = 0;

	move_and_slide()
