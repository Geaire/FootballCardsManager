extends Node2D

const SCENE_TEAM = "res://Scenes/team.tscn"
const FLAG_PATH = "res://Sprites/Flags/flag_%s.png"
const MAX_CONDITIONS = 17
const LONG_PRESS_DURATION = 0.5

const COUNTRY_NAMES = {
	"AE":"United Arab Emirates","AO":"Angola","AR":"Argentina","AT":"Austria",
	"AU":"Australia","BA":"Bosnia","BE":"Belgium","BG":"Bulgaria","BO":"Bolivia",
	"BR":"Brazil","CA":"Canada","CD":"Congo DR","CH":"Switzerland",
	"CI":"Ivory Coast","CL":"Chile","CM":"Cameroon","CN":"China","CO":"Colombia",
	"CR":"Costa Rica","CU":"Cuba","CZ":"Czech Republic","DE":"Germany",
	"DK":"Denmark","DZ":"Algeria","EC":"Ecuador","EG":"Egypt","ES":"Spain",
	"FR":"France","GB":"England","GH":"Ghana","GR":"Greece","HN":"Honduras",
	"HR":"Croatia","HT":"Haiti","HU":"Hungary","ID":"Indonesia","IE":"Ireland",
	"IL":"Israel","IQ":"Iraq","IR":"Iran","IT":"Italy","JM":"Jamaica",
	"JP":"Japan","KP":"North Korea","KR":"South Korea","KW":"Kuwait",
	"MA":"Morocco","MX":"Mexico","NG":"Nigeria","NI":"Nicaragua",
	"NL":"Netherlands","NO":"Norway","NZ":"New Zealand","PA":"Panama",
	"PE":"Peru","PL":"Poland","PT":"Portugal","PY":"Paraguay","QA":"Qatar",
	"RO":"Romania","RS":"Serbia","RU":"Russia","SA":"Saudi Arabia",
	"SC":"Seychelles","SE":"Sweden","SI":"Slovenia","SK":"Slovakia",
	"SN":"Senegal","SV":"El Salvador","TG":"Togo","TN":"Tunisia","TR":"Turkey",
	"TT":"Trinidad","UA":"Ukraine","US":"USA","UY":"Uruguay","WA":"Wales",
	"ZA":"South Africa"
}

const CONDITIONS_REWARDS = [
	"16 cards",
	"14 different positions",
	"24 positions total",
	"8 different specialties",
	"20 specialties total",
	"2 cards of each color",
	"16 yellow cards",
	"16 yellow cards",
	"14 orange cards",
	"12 red cards",
	"10 white cards",
	"8 magenta cards",
	"3 blue cards",
	"16 players aged 33",
	"14 players Weight 95",
	"14 players Height 190",
	"All conditions completed",
]

const CONDITIONS_REWARDS_RIGHT = [
	"1 red card",
	"2 positions",
	"3 positions",
	"2 specialties",
	"3 specialties",
	"1 magenta card",
	"1 yellow card",
	"1 yellow card",
	"1 orange card",
	"1 red card",
	"1 white card",
	"1 magenta card",
	"1 blue card",
	"3 yellow cards",
	"3 orange cards",
	"1 magenta card",
	"1 special card ★",
]

const CONDITIONS_COLORS = [
	"#e83b3b",
	"#32c864",
	"#32c864",
	"#ffffff",
	"#ffffff",
	"#e83b8f",
	"#f5c842",
	"#f5c842",
	"#ff6b35",
	"#e83b3b",
	"#ffffff",
	"#e83b8f",
	"#3b8fe8",
	"#f5c842",
	"#ff6b35",
	"#e83b8f",
	"#ff69b4",
]

