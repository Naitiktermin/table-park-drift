extends CanvasLayer

@export var player: CharacterBody2D

func _ready():
	var gear = get_node_or_null("MarginContainer/VBoxContainer/GearLabel")
	if gear:
		gear.queue_free()

func _process(_delta):
	if player:
		$MarginContainer/VBoxContainer/SpeedLabel.text = str(int(player.velocity.length() * 0.28)) + " KM/H"
