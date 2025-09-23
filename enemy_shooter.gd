extends CharacterBody2D

@export var bullet: PackedScene

@export var speed: float = 400.0
@export var stop_distance: float = 400.0
@export var attack_wait: float = 0.3
@export var rotate_speed: float = 0.1
@export var escape_speed: float = 500.0

enum State { kMove, kAttack, kAttackAfter, kRotate, kEscape }

var player: Node2D
var sprite_size
var state: State = State.kMove
var attack_timer: float = 0;
var escape_direction: float

func _ready() -> void:
	var sprite = $Sprite2D
	sprite_size = sprite.texture.get_size()
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		return

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var direction = player.global_position - global_position
	var distance = direction.length()
	
	match state:
		State.kMove:
			# プレイヤーに一定距離まで近づく
			if distance > stop_distance:
				velocity = direction.normalized() * speed
				rotation = velocity.angle()
			else:
				velocity = Vector2.ZERO
				state = State.kAttack
				attack_timer = attack_wait
		State.kAttack:
			# 一定時間待ってから、弾発射
			attack_timer -= delta
			if attack_timer <= 0:
				shoot(direction.normalized())
				attack_timer = attack_wait
				state = State.kAttackAfter
		State.kAttackAfter:
			# 一定時間待ってから、回転
			attack_timer -= delta
			if attack_timer <= 0:
				state = State.kRotate
				escape_direction = (player.global_position - global_position).angle() + PI
		State.kRotate:
			# プレイヤーと反対方向に回転
			rotation = rotate_toward(rotation, escape_direction, rotate_speed)
			var diff = angle_difference(rotation, escape_direction)
			if abs(diff) < rotate_speed:
				state = State.kEscape
				velocity = -direction.normalized() * escape_speed
		State.kEscape:
			# 画面外まで移動
			var rect = get_viewport_rect().grow(sprite_size.length()/2)
			if not rect.has_point(global_position):
				queue_free()
	move_and_slide()

func shoot(dir: Vector2):
	var newBullet = bullet.instantiate()
	newBullet.global_position = $Marker2D.global_position
	newBullet.direction = dir
	get_tree().current_scene.add_child(newBullet)
