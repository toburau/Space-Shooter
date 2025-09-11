extends Node2D

@export var asteroid_scene : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("debug")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		spawn_asteroid()

func spawn_asteroid():
	var asteroid = asteroid_scene.instantiate()
	var sprite = asteroid.get_node_or_null("rock_sprite2D") as Sprite2D
	var sprite_size = Vector2.ZERO
	if sprite and sprite.texture:
		sprite_size = sprite.texture.get_size()
	var rect = get_viewport_rect()
	var screen_size = rect.size
	var x = randf_range(0, screen_size.x)
	var y = randf_range(0, screen_size.y)
	var n = randi_range(0, 3)
	match n:
		0:
			y = -sprite_size.y
		1:
			x = screen_size.x + sprite_size.x
		2:
			y = screen_size.y + sprite_size.y
		3:
			x = -sprite_size.x
	asteroid.position = Vector2(x,y)
	add_child(asteroid)
	
