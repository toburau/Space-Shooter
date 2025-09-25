extends CharacterBody2D

var screen_size # Size of the game window.
var player_size := Vector2.ZERO
var alive := true

@export var accel := 800.0   # 加速力
@export var friction := 300.0 # 摩擦（慣性をどれくらい残すか）
@export var max_speed := 400.0

@export var bullet: PackedScene
@export var bullet_speed: float = 600.0

@onready var muzzle = $Muzzle

@export var fire_rate: float = 0.2 # 連射間隔（秒）
var fire_cooldown: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	var sprite = get_node("Ship") as Sprite2D
	player_size = sprite.texture.get_size()
	rotation = -PI/2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not alive:
		return

	# キーボード入力（8方向）
	var key_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# ジョイスティックの左スティック入力（0番コントローラー）
	var stick_left_input = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	)
	# デッドゾーン処理
	if stick_left_input.length() < 0.2:
		stick_left_input = Vector2.ZERO
	# 優先度：スティック > キーボード
	var input_vector = stick_left_input if stick_left_input.length() > 0 else key_input

	# 加速、減速
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()
		velocity += input_vector * accel * delta
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	# 最大速度
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
		
	# 弾	
	var stick_right_input = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	)
	var shoot_dir = Vector2.ZERO
	if stick_right_input.length() > 0.2:
		shoot_dir = stick_right_input.normalized()
		rotation = shoot_dir.angle()
	# クールダウンを減らす
	if fire_cooldown > 0.0:
		fire_cooldown -= delta
	if shoot_dir != Vector2.ZERO and fire_cooldown <= 0.0:
		shoot(shoot_dir)
		fire_cooldown = fire_rate
		
	move_and_slide()
	
	# X座標をラップ
	if position.x < -player_size.x/2:
		position.x = screen_size.x + player_size.x/2
	elif position.x > screen_size.x + player_size.x/2:
		position.x = -player_size.x/2

	# Y座標をラップ
	if position.y < -player_size.y/2:
		position.y = screen_size.y + player_size.y/2
	elif position.y > screen_size.y + player_size.y/2:
		position.y = -player_size.y/2

func shoot(direction: Vector2) -> void:
	var newBullet = bullet.instantiate()
	newBullet.global_position = muzzle.global_position
	newBullet.direction = direction  # 弾側に `direction: Vector2` を用意
	newBullet.rotation = direction.angle()
	newBullet.speed = bullet_speed
	get_tree().current_scene.add_child(newBullet)

func take_damage() -> void:
	alive = false
	$Ship.visible = false
	var explosion = preload("res://explosion.tscn").instantiate()
	explosion.global_position = global_position
	explosion.global_scale = Vector2(0.3, 0.3)
	explosion.wait_time = 0.7
	explosion.shrink_time = 0.2
	get_parent().add_child(explosion)
	
