extends Sprite2D
@export var rock_textures: Array[Texture2D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if rock_textures.size() > 0:
		texture = rock_textures[randi() % rock_textures.size()]
		rotation = randf() * TAU

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
