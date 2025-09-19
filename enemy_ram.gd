extends CharacterBody2D

@export var speed := 400
@export var rot := 360
@export var turn_speed = 1.0 # ラジアン/秒 (旋回の最大角速度)

var sprite_size
var player: Node2D
var direction = Vector2.RIGHT # 初期進行方向

func _ready():
	var sprite = $Sprite2D
	sprite_size = sprite.texture.get_size()

	player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	direction = (player.global_position - global_position).normalized()
	velocity = direction * speed

func _physics_process(delta: float) -> void:
	if player == null:
		return

	# モデル回転
	$Sprite2D.rotation_degrees += rot * delta
	
	# プレイヤーへの方向ベクトル
	var to_player = (player.global_position - global_position).normalized()
	
	# 現在の進行方向の角度
	var current_angle = direction.angle()
	# プレイヤー方向の角度
	var target_angle = to_player.angle()
	# 差分角度（-PI ～ PI に正規化）
	var angle_diff = wrapf(target_angle - current_angle, -PI, PI)
	
	# 一度に回せる最大角度
	var max_step = turn_speed * delta
	# 実際に回す角度（制限付き）
	var rotate_amount = clamp(angle_diff, -max_step, max_step)
	
	# 方向を更新
	direction = direction.rotated(rotate_amount).normalized()
	
	# 速度を進行方向に設定
	velocity = direction * speed
	move_and_slide()
	
	var rect = get_viewport_rect().grow(sprite_size.length()/2)
	if not rect.has_point(global_position):
		queue_free()

func take_damage() -> void:
	var explosion = preload("res://explosion.tscn").instantiate()
	explosion.global_position = global_position
	explosion.global_scale = Vector2(0.1, 0.1)
	get_parent().add_child(explosion)
	queue_free()
