extends Sprite2D
@export var lifetime: float = 1.0


func _ready():
	$Timer.start(lifetime/1000)

func _process(delta):
	if modulate.a <= 0.1:
		queue_free


func fadeSprite():
	modulate.a -= lifetime/100
