extends Control

@onready var restartButton = %Button
@onready var quitButton = %Button2

# Called when the node enters the scene tree for the first time.
func _ready():
	if PlayerVariables.gameStarted:
		restartButton.visible = true;
	else:
		restartButton.visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('options'):
		queue_free();

func _on_button_pressed():
	PlayerVariables.reset();
	get_tree().change_scene_to_file("res://assets/home.tscn")

func _on_button_2_pressed():
	get_tree().quit();
