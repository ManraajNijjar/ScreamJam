extends Control

@onready var button1 = $VBoxContainer/GridContainer/Button

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_button_pressed():
	print("Button 1 was pressed")
	pass # Replace with function body.

func _on_button_focus_entered():
	print("Button 1 has focus")
	pass # Replace with function body.
