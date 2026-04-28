extends Node2D

const SCENE_COLLECTION_FLAGS = "res://Scenes/collection_flags.tscn"
const SCENE_DCP              = "res://Scenes/detail_card_player.tscn"
const CARD_SCENE             = preload("res://Scenes/card_player.tscn")
const FLAG_PATH              = "res://Sprites/Flags/flag_%s.png"
const MAX_CONDITIONS         = 12
const LONG_PRESS_DURATION    = 0.5

const COUNTRY_NAMES = {
	"AE":{"fr":"Émirats Arabes","en":"UAE","es":"Emiratos Árabes","de":"Ver. Arab. Emirate","it":"Emirati Arabi","pt":"Emirados Árabes"},
	"AO":{"fr":"Angola","en":"Angola","es":"Angola","de":"Angola","it":"Angola","pt":"Angola"},
	"AR":{"fr":"Argentine","en":"Argentina","es":"Argentina","de":"Argentinien","it":"Argentina","pt":"Argentina"},
	"AT":{"fr":"Autriche","en":"Austria","es":"Austria","de":"Österreich","it":"Austria","pt":"Áustria"},
	"AU":{"fr":"Australie","en":"Australia","es":"Australia","de":"Australien","it":"Australia","pt":"Austrália"},
	"BA":{"fr":"Bosnie","en":"Bosnia","es":"Bosnia","de":"Bosnien","it":"Bosnia","pt":"Bósnia"},
	"BE":{"fr":"Belgique","en":"Belgium","es":"Bélgica","de":"Belgien","it":"Belgio","pt":"Bélgica"},
	"BG":{"fr":"Bulgarie","en":"Bulgaria","es":"Bulgaria","de":"Bulgarien","it":"Bulgaria","pt":"Bulgária"},
	"BO":{"fr":"Bolivie","en":"Bolivia","es":"Bolivia","de":"Bolivien","it":"Bolivia","pt":"Bolívia"},
	"BR":{"fr":"Brésil","en":"Brazil","es":"Brasil","de":"Brasilien","it":"Brasile","pt":"Brasil"},
	"CA":{"fr":"Canada","en":"Canada","es":"Canadá","de":"Kanada","it":"Canada","pt":"Canadá"},
	"CD":{"fr":"Rép. D. Congo","en":"DR Congo","es":"Rep. D. Congo","de":"Dem. Rep. Kongo","it":"Rep. D. Congo","pt":"Rep. D. Congo"},
	"CH":{"fr":"Suisse","en":"Switzerland","es":"Suiza","de":"Schweiz","it":"Svizzera","pt":"Suíça"},
	"CI":{"fr":"Côte d'Ivoire","en":"Ivory Coast","es":"Costa de Marfil","de":"Elfenbeinküste","it":"Costa d'Avorio","pt":"Costa do Marfim"},
	"CL":{"fr":"Chili","en":"Chile","es":"Chile","de":"Chile","it":"Cile","pt":"Chile"},
	"CM":{"fr":"Cameroun","en":"Cameroon","es":"Camerún","de":"Kamerun","it":"Camerun","pt":"Camarões"},
	"CN":{"fr":"Chine","en":"China","es":"China","de":"China","it":"Cina","pt":"China"},
	"CO":{"fr":"Colombie","en":"Colombia","es":"Colombia","de":"Kolumbien","it":"Colombia","pt":"Colômbia"},
	"CR":{"fr":"Costa Rica","en":"Costa Rica","es":"Costa Rica","de":"Costa Rica","it":"Costa Rica","pt":"Costa Rica"},
	"CU":{"fr":"Cuba","en":"Cuba","es":"Cuba","de":"Kuba","it":"Cuba","pt":"Cuba"},
	"CZ":{"fr":"Rép. Tchèque","en":"Czech Republic","es":"Rep. Checa","de":"Tschechien","it":"Rep. Ceca","pt":"Rep. Checa"},
	"DE":{"fr":"Allemagne","en":"Germany","es":"Alemania","de":"Deutschland","it":"Germania","pt":"Alemanha"},
	"DK":{"fr":"Danemark","en":"Denmark","es":"Dinamarca","de":"Dänemark","it":"Danimarca","pt":"Dinamarca"},
	"DZ":{"fr":"Algérie","en":"Algeria","es":"Argelia","de":"Algerien","it":"Algeria","pt":"Argélia"},
	"EC":{"fr":"Équateur","en":"Ecuador","es":"Ecuador","de":"Ecuador","it":"Ecuador","pt":"Equador"},
	"EG":{"fr":"Égypte","en":"Egypt","es":"Egipto","de":"Ägypten","it":"Egitto","pt":"Egito"},
	"ES":{"fr":"Espagne","en":"Spain","es":"España","de":"Spanien","it":"Spagna","pt":"Espanha"},
	"FR":{"fr":"France","en":"France","es":"Francia","de":"Frankreich","it":"Francia","pt":"França"},
	"GB":{"fr":"Grande-Bretagne","en":"Great Britain","es":"Gran Bretaña","de":"Großbritannien","it":"Gran Bretagna","pt":"Grã-Bretanha"},
	"GH":{"fr":"Ghana","en":"Ghana","es":"Ghana","de":"Ghana","it":"Ghana","pt":"Gana"},
	"GR":{"fr":"Grèce","en":"Greece","es":"Grecia","de":"Griechenland","it":"Grecia","pt":"Grécia"},
	"HN":{"fr":"Honduras","en":"Honduras","es":"Honduras","de":"Honduras","it":"Honduras","pt":"Honduras"},
	"HR":{"fr":"Croatie","en":"Croatia","es":"Croacia","de":"Kroatien","it":"Croazia","pt":"Croácia"},
	"HT":{"fr":"Haïti","en":"Haiti","es":"Haití","de":"Haiti","it":"Haiti","pt":"Haiti"},
	"HU":{"fr":"Hongrie","en":"Hungary","es":"Hungría","de":"Ungarn","it":"Ungheria","pt":"Hungria"},
	"ID":{"fr":"Indonésie","en":"Indonesia","es":"Indonesia","de":"Indonesien","it":"Indonesia","pt":"Indonésia"},
	"IE":{"fr":"Irlande","en":"Ireland","es":"Irlanda","de":"Irland","it":"Irlanda","pt":"Irlanda"},
	"IL":{"fr":"Israël","en":"Israel","es":"Israel","de":"Israel","it":"Israele","pt":"Israel"},
	"IQ":{"fr":"Irak","en":"Iraq","es":"Irak","de":"Irak","it":"Iraq","pt":"Iraque"},
	"IR":{"fr":"Iran","en":"Iran","es":"Irán","de":"Iran","it":"Iran","pt":"Irão"},
	"IT":{"fr":"Italie","en":"Italy","es":"Italia","de":"Italien","it":"Italia","pt":"Itália"},
	"JM":{"fr":"Jamaïque","en":"Jamaica","es":"Jamaica","de":"Jamaika","it":"Giamaica","pt":"Jamaica"},
	"JP":{"fr":"Japon","en":"Japan","es":"Japón","de":"Japan","it":"Giappone","pt":"Japão"},
	"KP":{"fr":"Corée du Nord","en":"North Korea","es":"Corea del Norte","de":"Nordkorea","it":"Corea del Nord","pt":"Coreia do Norte"},
	"KR":{"fr":"Corée du Sud","en":"South Korea","es":"Corea del Sur","de":"Südkorea","it":"Corea del Sud","pt":"Coreia do Sul"},
	"KW":{"fr":"Koweït","en":"Kuwait","es":"Kuwait","de":"Kuwait","it":"Kuwait","pt":"Kuwait"},
	"MA":{"fr":"Maroc","en":"Morocco","es":"Marruecos","de":"Marokko","it":"Marocco","pt":"Marrocos"},
	"MX":{"fr":"Mexique","en":"Mexico","es":"México","de":"Mexiko","it":"Messico","pt":"México"},
	"NG":{"fr":"Nigéria","en":"Nigeria","es":"Nigeria","de":"Nigeria","it":"Nigeria","pt":"Nigéria"},
	"NI":{"fr":"Nicaragua","en":"Nicaragua","es":"Nicaragua","de":"Nicaragua","it":"Nicaragua","pt":"Nicarágua"},
	"NL":{"fr":"Pays-Bas","en":"Netherlands","es":"Países Bajos","de":"Niederlande","it":"Paesi Bassi","pt":"Países Baixos"},
	"NO":{"fr":"Norvège","en":"Norway","es":"Noruega","de":"Norwegen","it":"Norvegia","pt":"Noruega"},
	"NZ":{"fr":"Nouvelle-Zélande","en":"New Zealand","es":"Nueva Zelanda","de":"Neuseeland","it":"Nuova Zelanda","pt":"Nova Zelândia"},
	"PA":{"fr":"Panama","en":"Panama","es":"Panamá","de":"Panama","it":"Panama","pt":"Panamá"},
	"PE":{"fr":"Pérou","en":"Peru","es":"Perú","de":"Peru","it":"Perù","pt":"Peru"},
	"PL":{"fr":"Pologne","en":"Poland","es":"Polonia","de":"Polen","it":"Polonia","pt":"Polónia"},
	"PT":{"fr":"Portugal","en":"Portugal","es":"Portugal","de":"Portugal","it":"Portogallo","pt":"Portugal"},
	"PY":{"fr":"Paraguay","en":"Paraguay","es":"Paraguay","de":"Paraguay","it":"Paraguay","pt":"Paraguai"},
	"QA":{"fr":"Qatar","en":"Qatar","es":"Catar","de":"Katar","it":"Qatar","pt":"Catar"},
	"RO":{"fr":"Roumanie","en":"Romania","es":"Rumanía","de":"Rumänien","it":"Romania","pt":"Roménia"},
	"RS":{"fr":"Serbie","en":"Serbia","es":"Serbia","de":"Serbien","it":"Serbia","pt":"Sérvia"},
	"RU":{"fr":"Russie","en":"Russia","es":"Rusia","de":"Russland","it":"Russia","pt":"Rússia"},
	"SA":{"fr":"Arabie Saoudite","en":"Saudi Arabia","es":"Arabia Saudita","de":"Saudi-Arabien","it":"Arabia Saudita","pt":"Arábia Saudita"},
	"SC":{"fr":"Écosse","en":"Scotland","es":"Escocia","de":"Schottland","it":"Scozia","pt":"Escócia"},
	"SE":{"fr":"Suède","en":"Sweden","es":"Suecia","de":"Schweden","it":"Svezia","pt":"Suécia"},
	"SI":{"fr":"Slovénie","en":"Slovenia","es":"Eslovenia","de":"Slowenien","it":"Slovenia","pt":"Eslovénia"},
	"SK":{"fr":"Slovaquie","en":"Slovakia","es":"Eslovaquia","de":"Slowakei","it":"Slovacchia","pt":"Eslováquia"},
	"SN":{"fr":"Sénégal","en":"Senegal","es":"Senegal","de":"Senegal","it":"Senegal","pt":"Senegal"},
	"SV":{"fr":"Salvador","en":"El Salvador","es":"El Salvador","de":"El Salvador","it":"El Salvador","pt":"El Salvador"},
	"TG":{"fr":"Togo","en":"Togo","es":"Togo","de":"Togo","it":"Togo","pt":"Togo"},
	"TN":{"fr":"Tunisie","en":"Tunisia","es":"Túnez","de":"Tunesien","it":"Tunisia","pt":"Tunísia"},
	"TR":{"fr":"Turquie","en":"Turkey","es":"Turquía","de":"Türkei","it":"Turchia","pt":"Turquia"},
	"TT":{"fr":"Trinité-et-Tobago","en":"Trinidad & Tobago","es":"Trinidad y Tobago","de":"Trinidad und Tobago","it":"Trinidad e Tobago","pt":"Trindade e Tobago"},
	"UA":{"fr":"Ukraine","en":"Ukraine","es":"Ucrania","de":"Ukraine","it":"Ucraina","pt":"Ucrânia"},
	"US":{"fr":"États-Unis","en":"United States","es":"Estados Unidos","de":"Vereinigte Staaten","it":"Stati Uniti","pt":"Estados Unidos"},
	"UY":{"fr":"Uruguay","en":"Uruguay","es":"Uruguay","de":"Uruguay","it":"Uruguay","pt":"Uruguai"},
	"WA":{"fr":"Pays de Galles","en":"Wales","es":"Gales","de":"Wales","it":"Galles","pt":"País de Gales"},
	"ZA":{"fr":"Afrique du Sud","en":"South Africa","es":"Sudáfrica","de":"Südafrika","it":"Sudafrica","pt":"África do Sul"},
}

