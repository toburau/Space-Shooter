extends Node2D

@export var asteroid_scene : PackedScene
@export var enemy_ram_scene : PackedScene
@export var enemy_shooter_scene: PackedScene

var spawn_interval = 2.0
var spawn_timer = spawn_interval

var screen_size : Vector2
var gameover_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rect = get_viewport_rect()
	screen_size = rect.size
	$CanvasLayer/Control/Label.visible = false
	gameover_timer = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug1"):
		spawn_asteroid()
	if Input.is_action_just_pressed("debug2"):
		spawn_enemy(0)
	if Input.is_action_just_pressed("debug3"):
		spawn_enemy(1)

	if not $Player.alive:
		$AudioStreamPlayer.stop()
		if $CanvasLayer/Control/Label.visible:
			gameover_timer += delta
			if gameover_timer > 5.0:
				get_tree().change_scene_to_file("res://title_screen.tscn")
		else:
			gameover_timer += delta
			if gameover_timer > 1.0:
				gameover_timer = 0
				$CanvasLayer/Control/Label.visible = true
		return

	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_timer = spawn_interval
		match randi_range(0,2):
			0:
				spawn_asteroid()
			1:
				spawn_enemy(0)
			2:
				spawn_enemy(1)

func get_spawn_position(size: Vector2) -> Vector2:
	var x = randf_range(0, screen_size.x)
	var y = randf_range(0, screen_size.y)
	var n = randi_range(0, 3)
	match n:
		0:
			y = -size.y
		1:
			x = screen_size.x + size.x
		2:
			y = screen_size.y + size.y
		3:
			x = -size.x
	return Vector2(x,y)

func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	var sprite_size = Vector2(120,120) # 最大の隕石のサイズ
	asteroid.position = get_spawn_position(sprite_size)
	var cx = screen_size.x / 2
	var cy = screen_size.y / 2
	var tx = randi_range(cx - 100, cx + 100)
	var ty = randi_range(cy - 100, cy + 100)
	asteroid.velocity.x = tx - asteroid.position.x
	asteroid.velocity.y = ty - asteroid.position.y
	asteroid.velocity = asteroid.velocity.normalized() * randi_range(100, 300)
	asteroid.rot_speed = randf_range(-1.0,1.0) * TAU * 0.01
	asteroid.size = 0
	add_child(asteroid)

func spawn_enemy(type :int):
	var enemy = null
	match type:
		0:
			enemy = enemy_ram_scene.instantiate()
		1:
			enemy = enemy_shooter_scene.instantiate()
	if enemy == null:
		return
	var sprite = enemy.get_node_or_null("Sprite2D") as Sprite2D
	var sprite_size = Vector2.ZERO
	if sprite and sprite.texture:
		sprite_size = sprite.texture.get_size()
	enemy.position = get_spawn_position(sprite_size/2)	
	add_child(enemy)	
