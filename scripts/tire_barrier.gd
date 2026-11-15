extends StaticBody2D
func _ready():
	add_to_group("tires")
func on_car_hit(_normal):
	var tween = create_tween()
	tween.tween_property($Sprite2D, "scale", Vector2(1.3, 0.7), 0.05)
	tween.tween_property($Sprite2D, "scale", Vector2(1.0, 1.0), 0.1)