const TRANSLATIONS = {
	"fr": {
		"conditions_title": "Conditions = Récompenses",
		"popup_help": "- Seuls les joueurs de 30 ans minimum sont éligibles.\n- Un joueur déposé dans une collection sera retiré de votre effectif.\n- Ajoutez une carte en cliquant sur le ballon dans le détail des cartes.\n- Appui long pour retirer une carte.",
		"confirm": "Attention ! Si vous confirmez le retrait du joueur, il sera définitivement supprimé.",
		"btn_yes": "OUI", "btn_no": "NON",
		"cond": ["14 postes remplis = 2 seconds postes","24 postes au total = 3 seconds postes","20 spécialités = 3 spécialités","2 cartes de chaque couleur (12) = 1 carte Magenta","16 cartes Jaunes = 1 carte Jaune","14 cartes Oranges = 1 carte Orange","12 cartes Rouges = 1 carte Rouge","10 cartes Blanches = 1 carte Blanche","8 cartes Magenta = 1 carte Magenta","3 cartes Bleues = 1 carte Bleue","16 joueurs de 33 ans = 3 cartes Jaunes 18 ans","Toutes conditions remplies = 1 carte Spéciale"],
	},
	"en": {
		"conditions_title": "Conditions = Rewards",
		"popup_help": "- Only players aged 30 or older are eligible.\n- A player placed in a collection will be removed from your squad.\n- Add a card by clicking the ball in the card detail.\n- Long press to remove a card.",
		"confirm": "Warning! If you confirm the player removal, they will be permanently deleted.",
		"btn_yes": "YES", "btn_no": "NO",
		"cond": ["14 positions filled = 2 second positions","24 positions total = 3 second positions","20 specialties total = 3 specialties","2 cards each color (12) = 1 Magenta card","16 Yellow cards = 1 Yellow card","14 Orange cards = 1 Orange card","12 Red cards = 1 Red card","10 White cards = 1 White card","8 Magenta cards = 1 Magenta card","3 Blue cards = 1 Blue card","16 players aged 33 = 3 Yellow cards (18yo)","All conditions completed = 1 Special card"],
	},
	"es": {
		"conditions_title": "Condiciones = Recompensas",
		"popup_help": "- Solo jugadores de 30 años o más son elegibles.\n- Un jugador en la colección será retirado de tu plantilla.\n- Añade una carta haciendo clic en el balón en el detalle.\n- Mantén pulsado para retirar una carta.",
		"confirm": "Atención! Si confirmas la retirada del jugador, será eliminado definitivamente.",
		"btn_yes": "SÍ", "btn_no": "NO",
		"cond": ["14 posiciones cubiertas = 2 segundas posiciones","24 posiciones total = 3 segundas posiciones","20 especialidades = 3 especialidades","2 cartas de cada color (12) = 1 carta Magenta","16 cartas Amarillas = 1 carta Amarilla","14 cartas Naranjas = 1 carta Naranja","12 cartas Rojas = 1 carta Roja","10 cartas Blancas = 1 carta Blanca","8 cartas Magenta = 1 carta Magenta","3 cartas Azules = 1 carta Azul","16 jugadores de 33 años = 3 cartas Amarillas 18 años","Todas las condiciones = 1 carta Especial"],
	},
	"de": {
		"conditions_title": "Bedingungen = Belohnungen",
		"popup_help": "- Nur Spieler ab 30 Jahren sind berechtigt.\n- Ein Spieler in der Sammlung wird aus deinem Kader entfernt.\n- Karte hinzufügen: Ball im Kartendetail anklicken.\n- Lang drücken zum Entfernen einer Karte.",
		"confirm": "Achtung! Wenn du die Entfernung bestätigst, wird der Spieler dauerhaft gelöscht.",
		"btn_yes": "JA", "btn_no": "NEIN",
		"cond": ["14 Positionen besetzt = 2 Zweitpositionen","24 Positionen gesamt = 3 Zweitpositionen","20 Spezialitäten = 3 Spezialitäten","2 Karten jeder Farbe (12) = 1 Magenta-Karte","16 Gelbe Karten = 1 Gelbe Karte","14 Orange Karten = 1 Orange Karte","12 Rote Karten = 1 Rote Karte","10 Weiße Karten = 1 Weiße Karte","8 Magenta-Karten = 1 Magenta-Karte","3 Blaue Karten = 1 Blaue Karte","16 Spieler 33 Jahre = 3 Gelbe Karten 18 Jahre","Alle Bedingungen erfüllt = 1 Spezialkarte"],
	},
	"it": {
		"conditions_title": "Condizioni = Premi",
		"popup_help": "- Solo i giocatori di 30 anni o più sono idonei.\n- Un giocatore nella collezione sarà rimosso dalla rosa.\n- Aggiungi una carta cliccando sul pallone nel dettaglio.\n- Tieni premuto per rimuovere una carta.",
		"confirm": "Attenzione! Se confermi la rimozione, il giocatore sarà eliminato definitivamente.",
		"btn_yes": "SÌ", "btn_no": "NO",
		"cond": ["14 posizioni coperte = 2 seconde posizioni","24 posizioni totali = 3 seconde posizioni","20 specialità = 3 specialità","2 carte di ogni colore (12) = 1 carta Magenta","16 carte Gialle = 1 carta Gialla","14 carte Arancioni = 1 carta Arancione","12 carte Rosse = 1 carta Rossa","10 carte Bianche = 1 carta Bianca","8 carte Magenta = 1 carta Magenta","3 carte Blu = 1 carta Blu","16 giocatori di 33 anni = 3 carte Gialle 18 anni","Tutte le condizioni = 1 carta Speciale"],
	},
	"pt": {
		"conditions_title": "Condições = Recompensas",
		"popup_help": "- Apenas jogadores com 30 anos ou mais são elegíveis.\n- Um jogador na coleção será removido do seu plantel.\n- Adicione uma carta clicando na bola no detalhe da carta.\n- Pressão longa para remover uma carta.",
		"confirm": "Atenção! Se confirmar a remoção, o jogador será eliminado definitivamente.",
		"btn_yes": "SIM", "btn_no": "NÃO",
		"cond": ["14 posições preenchidas = 2 segundas posições","24 posições totais = 3 segundas posições","20 especialidades = 3 especialidades","2 cartas de cada cor (12) = 1 carta Magenta","16 cartas Amarelas = 1 carta Amarela","14 cartas Laranja = 1 carta Laranja","12 cartas Vermelhas = 1 carta Vermelha","10 cartas Brancas = 1 carta Branca","8 cartas Magenta = 1 carta Magenta","3 cartas Azuis = 1 carta Azul","16 jogadores de 33 anos = 3 cartas Amarelas 18 anos","Todas as condições = 1 carta Especial"],
	},
}

