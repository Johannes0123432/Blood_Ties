extends Control

@onready var speaker_label: Label = $Panel/VBox/SpeakerLabel
@onready var text_label: RichTextLabel = $Panel/VBox/TextLabel
@onready var choices_container: VBoxContainer = $Panel/VBox/ChoicesContainer
@onready var continue_button: Button = $Panel/VBox/ContinueButton
@onready var background: ColorRect = $Background

var current_line: Dictionary = {}

func _ready() -> void:
	continue_button.pressed.connect(_on_continue)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
	DialogueManager.choice_made.connect(_on_choice_made)
	
	# Load teaser for now
	DialogueManager.load_dialogue("res://dialogue/teaser.json")
	_show_line()

func _show_line() -> void:
	current_line = DialogueManager.get_current_line()
	if current_line.is_empty():
		return
	
	speaker_label.text = current_line.get("speaker", "")
	text_label.text = current_line.get("text", "")
	
	# Clear previous choices
	for child in choices_container.get_children():
		child.queue_free()
	
	if DialogueManager.has_choices():
		continue_button.hide()
		var choices = current_line.get("choices", [])
		for choice in choices:
			var btn = Button.new()
			btn.text = choice.get("text", "...")
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.pressed.connect(_on_choice_pressed.bind(choice.get("id", "")))
			choices_container.add_child(btn)
	else:
		continue_button.show()
		continue_button.text = "Continue" if DialogueManager.current_index < DialogueManager.current_dialogue.size() - 1 else "End Teaser"

func _on_continue() -> void:
	DialogueManager.advance()
	if DialogueManager.is_active:
		_show_line()
	else:
		_on_dialogue_finished()

func _on_choice_pressed(choice_id: String) -> void:
	DialogueManager.make_choice(choice_id)
	GameState.set_choice("teaser_" + choice_id, true)
	_show_line()

func _on_choice_made(choice_id: String) -> void:
	print("Player chose: ", choice_id)

func _on_dialogue_finished() -> void:
	# After teaser, go to family home or next chapter
	GameState.chapter = "act1"
	GameState.save_game()
	# For now just show a message and return to menu
	speaker_label.text = "END OF TEASER"
	text_label.text = "South Philly will bleed.\n\nThe war has begun.\n\n(Continue development: family home scene, office confrontation, docks...)"
	continue_button.text = "Return to Menu"
	continue_button.show()
	continue_button.pressed.disconnect(_on_continue)
	continue_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