const TRANSLATIONS = {
	"fr": {
		"popup": "- Ajoutez / Supprimer des cartes pour compléter la collection.\n- Seuls les joueurs de 30 ans minimum sont éligibles.\n- Un joueur déposé dans une collection sera supprimé de votre effectif.\n- Ajoutez une carte dans le détail complet des joueurs.\n- Appui long pour supprimer une carte.",
		"confirm": "Attention ! Si vous confirmez le retrait du joueur, il sera définitivement supprimé du jeu.",
	},
	"en": {
		"popup": "- Add / Remove cards to complete the collection.\n- Only players aged 30 or older are eligible.\n- A player placed in a collection will be permanently removed from your squad.\n- Add a card from the player's full detail view.\n- Long press to remove a card.",
		"confirm": "Warning! If you confirm the player's removal, they will be permanently deleted from the game.",
	},
	"es": {
		"popup": "- Añade / Elimina cartas para completar la colección.\n- Solo son elegibles los jugadores de 30 años o más.\n- Un jugador colocado en una colección será eliminado definitivamente de tu plantilla.\n- Añade una carta desde el detalle completo del jugador.\n- Mantén pulsado para eliminar una carta.",
		"confirm": "¡Atención! Si confirmas la retirada del jugador, será eliminado definitivamente del juego.",
	},
	"de": {
		"popup": "- Füge Karten hinzu / entferne sie, um die Sammlung zu vervollständigen.\n- Nur Spieler ab 30 Jahren sind berechtigt.\n- Ein in eine Sammlung gelegter Spieler wird dauerhaft aus deinem Kader entfernt.\n- Füge eine Karte in der vollständigen Spielerdetailansicht hinzu.\n- Lang drücken, um eine Karte zu entfernen.",
		"confirm": "Achtung! Wenn du die Entfernung des Spielers bestätigst, wird er dauerhaft aus dem Spiel gelöscht.",
	},
	"it": {
		"popup": "- Aggiungi / Rimuovi carte per completare la collezione.\n- Solo i giocatori di 30 anni o più sono idonei.\n- Un giocatore inserito in una collezione verrà rimosso definitivamente dalla tua rosa.\n- Aggiungi una carta dal dettaglio completo del giocatore.\n- Tieni premuto per rimuovere una carta.",
		"confirm": "Attenzione! Se confermi la rimozione del giocatore, verrà eliminato definitivamente dal gioco.",
	},
	"pt": {
		"popup": "- Adicione / Remova cartas para completar a coleção.\n- Apenas jogadores com 30 anos ou mais são elegíveis.\n- Um jogador colocado numa coleção será removido definitivamente do seu plantel.\n- Adicione uma carta no detalhe completo dos jogadores.\n- Pressão longa para remover uma carta.",
		"confirm": "Atenção! Se confirmar a retirada do jogador, ele será eliminado definitivamente do jogo.",
	},
}

var slot_card_ids: Array = ["","","","","","","","","","","","","","","",""]
var press_slot: int = -1
var press_timer: float = 0.0
var press_holding: bool = false
var touch_start: Vector2 = Vector2.ZERO
var collection_data: Dictionary = {}
var conditions_completed: Array = []

@onready var img_flag = $IMG_Flag
@onready var lbl_country_name = $LBL_CountryName
@onready var btn_help = $BTN_HelpCollection
@onready var lbl_popup = $LBL_PopupCollection
@onready var popup_confirm = $Popup_Confirm
@onready var lbl_confirm = $Popup_Confirm/LBL_Confirm
@onready var btn_yes = $Popup_Confirm/BTN_Yes
@onready var btn_no = $Popup_Confirm/BTN_No
@onready var pnl_conditions = $PNL_ConditionsRewards
@onready var lbl_title_conditions = $PNL_ConditionsRewards/CNT_ConditionsRewards/LBL_TitleConditionsRewards

var slot_nodes: Array = []
var condition_nodes: Array = []

func _ready():
	Taskbar.visible = true
	Taskbar._update_border_color()
	lbl_popup.visible = false
	popup_confirm.visible = false

	var row_names = ["CNT_Row1","CNT_Row2","CNT_Row3","CNT_Row4"]
	for row_name in row_names:
		var row = $CNT_GridSlots.get_node(row_name)
		for i in range(1, 5):
			slot_nodes.append(row.get_node("BG_Slot%d" % (slot_nodes.size() + 1)))

	var cnt = $PNL_ConditionsRewards/CNT_ConditionsRewards
	for i in range(1, MAX_CONDITIONS + 1):
		condition_nodes.append(cnt.get_node("LBL_ConditionReward%d" % i))

	conditions_completed.resize(MAX_CONDITIONS)
	conditions_completed.fill(false)

	_style_panel()
	_apply_translations()
	_setup_flag()
	_setup_conditions()
	_load_collection()