var country_code:String=""; var slot_data:Array=[]; var card_instances:Array=[]; var conditions_done:Array=[]
var press_slot:int=-1; var press_timer:float=0.0; var press_holding:bool=false
var confirm_slot:int=-1; var touch_start:Vector2=Vector2.ZERO; var popup_help_open:bool=false

@onready var img_flag_title  = $IMG_FlagTitle
@onready var txt_country_name = $TXT_CountryName
@onready var btn_help        = $BTN_HelpCollection
@onready var txt_popup_help  = $BTN_HelpCollection/TXT_PopupCollection
@onready var popup_confirm   = $Popup_Confirm
@onready var txt_confirm     = $Popup_Confirm/TXT_Confirm
@onready var btn_yes         = $Popup_Confirm/BTN_Yes
@onready var btn_no          = $Popup_Confirm/BTN_No
@onready var txt_title_cond  = $TXT_TitleConditionsRewards

var slot_nodes:Array=[]; var condition_labels:Array=[]

func _ready():
	Taskbar.visible = false
	country_code = GameState.selected_country
	for i in range(16):
		slot_data.append({}); card_instances.append(null)
		slot_nodes.append(get_node("Slot%d" % (i + 1)))
	for i in range(MAX_CONDITIONS):
		conditions_done.append(false)
		condition_labels.append(get_node("Condition-Reward%d" % (i + 1)))
	txt_popup_help.visible = false; popup_confirm.visible = false
	_load_flag_and_name(); _apply_translations(); _load_country_data()

