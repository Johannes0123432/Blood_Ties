extends Node

signal family_trust_changed(value: int)
signal reputation_changed(value: int)

var current_scene: String = "main_menu"
var chapter: String = "teaser"

var family_trust: int = 50          
var street_rep: int = 40            
var cash: int = 12000
var has_vito_notebook: bool = false
var frankie_betrayed: bool = false
var rizzo_aware: bool = true

var inventory: Dictionary = {
	"glock": true,
	"vito_wallet": false,
	"vito_notebook": false,
	"cash_briefcase": false,
	"burner_phone": false
}

var choices: Dictionary = {}

func _ready() -> void:
	print("Blood Ties – GameState loaded. Family first.")

func set_choice(key: String, value) -> void:
	choices[key] = value

func get_choice(key: String, default = null):
	return choices.get(key, default)

func add_cash(amount: int) -> void:
	cash += amount

func change_family_trust(delta: int) -> void:
	family_trust = clamp(family_trust + delta, 0, 100)
	family_trust_changed.emit(family_trust)

func change_street_rep(delta: int) -> void:
	street_rep = clamp(street_rep + delta, 0, 100)
	reputation_changed.emit(street_rep)

func save_game() -> void:
	var save_data = {
		"chapter": chapter,
		"family_trust": family_trust,
		"street_rep": street_rep,
		"cash": cash,
		"inventory": inventory,
		"choices": choices,
		"frankie_betrayed": frankie_betrayed
	}
	var file = FileAccess.open("user://bloodties_save.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()

func load_game() -> bool:
	if not FileAccess.file_exists("user://bloodties_save.json"):
		return false
	var file = FileAccess.open("user://bloodties_save.json", FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())
		file.close()
		if data:
			chapter = data.get("chapter", "teaser")
			family_trust = data.get("family_trust", 50)
			street_rep = data.get("street_rep", 40)
			cash = data.get("cash", 12000)
			inventory = data.get("inventory", inventory)
			choices = data.get("choices", {})
			frankie_betrayed = data.get("frankie_betrayed", false)
			return true
	return false

func reset() -> void:
	family_trust = 50
	street_rep = 40
	cash = 12000
	inventory = {"glock": true, "vito_wallet": false, "vito_notebook": false, "cash_briefcase": false, "burner_phone": false}
	choices.clear()
	frankie_betrayed = false
	chapter = "teaser"
