extends CharacterBody2D

@export var speed: float = 400.0
@export var stop_distance: float = 400.0

var player: Node2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var direction = player.global_position - global_position
	var distance = direction.length()
	if distance > stop_distance:
		velocity = direction.normalized() * speed
		rotation = velocity.angle() - PI/2
	else:
		velocity = Vector2.ZERO
	move_and_slide()
