extends Area2D

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# キーボード入力（8方向）
	var key_input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# ジョイスティックの左スティック入力（0番コントローラー）
	var stick_input = Vector2(
		Input.get_joy_axis(0, JOY_AXIS_LEFT_X),
		Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	)
	# デッドゾーン処理
	if stick_input.length() < 0.2:
		stick_input = Vector2.ZERO
	# 優先度：スティック > キーボード
	var input_vector = stick_input if stick_input.length() > 0 else key_input

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
		
