extends CollisionShape2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 生成直後はコリジョン無効化
	disabled = true
	# 数フレーム後に有効化
	_enable_collision_later()

func _enable_collision_later() -> void:
	await get_tree().create_timer(1.0).timeout  # 0.1秒待つ（6フレーム程度）
	disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
