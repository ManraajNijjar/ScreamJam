extends Node3D

@export var player : Node3D;
@onready var soundBankDarkMusic = $Music
@onready var soundBankCatMeow = $Music
@onready var soundBankTVStatic = $TV_Static
@onready var soundBankHomeEnv : AkEvent3D = $HomeEnv
@onready var soundBankJumpScare = $JumpScare
@onready var soundBankAlarmClock = $AlarmClock
@onready var soundBankCoffeeShop = $CoffeeShop

@onready var morningSpawn = $MorningSpawnLocation
@onready var nightSpawn = $PMSpawnLocation
@onready var bedSpawn = $BedSpawnLocation

@onready var light1 = $environment/light/OmniLight3D
@onready var light2 = $environment/light/OmniLight3D2

@onready var pictureFrame : Sprite3D = $PictureFrame

@onready var coffeeSceneControl : Control = $CoffeeScene

@onready var timeWipe : Control = $TimeWipe
@onready var wakeupTimer : Timer = $WakeupTimer

@onready var gambitSprite = $Gambit

var previousSanity = 100;

signal showCoffee
signal toTrainAM
signal showCall
signal toHouseAM
signal catMeow
signal showMouseSignal
signal hideMouseSignal
signal goToBed
signal turnOffAlarm
signal endGame
signal jumpScareSound
# Called when the node enters the scene tree for the first time.
func _ready():
	showCoffee.connect(displayCoffeeScene);
	toTrainAM.connect(goToTrain);
	showCall.connect(displayPlayerCall);
	toHouseAM.connect(goToHouseAM);
	catMeow.connect(playCatMeow);
	showMouseSignal.connect(showMouse);
	hideMouseSignal.connect(hideMouse);
	goToBed.connect(goToBedFunction);
	turnOffAlarm.connect(turnOffAlarmFunction);
	endGame.connect(endGameFunction);
	jumpScareSound.connect(jumpScareSoundFunction);

	#soundBankDarkMusic.post_event()

	var timeOfDayString = "";
	if(PlayerVariables.time == PlayerVariables.TIMEOFDAY.MORNING):
		player.global_transform.origin = morningSpawn.global_transform.origin
		timeOfDayString = "am";
	elif(PlayerVariables.time == PlayerVariables.TIMEOFDAY.NIGHT):
		player.global_transform.origin = nightSpawn.global_transform.origin
		timeOfDayString = "pm";
		light1.light_energy = 0.0
		light2.light_energy = 0.3

	if(PlayerVariables.day == 0):
		if(PlayerVariables.time == PlayerVariables.TIMEOFDAY.MORNING):
			DialogueManager.show_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_house_am")
		elif(PlayerVariables.time == PlayerVariables.TIMEOFDAY.NIGHT):
			DialogueManager.show_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_house_pm")
	else:
		DialogueManager.show_dialogue_balloon(load("res://narrative/day_"+str(PlayerVariables.day+1)+".dialogue"), "day_"+str(PlayerVariables.day+1)+"_house_"+timeOfDayString)

	if PlayerVariables.sanity <= 20:
		gambitSprite.visible = false;
	#soundBankTVStatic.post_event()
	#Wwise.post_event("Cat_Meow", self);
	#print(soundBankHomeEnv.set_event());
	Wwise.register_game_obj(gambitSprite, "Gambit")
	print(soundBankCatMeow.get_event());
	processSanityChanges();
	pass

func _process(delta):
	if Input.is_action_pressed("viewPhone"):
		#soundBankCatMeow.post_event()
		#Wwise.register_game_obj(self, "player")
		Wwise.post_event("Cat_Meow", gambitSprite);
		#print(AK.EVENTS);
		#Wwise.post_event_id(AK.EVENTS, self);
		pass
	processSanityChanges();



func processSanityChanges():
	if PlayerVariables.sanity != previousSanity:
		previousSanity = PlayerVariables.sanity;
		print("Sanity: " + str(PlayerVariables.sanity));
		Wwise.set_rtpc_value_id(AK.GAME_PARAMETERS.SANITY, PlayerVariables.sanity, $Music);
		if PlayerVariables.sanity <= 20:
			gambitSprite.visible = false;
			
		if PlayerVariables.sanity <= 55:
			pictureFrame.texture = load("res://images/Apartment scene assets/familyphoto-darkest.png")
		elif PlayerVariables.sanity < 80:
			pictureFrame.texture = load("res://images/Apartment scene assets/familyphoto-darker.png")
		elif PlayerVariables.sanity < 100:
			pictureFrame.texture = load("res://images/Apartment scene assets/familyphoto-dark.png")

func displayCoffeeScene():
	player.canMove = false;
	coffeeSceneControl.visible = true;
	soundBankCoffeeShop.post_event()
	pass;

func goToTrain():
	timeWipe.visible = true;
	#soundBankDarkMusic.stop_event()
	soundBankTVStatic.stop_event()
	soundBankHomeEnv.stop_event()
	if(coffeeSceneControl.visible):
		soundBankCoffeeShop.stop_event()
	get_tree().change_scene_to_file("res://assets/subway.tscn")
	pass;

func displayPlayerCall():
	player.displayCall();
	pass;

func playCatMeow():
	soundBankCatMeow.post_event()
	pass;

func goToHouseAM():
	timeWipe.visible = true;
	wakeupTimer.start();
	player.global_transform.origin = morningSpawn.global_transform.origin
	player.canMove = true;
	soundBankAlarmClock.post_event()
	light1.light_energy = 1.0
	light2.light_energy = 1.0
	DialogueManager.show_dialogue_balloon(load("res://narrative/day_"+str(PlayerVariables.day+1)+".dialogue"), "day_"+str(PlayerVariables.day+1)+"_house_am")
	pass;

func goToBedFunction():
	player.global_transform.origin = bedSpawn.global_transform.origin
	player.canMove = false;
	light1.light_energy = 0.0
	light2.light_energy = 0.1

func turnOffAlarmFunction():
	soundBankAlarmClock.stop_event()
	pass;

func showMouse():
	player.selectingOption = true;
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);

func hideMouse():
	player.selectingOption = false;
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);

func _on_wakeup_timer_timeout():
	timeWipe.visible = false;
	pass # Replace with function body.

func jumpScareSoundFunction():
	soundBankJumpScare.post_event()
	pass;

func endGameFunction():
	get_tree().quit()
	pass; 