func _load_flag_and_name():
	if country_code == "": return  # guard : country_code vide si scene lancee directement
	var tex = load(FLAG_PATH % country_code.to_lower())
	if tex: img_flag_title.texture = tex
	var names = COUNTRY_NAMES.get(country_code, {})
	txt_country_name.text = names.get(GameState.language, names.get("en", country_code))

func _apply_translations():
	var t = TRANSLATIONS.get(GameState.language, TRANSLATIONS["en"])
	txt_title_cond.text = t["conditions_title"]
	txt_popup_help.text = t["popup_help"]
	txt_confirm.text    = t["confirm"]
	# BTN_Yes et BTN_No sont des Sprite2D — pas de propriete .text
	# Le texte OUI/NON est fixe dans la scene
	for i in range(MAX_CONDITIONS):
		condition_labels[i].text    = t["cond"][i]
		condition_labels[i].visible = not conditions_done[i]

func _load_country_data():
	Firebase.firestore_success.connect(_on_country_loaded)
	Firebase.firestore_failed.connect(_on_country_failed)
	Firebase.get_document("managers/" + Firebase.user_id + "/collection", country_code)

func _on_country_loaded(data:Dictionary):
	if Firebase.firestore_success.is_connected(_on_country_loaded): Firebase.firestore_success.disconnect(_on_country_loaded)
	if Firebase.firestore_failed.is_connected(_on_country_failed):  Firebase.firestore_failed.disconnect(_on_country_failed)
	for i in range(16):
		var raw = data.get("slot_%d" % (i + 1), "")
		if raw != "":
			var parsed = JSON.parse_string(raw)
			if parsed is Dictionary: slot_data[i] = parsed
	var cond_str = str(data.get("conditions", ""))
	for i in range(MAX_CONDITIONS):
		conditions_done[i] = (cond_str.length() > i and cond_str[i] == "1")
	_refresh_all()

