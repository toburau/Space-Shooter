extends Node2D
@export var explosion_textures: Array[Texture2D]
@export var wait_time: float = 0.5   # 表示して待つ秒数 (x秒)
@export var shrink_time: float = 0.2 # スケールを0にするまでの秒数 (y秒)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if explosion_textures.size() > 0:
		$Sprite2D.texture = explosion_textures[randi() % explosion_textures.size()]
	rotation = randf() * TAU
	
	explode()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func explode() -> void:
	await get_tree().create_timer(wait_time).timeout
	
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, shrink_time)
	tween.tween_callback(queue_free) # 消去
