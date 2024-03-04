extends CanvasLayer

## The action to use for advancing the dialogue
const NEXT_ACTION = &"ui_accept"

## The action to use to skip typing the dialogue
const SKIP_ACTION = &"ui_cancel"


@onready var balloon: Control = %Balloon
@onready var character_label: RichTextLabel = %CharacterLabel
@onready var portrait: TextureRect = %Portrait
@onready var mom_portrait: TextureRect = %MomPortrait

@onready var dialogue_label: DialogueLabel = %DialogueLabel
@onready var responses_menu: DialogueResponsesMenu = %ResponsesMenu

## The dialogue resource
var resource: DialogueResource

## Temporary game states
var temporary_game_states: Array = []

## See if we are waiting for the player
var is_waiting_for_input: bool = false

## See if we are running a long mutation and should hide the balloon
var will_hide_balloon: bool = false

## The current line
var dialogue_line: DialogueLine:
	set(next_dialogue_line):
		is_waiting_for_input = false
		balloon.focus_mode = Control.FOCUS_ALL
		balloon.grab_focus()

		# The dialogue has finished so close the balloon
		if not next_dialogue_line:
			queue_free()
			return

		# If the node isn't ready yet then none of the labels will be ready yet either
		if not is_node_ready():
			await ready

		dialogue_line = next_dialogue_line

		character_label.visible = not dialogue_line.character.is_empty()
		character_label.text = tr(dialogue_line.character, "dialogue")
		var portrait_path: String = "res://images/Character portraits/%s.png" % dialogue_line.character.to_lower()
		
		
		if dialogue_line.character == "Scott":
			if PlayerVariables.sanity >= 80:
				portrait.texture = load("res://images/Character portraits/ScottAvatar-neutral.png")
			elif PlayerVariables.sanity >= 55:
				portrait.texture = load("res://images/Character portraits/ScottAvatar-dark.PNG")
			elif PlayerVariables.sanity >= 30:
				portrait.texture = load("res://images/Character portraits/ScottAvatar-darker.png")
			else:
				portrait.texture = load("res://images/Character portraits/ScottAvatar-darkest.PNG")
		else:
			portrait.texture = null
			# ^ comment out this line/switch to "pass" if we want him to always be visible
		if dialogue_line.character == "Barista":
		#if FileAccess.file_exists(portrait_path):
			mom_portrait.texture = load("res://images/Character portraits/barista.png")
		elif dialogue_line.character == "Alexis":
			mom_portrait.texture = load("res://images/Character portraits/alexis.png")
		elif dialogue_line.character == "Dylan":
			mom_portrait.texture = load("res://images/Character portraits/dylan.png")
		elif dialogue_line.character == "Sandra":
			mom_portrait.texture = load("res://images/Character portraits/sandra.png")
		else:
			mom_portrait.texture = null
		#if dialogue_line.character == "Mom":
			#if PlayerVariables.sanity == 100:
				#mom_portrait.texture = load("res://images/Apartment scene assets/familyphoto.png")
			#elif PlayerVariables.sanity >= 80:
				#mom_portrait.texture  = load("res://images/Apartment scene assets/familyphoto-dark.png")
			#elif PlayerVariables.sanity >= 55:
				#mom_portrait.texture = load("res://images/Apartment scene assets/familyphoto-darker.png")
			#else:
				#mom_portrait.texture = load("res://images/Apartment scene assets/familyphoto-darkest.png")
		#else:
			#mom_portrait.texture = null


		dialogue_label.hide()
		dialogue_label.dialogue_line = dialogue_line

		responses_menu.hide()
		responses_menu.set_responses(dialogue_line.responses)

		# Show our balloon
		balloon.show()
		will_hide_balloon = false

		dialogue_label.show()
		if not dialogue_line.text.is_empty():
			dialogue_label.type_out()
			await dialogue_label.finished_typing

		# Wait for input
		if dialogue_line.responses.size() > 0:
			balloon.focus_mode = Control.FOCUS_NONE
			responses_menu.show()
		elif dialogue_line.time != "":
			var time = dialogue_line.text.length() * 0.02 if dialogue_line.time == "auto" else dialogue_line.time.to_float()
			await get_tree().create_timer(time).timeout
			next(dialogue_line.next_id)
		else:
			is_waiting_for_input = true
			balloon.focus_mode = Control.FOCUS_ALL
			balloon.grab_focus()
	get:
		return dialogue_line


func _ready() -> void:
	balloon.hide()
	Engine.get_singleton("DialogueManager").mutated.connect(_on_mutated)


func _unhandled_input(_event: InputEvent) -> void:
	# Only the balloon is allowed to handle input while it's showing
	get_viewport().set_input_as_handled()


## Start some dialogue
func start(dialogue_resource: DialogueResource, title: String, extra_game_states: Array = []) -> void:
	temporary_game_states =  [self] + extra_game_states
	is_waiting_for_input = false
	resource = dialogue_resource
	self.dialogue_line = await resource.get_next_dialogue_line(title, temporary_game_states)


## Go to the next line
func next(next_id: String) -> void:
	self.dialogue_line = await resource.get_next_dialogue_line(next_id, temporary_game_states)


### Signals


func _on_mutated(_mutation: Dictionary) -> void:
	is_waiting_for_input = false
	will_hide_balloon = true
	get_tree().create_timer(0.1).timeout.connect(func():
		if will_hide_balloon:
			will_hide_balloon = false
			balloon.hide()
	)


func _on_balloon_gui_input(event: InputEvent) -> void:
	# See if we need to skip typing of the dialogue
	if dialogue_label.is_typing:
		var mouse_was_clicked: bool = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed()
		var skip_button_was_pressed: bool = event.is_action_pressed(SKIP_ACTION)
		if mouse_was_clicked or skip_button_was_pressed:
			get_viewport().set_input_as_handled()
			dialogue_label.skip_typing()
			return

	if not is_waiting_for_input: return
	if dialogue_line.responses.size() > 0: return

	# When there are no response options the balloon itself is the clickable thing
	get_viewport().set_input_as_handled()

	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
		next(dialogue_line.next_id)
	elif event.is_action_pressed(NEXT_ACTION) and get_viewport().gui_get_focus_owner() == balloon:
		next(dialogue_line.next_id)


func _on_responses_menu_response_selected(response: DialogueResponse) -> void:
	next(response.next_id)
