extends Node

enum TIMEOFDAY {MORNING, NIGHT}

var sanity = 100;
var weirdness = 0;
var missed_calls = 0;
var currentCall = 0;
var day = 0;
var time : TIMEOFDAY = TIMEOFDAY.NIGHT;

signal toTrain
signal displayMomCall

func _ready():
	toTrain.connect(loadTrain);
	displayMomCall.connect(toggleMomCall);

func loadTrain(sceneChangeParameter: String):
	print(sceneChangeParameter);

func toggleMomCall(dayCall):
	pass
	