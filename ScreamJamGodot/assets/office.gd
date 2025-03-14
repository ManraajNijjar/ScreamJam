extends Node3D

@export var player : Node3D;

@onready var worldEnvironment : WorldEnvironment = $WorldEnvironment
@onready var directionalLight : DirectionalLight3D = $DirectionalLight3D
@onready var lights = $Lights
@onready var spotLight = $SpotLight3D

@onready var monitor1 = $Monitor1
@onready var monitor2 = $Monitor2
@onready var foreground = $foreground

@onready var soundBankOfficeEnv = $OfficeEnv
@onready var soundBankJumpScare = $JumpScare

@onready var endOfficeEnvLoop = $EndOfficeEnvLoop

var currentColor : Color = Color("87abdf");
var transitionToRed : bool = false;
var transitionToRedPercent : float = 0.0;

var fogMachineEnabled : bool = false;
var fogMachineDensity : float = 0.0;
@export var fogMachineCap : float = 0.3625;

var lightSpinEnabled : bool = false;

var previousSanity = 100;

signal toTrainPM
signal showMouseSignal
signal hideMouseSignal
signal jumpScareSound

# Called when the node enters the scene tree for the first time.
func _ready():

	toTrainPM.connect(goToTrainPM);
	showMouseSignal.connect(showMouse);
	hideMouseSignal.connect(hideMouse);
	jumpScareSound.connect(jumpScareSoundFunction);

	if(PlayerVariables.day == 0):
		DialogueManager.show_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_office")
	else:
		DialogueManager.show_dialogue_balloon(load("res://narrative/day_"+str(PlayerVariables.day+1)+".dialogue"), "day_"+str(PlayerVariables.day+1)+"_office")
	
	soundBankOfficeEnv.post_event();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	processSanityChanges();
	if(transitionToRed):
		var blendedColor = currentColor.lerp(Color.RED, transitionToRedPercent * 0.05);
		worldEnvironment.environment.ambient_light_color = blendedColor;
		transitionToRedPercent += delta/2;
		if(currentColor == Color.RED):
			transitionToRed = false;
	
	if(fogMachineEnabled):
		worldEnvironment.environment.volumetric_fog_enabled = true;
		worldEnvironment.environment.volumetric_fog_density = fogMachineDensity;
		fogMachineDensity += delta * 0.1;
		if(fogMachineDensity >= fogMachineCap):
			fogMachineEnabled = false;

	if(lightSpinEnabled):
		directionalLight.rotation.y += delta/2;
		pass
	pass

func processSanityChanges():
	if PlayerVariables.sanity != previousSanity:
		previousSanity = PlayerVariables.sanity;
		print("Sanity: " + str(PlayerVariables.sanity));
		Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.SANITY, PlayerVariables.sanity, $Music);
		if PlayerVariables.sanity <= 20:
			fogMachineEnabled = true;

		if PlayerVariables.sanity <= 55:
			foreground.texture = load("res://images/Office scene assets/darkest/OfficeBG-darkest-foreground.PNG")
			monitor1.texture = load("res://images/Office scene assets/desktopbg-darkest.png")
			monitor2.texture = load("res://images/Office scene assets/desktopbg-darkest.png")
			worldEnvironment.environment.sky.sky_material.panorama = load("res://images/Office scene assets/darkest/OfficeBG-darkest-skybox.PNG")
		elif PlayerVariables.sanity < 80:
			foreground.texture = load("res://images/Office scene assets/darker/OfficeBG-darker-foreground.PNG")
			monitor1.texture = load("res://images/Office scene assets/desktopbg-darker.png")
			monitor2.texture = load("res://images/Office scene assets/desktopbg-darker.png")
			worldEnvironment.environment.sky.sky_material.panorama = load("res://images/Office scene assets/darker/OfficeBG-darker-skybox.PNG")
		elif PlayerVariables.sanity < 100:
			foreground.texture = load("res://images/Office scene assets/dark/OfficeBG-dark-foreground.PNG")
			monitor1.texture = load("res://images/Office scene assets/desktopbg-dark.png")
			monitor2.texture = load("res://images/Office scene assets/desktopbg-dark.png")
			worldEnvironment.environment.sky.sky_material.panorama = load("res://images/Office scene assets/dark/OfficeBG-dark-skybox.PNG")
	

func goToTrainPM():
	#soundBankOfficeEnv.stop_event();
	endOfficeEnvLoop.post_event();
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

func showMouse():
	player.selectingOption = true;
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

func hideMouse():
	player.selectingOption = false;
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func jumpScareSoundFunction():
	soundBankJumpScare.post_event()
	pass;