func _style_panel():
	var style_panel = StyleBoxFlat.new()
	style_panel.bg_color = Color(0.03, 0.07, 0.03, 0.96)
	style_panel.border_color = Color(0.2, 1.0, 0.3, 0.4)
	style_panel.set_border_width_all(1)
	style_panel.set_corner_radius_all(12)
	pnl_conditions.add_theme_stylebox_override("panel", style_panel)

func _setup_flag():
	var code = GameState.selected_country
	var fp = FLAG_PATH % code.to_lower()
	var tex = load(fp) if ResourceLoader.exists(fp) else null
	if tex: img_flag.texture = tex
	# Nom du pays centré sous le drapeau
	lbl_country_name.text = COUNTRY_NAMES.get(code, code)

func _apply_translations():
	var t = TRANSLATIONS.get(GameState.language, TRANSLATIONS["fr"])
	lbl_popup.text = t["popup"]
	lbl_confirm.text = t["confirm"]

func _setup_conditions():
	var done_count = conditions_completed.count(true)
	# Barre réduite à 16 blocs pour moins de place
	var bar_filled = int((float(done_count) / MAX_CONDITIONS) * 16)
	var bar_empty = 16 - bar_filled

	lbl_title_conditions.bbcode_enabled = true
	lbl_title_conditions.fit_content = true
	lbl_title_conditions.scroll_active = false
	lbl_title_conditions.text = (
		"[center]"
		+ "[b][font_size=30][color=#50ff80]Conditions[/color] [color=#ffffff]→[/color] [color=#50ff80]Rewards[/color][/font_size][/b]"
		+ "\n[font_size=18]"
		+ "[color=#32c864]" + "█".repeat(bar_filled) + "[/color]"
		+ "[color=#1a2a1a]" + "█".repeat(bar_empty) + "[/color]"
		+ "  [color=#50ff80]" + str(done_count) + "/" + str(MAX_CONDITIONS) + "[/color]"
		+ "[/font_size][/center]"
	)

	for i in range(condition_nodes.size()):
		if i >= CONDITIONS_REWARDS.size():
			condition_nodes[i].visible = false
			continue
		var lbl = condition_nodes[i]
		lbl.bbcode_enabled = true
		lbl.fit_content = true
		lbl.scroll_active = false
		var is_done = conditions_completed[i] if i < conditions_completed.size() else false
		var col = CONDITIONS_COLORS[i] if i < CONDITIONS_COLORS.size() else "#ffffff"
		if is_done:
			lbl.text = "[font_size=28][color=%s]✓  %s  →  %s[/color][/font_size]" % [col, CONDITIONS_REWARDS[i], CONDITIONS_REWARDS_RIGHT[i]]
		else:
			lbl.text = "[font_size=28][color=%s]●  %s[/color]  [color=#444444]→  %s[/color][/font_size]" % [col, CONDITIONS_REWARDS[i], CONDITIONS_REWARDS_RIGHT[i]]
		lbl.visible = true

func _inject_test_cards():
	if GameState.selected_country != "FR": return
	if slot_card_ids[0] == "": slot_card_ids[0] = "test_blue_001"
	if slot_card_ids[1] == "": slot_card_ids[1] = "test_white_001"
	if slot_card_ids[2] == "": slot_card_ids[2] = "test_yellow_001"
	_refresh_slots()

func _load_collection():
	Firebase.firestore_success.connect(_on_collection_loaded)
	Firebase.firestore_failed.connect(_on_collection_failed)
	var code = GameState.selected_country
	Firebase.get_document("managers/" + Firebase.user_id + "/collection", code)

