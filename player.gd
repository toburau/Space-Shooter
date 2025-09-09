extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@export var bullet: PackedScene
@export var bullet_speed: float = 600.0

@onready var muzzle = $Muzzle

@export var fire_rate: float = 0.2  # 連射間隔（秒）
var fire_cooldown: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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

	var velocity = Vector2.ZERO
	if input_vector.length() > 0:
		velocity = input_vector.normalized() * speed
	else:
		velocity = Vector2.ZERO

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# 弾	
	var stick_right_input = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	)
	var shoot_dir = Vector2.ZERO
	if stick_right_input.length() > 0.2:
		shoot_dir = stick_right_input.normalized()
		rotation = shoot_dir.angle() + PI/2
	# クールダウンを減らす
	if fire_cooldown > 0.0:
		fire_cooldown -= delta
	if shoot_dir != Vector2.ZERO and fire_cooldown <= 0.0:
		shoot(shoot_dir)
		fire_cooldown = fire_rate

func shoot(direction: Vector2) -> void:
	var newBullet = bullet.instantiate()
	newBullet.global_position = muzzle.global_position
	newBullet.direction = direction  # 弾側に `direction: Vector2` を用意
	newBullet.rotation = direction.angle() + PI/2
	newBullet.speed = bullet_speed
	get_tree().current_scene.add_child(newBullet)
