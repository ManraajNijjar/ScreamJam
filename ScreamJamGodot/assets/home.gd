extends Node3D

@export var player : Node3D;
@onready var soundBankDarkMusic = $Dark_Music
@onready var soundBankCatMeow = $Cat_Meow
@onready var soundBankTVStatic = $TV_Static

@onready var morningSpawn = $MorningSpawnLocation
@onready var nightSpawn = $PMSpawnLocation
@onready var bedSpawn = $BedSpawnLocation

signal showCoffee
signal toTrainAM
signal showCall
signal toHouseAM
signal catMeow

# Called when the node enters the scene tree for the first time.
func _ready():

	showCoffee.connect(displayCoffeeScene);
	toTrainAM.connect(goToTrain);
	showCall.connect(displayPlayerCall);
	toHouseAM.connect(goToHouseAM);
	catMeow.connect(playCatMeow);

	Wwise.load_bank("Init");
	Wwise.load_bank("MainSoundbank");

	var timeOfDayString = "";
	if(PlayerVariables.time == PlayerVariables.TIMEOFDAY.MORNING):
		player.global_transform.origin = morningSpawn.global_transform.origin
		timeOfDayString = "am";
	elif(PlayerVariables.time == PlayerVariables.TIMEOFDAY.NIGHT):
		player.global_transform.origin = nightSpawn.global_transform.origin
		timeOfDayString = "pm";

	if(PlayerVariables.day == 0):
		if(PlayerVariables.time == PlayerVariables.TIMEOFDAY.MORNING):
			DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_house_am")
		elif(PlayerVariables.time == PlayerVariables.TIMEOFDAY.NIGHT):
			DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_house_pm")
	else:
		DialogueManager.show_example_dialogue_balloon(load("res://narrative/day_"+str(PlayerVariables.day+1)+".dialogue"), "day_"+str(PlayerVariables.day+1)+"_house_"+timeOfDayString)

	soundBankDarkMusic.post_event()
	soundBankTVStatic.post_event()
	pass # Replace with function body.

func displayCoffeeScene():
	pass;

func goToTrain():
	soundBankDarkMusic.stop_event()
	soundBankTVStatic.stop_event()
	get_tree().change_scene_to_file("res://assets/subway.tscn")
	pass;

func displayPlayerCall():
	#goToBed();
	player.displayCall();
	pass;

func playCatMeow():
	soundBankCatMeow.post_event()
	pass;

func goToHouseAM():
	pass;

func goToBed():
	player.global_transform.origin = bedSpawn.global_transform.origin
	player.canMove = false;
