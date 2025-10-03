extends CharacterBody2D

@export var size := 0 # large=0 middle=1 small=2

@export var asteroid_scene_mid : PackedScene
@export var asteroid_scene_small : PackedScene

var sprite_size = Vector2(120,120)

var rot_speed = 0

func _ready() -> void:
	if size != 0:
		$AudioStreamPlayer.play()

func _physics_process(delta: float) -> void:
	rotation += rot_speed
	move_and_slide()

	# Playerとの当たり判定
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("player"):
			collider.take_damage()
			take_damage()
			return
	
	var rect = get_viewport_rect().grow(sprite_size.length())
	if not rect.has_point(global_position):
		queue_free()

func take_damage() -> void:
	match size:
		0:
			_spawn_split(asteroid_scene_mid,2)
		1:
			_spawn_split(asteroid_scene_small,2)
		2:
			pass
	queue_free()

func _spawn_split(scene: PackedScene, count: int) -> void:
	# count個に分裂
	for i in count:
		var new_asteroid = scene.instantiate()
		new_asteroid.global_position = global_position
		# ランダム方向を少しずつずらす
		var angle = TAU * randf()
		var dir = Vector2.RIGHT.rotated(angle)
		var speed = velocity.length()
		new_asteroid.velocity = dir * speed * 1.1
		new_asteroid.rot_speed = randf_range(-1.0,1.0) * TAU * 0.01
		new_asteroid.size = size + 1
		get_parent().add_child(new_asteroid)