func _on_collection_loaded(data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_collection_loaded):
		Firebase.firestore_success.disconnect(_on_collection_loaded)
	if Firebase.firestore_failed.is_connected(_on_collection_failed):
		Firebase.firestore_failed.disconnect(_on_collection_failed)
	collection_data = data
	for i in range(16):
		slot_card_ids[i] = data.get("slot_%d" % (i + 1), "")
	for i in range(MAX_CONDITIONS):
		conditions_completed[i] = bool(data.get("condition_%d" % (i + 1), false))
	_refresh_slots()
	_setup_conditions()
	_inject_test_cards()

func _on_collection_failed(_error: String):
	if Firebase.firestore_success.is_connected(_on_collection_loaded):
		Firebase.firestore_success.disconnect(_on_collection_loaded)
	if Firebase.firestore_failed.is_connected(_on_collection_failed):
		Firebase.firestore_failed.disconnect(_on_collection_failed)
	_refresh_slots()
	_inject_test_cards()

func _refresh_slots():
	for i in range(16):
		var bg = slot_nodes[i]
		if slot_card_ids[i] != "":
			_set_slot_color(bg, Color(0.2, 0.6, 1.0))
		else:
			_set_slot_color(bg, Color(0.04, 0.09, 0.05, 1.0))

func _set_slot_color(panel: PanelContainer, color: Color):
	var style = panel.get_theme_stylebox("panel").duplicate()
	style.bg_color = color
	panel.add_theme_stylebox_override("panel", style)

func _save_collection():
	var code = GameState.selected_country
	var data: Dictionary = {}
	for i in range(16):
		data["slot_%d" % (i + 1)] = slot_card_ids[i]
	for i in range(MAX_CONDITIONS):
		data["condition_%d" % (i + 1)] = conditions_completed[i]
	Firebase.update_document("managers/" + Firebase.user_id + "/collection", code, data)
	_update_global_counter()

func _update_global_counter():
	var code = GameState.selected_country
	var count = 0
	for id in slot_card_ids:
		if id != "": count += 1
	Firebase.update_document(
		"managers/" + Firebase.user_id + "/collection",
		"progress", {code: count}
	)

func _remove_card_from_slot(slot_index: int):
	var card_id = slot_card_ids[slot_index]
	if card_id == "": return
	Firebase.delete_document("managers/" + Firebase.user_id + "/cards", card_id)
	slot_card_ids[slot_index] = ""
	_save_collection()
	_refresh_slots()

func _process(delta):
	if press_holding and press_slot >= 0:
		press_timer += delta
		if press_timer >= LONG_PRESS_DURATION:
			press_holding = false
			press_timer = 0.0
			if slot_card_ids[press_slot] != "":
				popup_confirm.visible = true

func _input(event):
	if not (event is InputEventMouseButton): return
	if event.button_index != MOUSE_BUTTON_LEFT: return
	var pos = event.position
	if event.pressed:
		touch_start = pos
		_on_press(pos)
	else:
		_on_release(pos)

func _on_press(pos: Vector2):
	if popup_confirm.visible:
		if _sprite_hit(btn_yes, pos):
			_remove_card_from_slot(press_slot)
			popup_confirm.visible = false
			press_slot = -1
			return
		if _sprite_hit(btn_no, pos):
			popup_confirm.visible = false
			press_slot = -1
			return
		return
	if _sprite_hit(btn_help, pos):
		lbl_popup.visible = not lbl_popup.visible
		return
	if lbl_popup.visible:
		lbl_popup.visible = false
		return
	for i in range(16):
		if _panel_hit(slot_nodes[i], pos):
			if slot_card_ids[i] != "":
				press_slot = i
				press_holding = true
				press_timer = 0.0
			else:
				GameState.collection_slot_target = i
				GameState.collection_country = GameState.selected_country
				get_tree().change_scene_to_file(SCENE_TEAM)
			return

func _on_release(_pos: Vector2):
	press_holding = false
	press_timer = 0.0

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _panel_hit(panel: PanelContainer, pos: Vector2) -> bool:
	if panel == null or not panel.visible: return false
	return panel.get_global_rect().has_point(pos)