func _on_country_failed(_error:String):
	if Firebase.firestore_success.is_connected(_on_country_loaded): Firebase.firestore_success.disconnect(_on_country_loaded)
	if Firebase.firestore_failed.is_connected(_on_country_failed):  Firebase.firestore_failed.disconnect(_on_country_failed)
	_refresh_all()

func _save_country_data():
	var save_dict:Dictionary = {}
	for i in range(16):
		save_dict["slot_%d" % (i + 1)] = "" if slot_data[i].is_empty() else JSON.stringify(slot_data[i])
	var cond_str = ""
	for b in conditions_done: cond_str += "1" if b else "0"
	save_dict["conditions"] = cond_str
	Firebase.update_document("managers/" + Firebase.user_id + "/collection", country_code, save_dict)
	_save_progress()

func _save_progress():
	var count = 0
	for b in conditions_done: if b: count += 1
	Firebase.update_document("managers/" + Firebase.user_id + "/collection", "progress", {country_code: count})

func _refresh_all():
	_refresh_slots(); _check_conditions(); _refresh_condition_labels()

func _refresh_slots():
	for i in range(16):
		if card_instances[i] != null: card_instances[i].queue_free(); card_instances[i] = null
		if slot_data[i].is_empty(): slot_nodes[i].visible = true
		else: slot_nodes[i].visible = false; _spawn_card(i)

