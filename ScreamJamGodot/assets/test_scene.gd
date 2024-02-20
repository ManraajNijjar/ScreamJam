extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	DialogueManager.show_example_dialogue_balloon(load("res://narrative/start.dialogue"), "day_1_house_am")
	DialogueManager.connect("dialogue_ended", dialogueEndedFunction)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func dialogueEndedFunction(something):
	print("dialogue ended");
	print(something);
	print(PlayerVariables.sanity);