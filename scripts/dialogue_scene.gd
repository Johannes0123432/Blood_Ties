extends Control

@onready var background: TextureRect = $Background
@onready var portrait_frame: PanelContainer = $Panel/HBox/PortraitFrame
@onready var portrait_rect: TextureRect = $Panel/HBox/PortraitFrame/PortraitRect
@onready var speaker_label: Label = $Panel/HBox/VBox/SpeakerLabel
@onready var text_label: RichTextLabel = $Panel/HBox/VBox/TextLabel
@onready var choices_container: VBoxContainer = $Panel/HBox/VBox/ChoicesContainer
@onready var continue_button: Button = $Panel/HBox/VBox/ContinueButton

var current_line: Dictionary = {}

const PORTRAITS: Dictionary = {
	"JACKIE": "res://assets/images/portraits/jackie.png",
	"FRANKIE": "res://assets/images/portraits/frankie.png",
	"VITO": "res://assets/images/portraits/vito.png",
	"LUCA": "res://assets/images/portraits/luca.png",
	"GINA": "res://assets/images/portraits/gina.png",
	"SARAH": "res://assets/images/portraits/sarah.png",
	"BIG SAL": "res://assets/images/portraits/big_sal.png",
	"NICK": "res://assets/images/portraits/nick.png"
}

const BACKGROUNDS: Dictionary = {
	"teaser": "res://assets/images/backgrounds/docks.png",
	"docks": "res://assets/images/backgrounds/docks.png",
	"family_home": "res://assets/images/backgrounds/kitchen.png",
	"kitchen": "res://assets/images/backgrounds/kitchen.png",
	"construction_office": "res://assets/images/backgrounds/office.png",
	"office": "res://assets/images/backgrounds/office.png",
	"fbi_office": "res://assets/images/backgrounds/interrogation.png",
	"interrogation": "res://assets/images/backgrounds/interrogation.png",
	"basement": "res://assets/images/backgrounds/rizzo_warehouse.png",
	"family_crisis": "res://assets/images/backgrounds/kitchen.png",
	"rooftop": "res://assets/images/backgrounds/rooftop.png",
	"home_invasion": "res://assets/images/backgrounds/kitchen.png",
	"rizzo_warehouse": "res://assets/images/backgrounds/rizzo_warehouse.png",
	"church": "res://assets/images/backgrounds/church.png",
	"streets": "res://assets/images/backgrounds/streets.png",
	"cadillac": "res://assets/images/backgrounds/cadillac.png"
}

func _ready() -> void:
	continue_button.pressed.connect(_on_continue)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished)
	DialogueManager.choice_made.connect(_on_choice_made)
	
	var chapter_path := "res://dialogue/%s.json" % GameState.chapter
	if not FileAccess.file_exists(chapter_path):
		chapter_path = "res://dialogue/teaser.json"
		
	_set_background(GameState.chapter)
	DialogueManager.load_dialogue(chapter_path)
	_show_line()

func _show_line() -> void:
	current_line = DialogueManager.get_current_line()
	if current_line.is_empty():
		return
		
	var speaker: String = current_line.get("speaker", "")
	speaker_label.text = speaker
	text_label.text = current_line.get("text", "")
	
	if current_line.has("bg"):
		_set_background(current_line["bg"])
		
	_set_portrait(speaker)
	
	for child in choices_container.get_children():
		child.queue_free()
		
	if DialogueManager.has_choices():
		continue_button.hide()
		var choices = current_line.get("choices", [])
		for choice in choices:
			var btn := Button.new()
			btn.text = choice.get("text", "...")
			btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			btn.pressed.connect(_on_choice_pressed.bind(choice.get("id", "")))
			choices_container.add_child(btn)
	else:
		continue_button.show()
		var is_last := DialogueManager.current_index >= DialogueManager.current_dialogue.size() - 1
		continue_button.text = "Continue" if not is_last else "Next Chapter"

func _set_background(bg_key: String) -> void:
	var key := bg_key.to_lower()
	if BACKGROUNDS.has(key) and ResourceLoader.exists(BACKGROUNDS[key]):
		background.texture = load(BACKGROUNDS[key])

func _set_portrait(speaker_name: String) -> void:
	var key := speaker_name.to_upper()
	if PORTRAITS.has(key) and ResourceLoader.exists(PORTRAITS[key]):
		portrait_rect.texture = load(PORTRAITS[key])
		portrait_frame.show()
	else:
		portrait_frame.hide()

func _on_continue() -> void:
	DialogueManager.advance()
	if DialogueManager.is_active:
		_show_line()
	else:
		_on_dialogue_finished()

func _on_choice_pressed(choice_id: String) -> void:
	DialogueManager.make_choice(choice_id)
	GameState.set_choice(GameState.chapter + "_" + choice_id, true)
	_show_line()

func _on_choice_made(choice_id: String) -> void:
	pass

func _on_dialogue_finished() -> void:
	var chapter_order := [
		"teaser", "family_home", "construction_office", "fbi_office",
		"docks", "basement", "family_crisis", "rooftop",
		"interrogation", "home_invasion", "rizzo_warehouse"
	]
	var idx := chapter_order.find(GameState.chapter)
	if idx != -1 and idx + 1 < chapter_order.size():
		GameState.chapter = chapter_order[idx + 1]
		GameState.save_game()
		get_tree().reload_current_scene()
	else:
		GameState.save_game()
		portrait_frame.hide()
		speaker_label.text = "END OF PILOT"
		text_label.text = "South Philly bleeds. Your choices have sealed the fate of the Moretti family."
		continue_button.text = "Return to Menu"
		continue_button.show()
		continue_button.pressed.disconnect(_on_continue)
		continue_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
