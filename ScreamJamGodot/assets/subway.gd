extends Node3D

@export var player : Node3D;
@onready var soundbankSubwayEnvLoop = $SubwayEnvLoop

@onready var endSubwayLoop = $EndSubwayEnvLoop

@onready var worldEnvironment : WorldEnvironment = $WorldEnvironment
@onready var directionalLight : DirectionalLight3D = $DirectionalLight3D

@onready var sittingSpawn = $SeatSpawnLocation
@onready var standingSpawn = $StandSpawnLocation

@onready var foreground = $foreground
@onready var foreground2 = $foreground2
@onready var foreground3 = $foreground3
@onready var foreground4 = $foreground4
@onready var foreground5 = $foreground5
@onready var foreground6 = $foreground6

@onready var group1 = $Commuters/group1
@onready var group2 = $Commuters/group2
@onready var group3 = $Commuters


signal toOffice
signal toHousePM
signal showMouseSignal
signal hideMouseSignal

var currentColor : Color = Color("d5bf8e");
var transitionToRed : bool = false;
var transitionToRedPercent : float = 0.0;

var fogMachineEnabled : bool = false;
var fogMachineDensity : float = 0.0;
@export var fogMachineCap : float = 0.3625;

var lightSpinEnabled : bool = false;

var previousSanity = 100;

# Called when the node enters the scene tree for the first time.
func _ready():

	toOffice.connect(goToOffice);
	toHousePM.connect(goToHousePM);
	showMouseSignal.connect(showMouse);
	hideMouseSignal.connect(hideMouse);

	var timeOfDayString = "";
	if(PlayerVariables.time == PlayerVariables.TIMEOFDAY.MORNING):
		morningLight();
		timeOfDayString = "am";
	elif(PlayerVariables.time == PlayerVariables.TIMEOFDAY.NIGHT):
		nightLight();
		timeOfDayString = "pm";
		foreground.visible = false
		foreground2.visible = false
		foreground3.visible = false
		foreground4.visible = true
		foreground5.visible = true
		foreground6.visible = true

	if(PlayerVariables.day == 0):
		if(PlayerVariables.time == PlayerVariables.TIMEOFDAY.MORNING):
			DialogueManager.show_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_train_am")
		elif(PlayerVariables.time == PlayerVariables.TIMEOFDAY.NIGHT):
			DialogueManager.show_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_train_pm")
	else:
		DialogueManager.show_dialogue_balloon(load("res://narrative/day_"+str(PlayerVariables.day+1)+".dialogue"), "day_"+str(PlayerVariables.day+1)+"_train_"+timeOfDayString)
	
	soundbankSubwayEnvLoop.post_event();
	sitSpawn();
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
			group3.visible = false;
			foreground.texture = load("res://images/BART scene assets/darkest/TransitBG-darkest-foreground.PNG")
			foreground2.texture = load("res://images/BART scene assets/darkest/TransitBG-darkest-foreground.PNG")
			foreground3.texture = load("res://images/BART scene assets/darkest/TransitBG-darkest-foreground.PNG")
			foreground4.texture = load("res://images/BART scene assets/darkest/TransitBG-darkest-foreground.PNG")
			foreground5.texture = load("res://images/BART scene assets/darkest/TransitBG-darkest-foreground.PNG")
			foreground6.texture = load("res://images/BART scene assets/darkest/TransitBG-darkest-foreground.PNG")
			worldEnvironment.environment.sky.sky_material.panorama = load("res://images/BART scene assets/darkest/TransitBG-darkest-skybox.PNG")
			
		elif PlayerVariables.sanity < 80:
			group2.visible = false;
			foreground.texture = load("res://images/BART scene assets/darker/TransitBG-darker-foreground.PNG")
			foreground2.texture = load("res://images/BART scene assets/darker/TransitBG-darker-foreground.PNG")
			foreground3.texture = load("res://images/BART scene assets/darker/TransitBG-darker-foreground.PNG")
			foreground4.texture = load("res://images/BART scene assets/darker/TransitBG-darker-foreground.PNG")
			foreground5.texture = load("res://images/BART scene assets/darker/TransitBG-darker-foreground.PNG")
			foreground6.texture = load("res://images/BART scene assets/darker/TransitBG-darker-foreground.PNG")
			worldEnvironment.environment.sky.sky_material.panorama = load("res://images/BART scene assets/darker/TransitBG-darker-skybox.PNG")
		elif PlayerVariables.sanity < 100:
			group1.visible = false;
			foreground.texture = load("res://images/BART scene assets/dark/TransitBG-dark-foreground.PNG")
			foreground2.texture = load("res://images/BART scene assets/dark/TransitBG-dark-foreground.PNG")
			foreground3.texture = load("res://images/BART scene assets/dark/TransitBG-dark-foreground.PNG")
			foreground4.texture = load("res://images/BART scene assets/dark/TransitBG-dark-foreground.PNG")
			foreground5.texture = load("res://images/BART scene assets/dark/TransitBG-dark-foreground.PNG")
			foreground6.texture = load("res://images/BART scene assets/dark/TransitBG-dark-foreground.PNG")
			worldEnvironment.environment.sky.sky_material.panorama = load("res://images/BART scene assets/dark/TransitBG-dark-skybox.PNG")
	

func goToOffice():
	#soundbankSubwayEnvLoop.stop_event();
	endSubwayLoop.post_event();
	get_tree().change_scene_to_file("res://assets/office.tscn")
	pass

func goToHousePM():
	#soundbankSubwayEnvLoop.stop_event();
	endSubwayLoop.post_event();
	get_tree().change_scene_to_file("res://assets/home.tscn")
	pass

func morningLight():
	worldEnvironment.environment.ambient_light_color = Color("d5bf8e");
	currentColor = Color("d5bf8e");
	worldEnvironment.environment.ambient_light_sky_contribution = 0.4;
	directionalLight.rotation = Vector3(deg_to_rad(-37.2), deg_to_rad(150), 0);
	directionalLight.light_color = Color("e8b87b");

func nightLight():
	worldEnvironment.environment.ambient_light_color = Color.BLACK
	currentColor = Color.BLACK;
	worldEnvironment.environment.ambient_light_sky_contribution = 0.0;
	directionalLight.rotation = Vector3(deg_to_rad(-37.2), deg_to_rad(25), 0);
	directionalLight.light_color = Color("fba9a1");

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

func sitSpawn():
	player.global_transform.origin = sittingSpawn.global_transform.origin
	player.canMove = false;

func standSpawn():
	player.global_transform.origin = standingSpawn.global_transform.origin
	player.canMove = false;

func altBackground():
	worldEnvironment.environment.sky.sky_material.panorama = load("res://images/BART scene assets/TransitBG-alt.PNG")

func showMouse():
	player.selectingOption = true;
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

func hideMouse():
	player.selectingOption = false;
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func emptyTrain():
	group1.visible = false;
	group2.visible = false;
	group3.visible = false;