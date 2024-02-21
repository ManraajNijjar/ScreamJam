extends Node3D

@export var player : Node3D;
@onready var soundbankSubwayEnvLoop = $SubwayEnvLoop
@onready var worldEnvironment : WorldEnvironment = $WorldEnvironment
@onready var directionalLight : DirectionalLight3D = $DirectionalLight3D

@onready var sittingSpawn = $SeatSpawnLocation
@onready var standingSpawn = $StandSpawnLocation


signal toOffice
signal toHousePM

var currentColor : Color = Color("d5bf8e");
var transitionToRed : bool = false;
var transitionToRedPercent : float = 0.0;

var fogMachineEnabled : bool = false;
var fogMachineDensity : float = 0.0;
@export var fogMachineCap : float = 0.3625;

var lightSpinEnabled : bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():

	toOffice.connect(goToOffice);
	toHousePM.connect(goToHousePM);

	var timeOfDayString = "";
	if(PlayerVariables.time == PlayerVariables.TIMEOFDAY.MORNING):
		morningLight();
		timeOfDayString = "am";
	elif(PlayerVariables.time == PlayerVariables.TIMEOFDAY.NIGHT):
		nightLight();
		timeOfDayString = "pm";

	if(PlayerVariables.day == 0):
		if(PlayerVariables.time == PlayerVariables.TIMEOFDAY.MORNING):
			DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_train_am")
		elif(PlayerVariables.time == PlayerVariables.TIMEOFDAY.NIGHT):
			DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_train_pm")
	else:
		DialogueManager.show_example_dialogue_balloon(load("res://narrative/day_"+str(PlayerVariables.day+1)+".dialogue"), "day_"+str(PlayerVariables.day+1)+"_train_"+timeOfDayString)
	
	soundbankSubwayEnvLoop.post_event();
	standSpawn();
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

func goToOffice():
	get_tree().change_scene_to_file("res://assets/office.tscn")
	pass

func goToHousePM():
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