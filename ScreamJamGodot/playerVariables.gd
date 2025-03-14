extends Node

enum TIMEOFDAY {MORNING, NIGHT}

var sanity = 100;
var weirdness = 0;
var missed_calls = 0;
var currentCall = 0;
var day = 0;
var time : TIMEOFDAY = TIMEOFDAY.MORNING;
var gameStarted : bool = false;

signal toTrain
signal displayMomCall

func _ready():
	toTrain.connect(loadTrain);
	displayMomCall.connect(toggleMomCall);

func loadTrain(sceneChangeParameter: String):
	print(sceneChangeParameter);

func toggleMomCall(dayCall):
	pass
	
func reset():
	sanity = 100;
	weirdness = 0;
	missed_calls = 0;
	currentCall = 0;
	day = 0;
	time = TIMEOFDAY.MORNING;
	gameStarted = false;