func _spawn_card(idx:int):
	var d = slot_data[idx]; var card = CARD_SCENE.instantiate()
	card.note = int(d.get("note", 0)); card.color = str(d.get("color", ""))
	card.position1 = str(d.get("position1", "")); card.position2 = str(d.get("position2", ""))
	card.position2_unlocked = int(d.get("position2_unlocked", 0))
	card.age = int(d.get("age", 0)); card.height = int(d.get("height", 0)); card.weight = int(d.get("weight", 0))
	card.nationality = str(d.get("nationality", "")); card.specialty1 = str(d.get("specialty1", ""))
	card.specialty2 = str(d.get("specialty2", "")); card.firstname = str(d.get("firstname", ""))
	card.lastname = str(d.get("lastname", "")); card.pin_color = str(d.get("pin_color", ""))
	card.strength = int(d.get("strength", 0)); card.speed = int(d.get("speed", 0))
	card.aggression = int(d.get("aggression", 0)); card.positioning = int(d.get("positioning", 0))
	card.stamina = int(d.get("stamina", 0)); card.creativity = int(d.get("creativity", 0))
	card.concentration = int(d.get("concentration", 0)); card.motivation = int(d.get("motivation", 0))
	card.anticipation = int(d.get("anticipation", 0)); card.communication = int(d.get("communication", 0))
	card.clickable = false; card.display(); add_child(card)
	card.global_position = slot_nodes[idx].global_position; card_instances[idx] = card

