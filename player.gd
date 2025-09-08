extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

@export var bullet: PackedScene
@export var bullet_speed: float = 600.0

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
		rotation = velocity.angle()
	else:
		velocity = Vector2.ZERO

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.length() > 0:
		rotation = velocity.angle() + PI/2

	# 弾
	var stick_right_input = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_X),
		Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	)
	if stick_right_input.length() < 0.2:
		stick_right_input = Vector2.ZERO
	var shoot_dir = stick_right_input.normalized()

	if Input.is_action_just_pressed("shoot"):
		global_position.x = 200
		global_position.y = 200
		shoot(shoot_dir)

func shoot(direction: Vector2) -> void:
	var newBullet = bullet.instantiate()
	newBullet.global_position = global_position
	newBullet.direction = direction  # 弾側に `direction: Vector2` を用意
	newBullet.speed = bullet_speed
	get_tree().current_scene.add_child(newBullet)
