extends Node2D

@export var asteroid_scene : PackedScene
@export var enemy_ram_scene : PackedScene
var screen_size : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rect = get_viewport_rect()
	screen_size = rect.size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		#spawn_asteroid()
		spawn_enemy_ram()

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
	var sprite = asteroid.get_node_or_null("rock_sprite2D") as Sprite2D
	var sprite_size = Vector2.ZERO
	if sprite and sprite.texture:
		sprite_size = sprite.texture.get_size()
	asteroid.position = get_spawn_position(sprite_size)
	var cx = screen_size.x / 2
	var cy = screen_size.y / 2
	var tx = randi_range(cx - 100, cx + 100)
	var ty = randi_range(cy - 100, cy + 100)
	asteroid.velocity.x = tx - asteroid.position.x
	asteroid.velocity.y = ty - asteroid.position.y
	asteroid.velocity = asteroid.velocity.normalized() * randi_range(100, 300)
	asteroid.size = 0
	add_child(asteroid)

func spawn_enemy_ram():
	var enemy_ram = enemy_ram_scene.instantiate()
	var sprite = enemy_ram.get_node_or_null("Sprite2D") as Sprite2D
	var sprite_size = Vector2.ZERO
	if sprite and sprite.texture:
		sprite_size = sprite.texture.get_size()
	enemy_ram.position = get_spawn_position(sprite_size)	
	add_child(enemy_ram)
	