func _check_conditions():
	var count_pos1 = 0; var count_pos_total = 0; var count_spec = 0
	var color_counts = {"yellow":0,"orange":0,"red":0,"white":0,"magenta":0,"blue":0}; var count_age33 = 0
	for d in slot_data:
		if d.is_empty(): continue
		count_pos1 += 1; count_pos_total += 1
		if int(d.get("position2_unlocked", 0)) == 1: count_pos_total += 1
		if str(d.get("specialty1", "")) != "": count_spec += 1
		if str(d.get("specialty2", "")) != "": count_spec += 1
		var col = str(d.get("color", ""))
		if col in color_counts: color_counts[col] += 1
		if int(d.get("age", 0)) >= 33: count_age33 += 1
	var has_two_each = true
	for col in color_counts: if color_counts[col] < 2: has_two_each = false
	var prev_done = conditions_done.duplicate()
	conditions_done[0]  = count_pos1 >= 14;        conditions_done[1]  = count_pos_total >= 24
	conditions_done[2]  = count_spec >= 20;         conditions_done[3]  = has_two_each
	conditions_done[4]  = color_counts["yellow"] >= 16;  conditions_done[5]  = color_counts["orange"] >= 14
	conditions_done[6]  = color_counts["red"] >= 12;     conditions_done[7]  = color_counts["white"] >= 10
	conditions_done[8]  = color_counts["magenta"] >= 8;  conditions_done[9]  = color_counts["blue"] >= 3
	conditions_done[10] = count_age33 >= 16
	var all_done = true
	for i in range(11): if not conditions_done[i]: all_done = false
	conditions_done[11] = all_done
	if conditions_done != prev_done: _save_country_data()

func _refresh_condition_labels():
	for i in range(MAX_CONDITIONS): condition_labels[i].visible = not conditions_done[i]

