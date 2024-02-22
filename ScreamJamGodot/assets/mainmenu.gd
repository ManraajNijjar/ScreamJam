extends Control

@onready var altImage : Sprite2D = $Alt
@onready var soundBankMusic = $Music

var time : float = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	Wwise.load_bank("Init");
	Wwise.load_bank("MainSoundbank");
	soundBankMusic.post_event();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	altImage.modulate = Color(1, 1, 1, sin(time/5));
	print(sin(time));
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://assets/home.tscn")
	pass # Replace with function body.
