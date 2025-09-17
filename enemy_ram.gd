extends CharacterBody2D

@export var speed := 500
@export var rot := 360

var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	$Sprite2D.rotation_degrees += rot * delta
	move_and_slide()
