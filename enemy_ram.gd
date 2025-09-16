extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var player: Node2D

func _ready():
	player = get_tree().get_first_node_in_group("player")
	print(player)

func _physics_process(delta: float) -> void:
	move_and_slide()
