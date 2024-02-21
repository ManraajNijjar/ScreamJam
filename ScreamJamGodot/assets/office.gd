extends Node3D

@export var player : Node3D;

@onready var worldEnvironment : WorldEnvironment = $WorldEnvironment
@onready var directionalLight : DirectionalLight3D = $DirectionalLight3D
@onready var lights = $Lights
@onready var spotLight = $SpotLight3D

var currentColor : Color = Color("87abdf");
var transitionToRed : bool = false;
var transitionToRedPercent : float = 0.0;

var fogMachineEnabled : bool = false;
var fogMachineDensity : float = 0.0;
@export var fogMachineCap : float = 0.3625;

var lightSpinEnabled : bool = false;

signal toTrainPM

# Called when the node enters the scene tree for the first time.
func _ready():

	toTrainPM.connect(goToTrainPM);

	if(PlayerVariables.day == 0):
		DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_office")
	
	spotlightEffect();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(transitionToRed):
		var blendedColor = currentColor.lerp(Color.RED, transitionToRedPercent * 0.05);
		worldEnvironment.environment.ambient_light_color = blendedColor;
		transitionToRedPercent += delta/2;
		if(currentColor == Color.RED):
			transitionToRed = false;
	
	if(fogMachineEnabled):
		worldEnvironment.environment.volumetric_fog_enabled = true;
		worldEnvironment.environment.volumetric_fog_density = fogMachineDensity;
		fogMachineDensity += delta * 0.01;
		if(fogMachineDensity >= fogMachineCap):
			fogMachineEnabled = false;

	if(lightSpinEnabled):
		directionalLight.rotation.y += delta/2;
		pass
	pass

func goToTrainPM():
	get_tree().change_scene_to_file("res://assets/subway.tscn")
	pass

func toRed():
	currentColor = worldEnvironment.environment.ambient_light_color;
	transitionToRed = true;

func fogMachine():
	worldEnvironment.environment.volumetric_fog_enabled = true;
	worldEnvironment.environment.volumetric_fog_density = 0.0;
	worldEnvironment.environment.volumetric_fog_sky_affect = 0.555;
	fogMachineEnabled = true;

func lightSpin():
	lightSpinEnabled = true;
	pass

func spotlightEffect():
	spotLight.visible = true;
	lights.visible = false;
	worldEnvironment.environment.ambient_light_energy = 0;
	directionalLight.visible = false;

	pass