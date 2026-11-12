extends Node

signal dialogue_finished
signal choice_made(choice_id: String)

var current_dialogue: Array = []
var current_index: int = 0
var is_active: bool = false

func load_dialogue(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var json = JSON.parse_string(file.get_as_text())
		file.close()
		if json and json.has("lines"):
			current_dialogue = json["lines"]
			current_index = 0
			is_active = true
		else:
			push_error("Invalid dialogue format: " + path)
	else:
		push_error("Could not open dialogue: " + path)

func get_current_line() -> Dictionary:
	if current_index < current_dialogue.size():
		return current_dialogue[current_index]
	return {}

func advance() -> Dictionary:
	if not is_active:
		return {}
	current_index += 1
	if current_index >= current_dialogue.size():
		is_active = false
		dialogue_finished.emit()
		return {}
	return get_current_line()

func has_choices() -> bool:
	var line = get_current_line()
	return line.has("choices") and line["choices"].size() > 0

func make_choice(choice_id: String) -> void:
	choice_made.emit(choice_id)
	var line = get_current_line()
	if line.has("choices"):
		for c in line["choices"]:
			if c.get("id") == choice_id:
				if c.has("effects"):
					_apply_effects(c["effects"])
				break
	advance()

func _apply_effects(effects: Dictionary) -> void:
	if effects.has("family_trust"):
		GameState.change_family_trust(effects["family_trust"])
	if effects.has("street_rep"):
		GameState.change_street_rep(effects["street_rep"])
	if effects.has("cash"):
		GameState.add_cash(effects["cash"])
	if effects.has("set_flag"):
		var flag = effects["set_flag"]
		if flag == "frankie_betrayed":
			GameState.frankie_betrayed = true
		if flag == "has_vito_notebook":
			GameState.inventory["vito_notebook"] = true
			GameState.has_vito_notebook = true
