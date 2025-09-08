extends Area2D

@export var speed: float = 600.0
var direction: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("b1 ", position, global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print("b ", position, global_position)
	position += direction * speed * delta
	# 画面外に出たら削除
	if not get_viewport_rect().has_point(global_position):
		queue_free()
