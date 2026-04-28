# AutoLoad — charge l'effectif du manager une seule fois au login
# À ajouter dans : Projet → Généraux → Chargement automatique
# Nom : SquadLoader
extends Node

signal squad_loaded

func load_squad():
	if GameState.cards_loaded:
		emit_signal("squad_loaded")
		return
	Firebase.firestore_success.connect(_on_cards_loaded)
	Firebase.firestore_failed.connect(_on_cards_failed)
	Firebase.get_collection("managers/" + Firebase.user_id + "/cards")

func _on_cards_loaded(data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_cards_loaded):
		Firebase.firestore_success.disconnect(_on_cards_loaded)
	if Firebase.firestore_failed.is_connected(_on_cards_failed):
		Firebase.firestore_failed.disconnect(_on_cards_failed)
	GameState.cards_yellow  = []
	GameState.cards_orange  = []
	GameState.cards_red     = []
	GameState.cards_magenta = []
	GameState.cards_blue    = []
	GameState.cards_white   = []
	GameState.cards_special = []
	var documents = data.get("documents", [])
	for card in documents:
		match card.get("color", ""):
			"yellow":  GameState.cards_yellow.append(card)
			"orange":  GameState.cards_orange.append(card)
			"red":     GameState.cards_red.append(card)
			"magenta": GameState.cards_magenta.append(card)
			"blue":    GameState.cards_blue.append(card)
			"white":   GameState.cards_white.append(card)
			"special": GameState.cards_special.append(card)
	GameState.cards_loaded = true
	emit_signal("squad_loaded")

func _on_cards_failed(_error: String):
	if Firebase.firestore_success.is_connected(_on_cards_loaded):
		Firebase.firestore_success.disconnect(_on_cards_loaded)
	if Firebase.firestore_failed.is_connected(_on_cards_failed):
		Firebase.firestore_failed.disconnect(_on_cards_failed)
	GameState.cards_loaded = true
	emit_signal("squad_loaded")

func get_all_cards() -> Array:
	var all = []
	all.append_array(GameState.cards_yellow)
	all.append_array(GameState.cards_orange)
	all.append_array(GameState.cards_red)
	all.append_array(GameState.cards_magenta)
	all.append_array(GameState.cards_blue)
	all.append_array(GameState.cards_white)
	all.append_array(GameState.cards_special)
	return all

func get_cards_by_color(color: String) -> Array:
	match color:
		"yellow":  return GameState.cards_yellow
		"orange":  return GameState.cards_orange
		"red":     return GameState.cards_red
		"magenta": return GameState.cards_magenta
		"blue":    return GameState.cards_blue
		"white":   return GameState.cards_white
		"special": return GameState.cards_special
	return []

func add_card(card_dict: Dictionary):
	match card_dict.get("color", ""):
		"yellow":  GameState.cards_yellow.append(card_dict)
		"orange":  GameState.cards_orange.append(card_dict)
		"red":     GameState.cards_red.append(card_dict)
		"magenta": GameState.cards_magenta.append(card_dict)
		"blue":    GameState.cards_blue.append(card_dict)
		"white":   GameState.cards_white.append(card_dict)
		"special": GameState.cards_special.append(card_dict)

func remove_card(card_id: String):
	for arr in [GameState.cards_yellow, GameState.cards_orange, GameState.cards_red,
				GameState.cards_magenta, GameState.cards_blue, GameState.cards_white,
				GameState.cards_special]:
		for i in range(arr.size()):
			if arr[i].get("card_id", "") == card_id:
				arr.remove_at(i)
				Firebase.delete_document(
					"managers/" + Firebase.user_id + "/cards", card_id)
				return

func update_card(card_dict: Dictionary):
	var card_id = card_dict.get("card_id", "")
	for arr in [GameState.cards_yellow, GameState.cards_orange, GameState.cards_red,
				GameState.cards_magenta, GameState.cards_blue, GameState.cards_white,
				GameState.cards_special]:
		for i in range(arr.size()):
			if arr[i].get("card_id", "") == card_id:
				arr[i] = card_dict
				Firebase.update_document(
					"managers/" + Firebase.user_id + "/cards",
					card_id, card_dict)
				return
