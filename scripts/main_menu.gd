extends Control

@onready var start_button: Button = $VBoxContainer/StartButton
@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var quit_button: Button = $VBoxContainer/QuitButton
@onready var title_label: Label = $TitleLabel

func _ready() -> void:
	start_button.pressed.connect(_on_start)
	continue_button.pressed.connect(_on_continue)
	quit_button.pressed.connect(_on_quit)
	
	# Check for save
	if FileAccess.file_exists("user://bloodties_save.json"):
		continue_button.disabled = false
	else:
		continue_button.disabled = true

func _on_start() -> void:
	GameState.reset()
	GameState.chapter = "teaser"
	get_tree().change_scene_to_file("res://scenes/dialogue_scene.tscn")

func _on_continue() -> void:
	if GameState.load_game():
		get_tree().change_scene_to_file("res://scenes/dialogue_scene.tscn")
	else:
		_on_start()

func _on_quit() -> void:
	get_tree().quit()
