extends Control

@onready var restartButton = %Button
@onready var quitButton = %Button2

var timeOpen : float = 0.0;

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerVariables.optionsOpen = true;
	if PlayerVariables.gameStarted:
		restartButton.visible = true;
	else:
		restartButton.visible = false;
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('options') && timeOpen > 0.0:
		PlayerVariables.optionsOpen = false;
		queue_free();
	timeOpen += delta;

func _on_button_pressed():
	PlayerVariables.reset();
	get_tree().change_scene_to_file("res://assets/home.tscn")

func _on_button_2_pressed():
	get_tree().quit();

func _on_h_slider_value_changed(value : float):
	PlayerVariables.soundVolume = value;
	if PlayerVariables.player != null:
		PlayerVariables.player.updateSoundSettings(value);