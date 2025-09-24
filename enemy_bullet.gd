extends Area2D

var direction: Vector2 = Vector2.ZERO
@export var speed: float = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	# 画面外に出たら削除
	if not get_viewport_rect().has_point(global_position):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()