func _process(delta):
	if press_holding and press_slot >= 0:
		press_timer += delta
		if press_timer >= LONG_PRESS_DURATION:
			press_holding = false; press_timer = 0.0
			confirm_slot = press_slot; popup_confirm.visible = true

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed: touch_start = event.position; _on_press(event.position)
		else: _on_release(event.position)
	elif event is InputEventMouseMotion:
		if press_holding and event.position.distance_to(touch_start) > 10:
			press_holding = false; press_timer = 0.0

func _on_press(pos:Vector2):
	if popup_confirm.visible:
		if _sprite_hit(btn_yes, pos): _confirm_remove(); return
		if _sprite_hit(btn_no,  pos): popup_confirm.visible = false; confirm_slot = -1; return
		return
	if txt_popup_help.visible and _label_hit(txt_popup_help, pos):
		txt_popup_help.visible = false; popup_help_open = false; return
	if _sprite_hit(btn_help, pos): txt_popup_help.visible = true; popup_help_open = true; return
	for i in range(16):
		if _sprite_hit(slot_nodes[i], pos) or _card_hit(i, pos):
			if slot_data[i].is_empty(): txt_popup_help.visible = true; popup_help_open = true
			else: press_slot = i; press_holding = true; press_timer = 0.0
			return

func _on_release(_pos:Vector2):
	if not press_holding: return
	press_holding = false; press_timer = 0.0
	if press_slot >= 0 and not slot_data[press_slot].is_empty(): _open_dcp(press_slot)
	press_slot = -1

func _open_dcp(idx:int):
	var d = slot_data[idx]
	GameState.selected_note = int(d.get("note", 0));              GameState.selected_color = str(d.get("color", ""))
	GameState.selected_position1 = str(d.get("position1", ""));   GameState.selected_position2 = str(d.get("position2", ""))
	GameState.selected_position2_unlocked = int(d.get("position2_unlocked", 0))
	GameState.selected_age = int(d.get("age", 0));                GameState.selected_height = int(d.get("height", 0))
	GameState.selected_weight = int(d.get("weight", 0));          GameState.selected_nationality = str(d.get("nationality", ""))
	GameState.selected_specialty1 = str(d.get("specialty1", "")); GameState.selected_specialty2 = str(d.get("specialty2", ""))
	GameState.selected_firstname = str(d.get("firstname", ""));   GameState.selected_lastname = str(d.get("lastname", ""))
	GameState.selected_pin_color = str(d.get("pin_color", ""));   GameState.selected_strength = int(d.get("strength", 0))
	GameState.selected_speed = int(d.get("speed", 0));            GameState.selected_aggression = int(d.get("aggression", 0))
	GameState.selected_positioning = int(d.get("positioning", 0)); GameState.selected_stamina = int(d.get("stamina", 0))
	GameState.selected_creativity = int(d.get("creativity", 0));  GameState.selected_concentration = int(d.get("concentration", 0))
	GameState.selected_motivation = int(d.get("motivation", 0));  GameState.selected_anticipation = int(d.get("anticipation", 0))
	GameState.selected_communication = int(d.get("communication", 0))
	GameState.previous_scene = "res://Scenes/collection_country.tscn"
	get_tree().change_scene_to_file(SCENE_DCP)

func _confirm_remove():
	popup_confirm.visible = false
	if confirm_slot < 0: return
	slot_data[confirm_slot] = {}
	if card_instances[confirm_slot] != null:
		card_instances[confirm_slot].queue_free(); card_instances[confirm_slot] = null
	slot_nodes[confirm_slot].visible = true; confirm_slot = -1
	_check_conditions(); _refresh_condition_labels(); _save_country_data()

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _card_hit(idx: int, pos: Vector2) -> bool:
	var card = card_instances[idx]
	if card == null: return false
	return Rect2(-60, -80, 120, 160).has_point(card.to_local(pos))

func _label_hit(label: Label, pos: Vector2) -> bool:
	if label == null or not label.visible: return false
	return label.get_global_rect().has_point(pos)
