extends Node2D

# ── CONSTANTES ────────────────────────────────────────────────────────────────
const BALL_COLORS = {
	"cyan":      Color(0.0,   0.808, 0.820),
	"marine":    Color(0.0,   0.200, 0.400),
	"rose":      Color(1.0,   0.412, 0.706),
	"violet":    Color(0.416, 0.051, 0.678),
	"rouge":     Color(1.0,   0.420, 0.420),
	"bordeaux":  Color(0.502, 0.0,   0.125),
	"gris":      Color(0.722, 0.722, 0.722),
	"marron":    Color(0.545, 0.271, 0.075),
	"vertclair": Color(0.584, 0.835, 0.698),
	"vertfonce": Color(0.176, 0.416, 0.310),
}

const BALL_HEX_TO_KEY = {
	"#00CED1": "cyan",     "#003366": "marine",
	"#FF69B4": "rose",     "#6A0DAD": "violet",
	"#FF6B6B": "rouge",    "#800020": "bordeaux",
	"#B8B8B8": "gris",     "#8B4513": "marron",
	"#95D5B2": "vertclair","#2D6A4F": "vertfonce",
}

const CARD_COLORS = {
	"yellow":  Color(1.0, 0.85, 0.0),
	"orange":  Color(1.0, 0.5,  0.0),
	"red":     Color(0.9, 0.1,  0.1),
	"magenta": Color(0.56, 0.016, 0.56),
	"blue":    Color(0.2,  0.5,  1.0),
	"white":   Color(1.0,  1.0,  1.0),
	"special": Color(0.0,  0.8,  0.4),
}

const FORMATION_COSTS  = [100, 200, 300, 400, 500, 600, 700, 800, 900, 0, 0]
const FORMATION_GAINS  = [15, 9, 8, 7, 6, 5, 4, 3, 2, 0, 0]
const CLASSIC_MATCHES  = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 2]

const COLOR_GREEN  = Color(0.0,  0.78, 0.22)
const COLOR_BLUE   = Color(0.2,  0.5,  1.0)
const COLOR_ORANGE = Color(1.0,  0.5,  0.0)
const COLOR_RED    = Color(0.9,  0.1,  0.1)
const COLOR_WHITE  = Color(1.0,  1.0,  1.0)

const MAX_NAME_LENGTH = 10

const SCENE_COLLECTION_COUNTRY = "res://Scenes/collection_country.tscn"

# ── TRADUCTIONS — POPUP UNIQUEMENT ────────────────────────────────────────────
const TRANSLATIONS = {
	"fr": {
		"player_future": "Attention ! L'action choisie est sans retour possible.",
		"help": "Renommer : cartes bleues, blanches et spéciales uniquement.\nPoste & Spécialité : obtenus via les récompenses.\nCouleur Ballon : organisez votre effectif par code couleur.\nEntrainement Pro : +1 tous les 20 matchs (1 match/jour).\nFormation : utilisez vos diamants pour progresser (1 palier/saison).",
	},
	"en": {
		"player_future": "Warning! The chosen action cannot be undone.",
		"help": "Rename: blue, white, and special cards only.\nPosition & Specialty: earned through rewards.\nBall Color: organize your squad using colors.\nPro Training: +1 every 20 matches (1 match/day).\nFormation: use diamonds to upgrade (1 level/season).",
	},
	"es": {
		"player_future": "¡Atención! La acción elegida no tiene vuelta atrás.",
		"help": "Renombrar: solo cartas azules, blancas y especiales.\nPosición y Especialidad: se obtienen con las recompensas.\nColor Balón: organiza tu plantilla por código de color.\nEntrenamiento Pro: +1 cada 20 partidos (1 partido/día).\nFormación: usa diamantes para avanzar (1 nivel/temporada).",
	},
	"de": {
		"player_future": "Achtung! Die gewählte Aktion kann nicht rückgängig gemacht werden.",
		"help": "Umbenennen: nur blaue, weiße und besondere Karten.\nPosition & Spezialität: werden als Belohnungen freigeschaltet.\nBallfarbe: organisiere dein Team mit einem Farbcode.\nProfi-Training: +1 alle 20 Spiele (1 Spiel/Tag).\nAusbildung: nutze Diamanten zum Aufsteigen (1 Stufe/Saison).",
	},
	"it": {
		"player_future": "Attenzione! L'azione scelta è irreversibile.",
		"help": "Rinominare: solo carte blu, bianche e speciali.\nPosizione e Specialità: ottenute tramite ricompense.\nColore Pallone: organizza la rosa con un codice colore.\nAllenamento Pro: +1 ogni 20 partite (1 partita/giorno).\nFormazione: usa i diamanti per avanzare (1 livello/stagione).",
	},
	"pt": {
		"player_future": "Atenção! A ação escolhida é irreversível.",
		"help": "Renomear: apenas cartas azuis, brancas e especiais.\nPosição e Especialidade: obtidas através de recompensas.\nCor da Bola: organize o seu plantel por código de cores.\nTreino Pro: +1 a cada 20 partidas (1 partida/dia).\nFormação: use diamantes para avançar (1 nível/temporada).",
	},
}

# ── ÉTAT ──────────────────────────────────────────────────────────────────────
var note:                    int    = 0
var color:                   String = ""
var position1:               String = ""
var position2:               String = ""
var position2_unlocked:      int    = 0
var age:                     int    = 0
var height:                  int    = 0
var weight:                  int    = 0
var nationality:             String = ""
var specialty1:              String = ""
var specialty2:              String = ""
var firstname:               String = ""
var lastname:                String = ""
var ball_color:              String = ""
var strength:                int    = 0
var speed:                   int    = 0
var aggression:              int    = 0
var positioning:             int    = 0
var stamina:                 int    = 0
var creativity:              int    = 0
var concentration:           int    = 0
var motivation:              int    = 0
var anticipation:            int    = 0
var communication:           int    = 0
var card_id:                 String = ""
var training_tier:           int    = 0
var training_matches:        int    = 0
var is_formation_card:       bool   = false
var ball_menu_open:          bool   = false
var rename_mode:             String = ""
var manager_position2_stock: int    = 0
var manager_specialty_stock: int    = 0
var player_future_open:      bool   = false

# ── NŒUDS — GÉNÉRAL ──────────────────────────────────────────────────────────
@onready var btn_close          = $BTN_Close              # Sprite2D
@onready var btn_help           = $BTN_Help               # Sprite2D
@onready var lbl_help           = $LBL_Help               # Label
@onready var btn_player_future  = $BTN_PlayerFuture       # Sprite2D
@onready var pnl_player_future  = $PNL_PlayerFuture       # PanelContainer
@onready var lbl_player_future  = $PNL_PlayerFuture/CNT_PlayerFuture/LBL_PlayerFuture
@onready var btn_sign_pro       = $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignPro
@onready var btn_sign_pantheon  = $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignPantheon
@onready var btn_sign_collection= $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignCollection
@onready var btn_sign_eoc       = $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignEndOfCareer

# ── NŒUDS — PLAYER ────────────────────────────────────────────────────────────
@onready var player_bg         = $Player/BG_CardBackground    # PanelContainer
@onready var player_note       = $Player/LBL_Note
@onready var player_pos1       = $Player/LBL_Position1
@onready var player_pos2       = $Player/LBL_Position2
@onready var player_spec1      = $Player/IMG_Specialty1
@onready var player_spec2      = $Player/IMG_Specialty2
@onready var player_flag       = $Player/IMG_Flag
@onready var player_firstname  = $Player/LBL_FirstName
@onready var player_lastname   = $Player/LBL_LastName
@onready var player_ball_color = $Player/IMG_BallColor

# ── NŒUDS — SKILLS ────────────────────────────────────────────────────────────
@onready var skills_bg                = $Skills/BG_CardBackground    # PanelContainer
@onready var lbl_skills_title         = $Skills/LBL_SkillsTitle
@onready var lbl_strength_label       = $Skills/LBL_StrengthLabel
@onready var lbl_speed_label          = $Skills/LBL_SpeedLabel
@onready var lbl_aggression_label     = $Skills/LBL_AggressionLabel
@onready var lbl_positioning_label    = $Skills/LBL_PositioningLabel
@onready var lbl_stamina_label        = $Skills/LBL_StaminaLabel
@onready var lbl_concentration_label  = $Skills/LBL_ConcentrationLabel
@onready var lbl_communication_label  = $Skills/LBL_CommunicationLabel
@onready var lbl_motivation_label     = $Skills/LBL_MotivationLabel
@onready var lbl_creativity_label     = $Skills/LBL_CreativityLabel
@onready var lbl_anticipation_label   = $Skills/LBL_AnticipationLabel
@onready var lbl_strength_value       = $Skills/LBL_StrengthValue
@onready var lbl_speed_value          = $Skills/LBL_SpeedValue
@onready var lbl_aggression_value     = $Skills/LBL_AggressionValue
@onready var lbl_positioning_value    = $Skills/LBL_PositioningValue
@onready var lbl_stamina_value        = $Skills/LBL_StaminaValue
@onready var lbl_concentration_value  = $Skills/LBL_ConcentrationValue
@onready var lbl_communication_value  = $Skills/LBL_CommunicationValue
@onready var lbl_motivation_value     = $Skills/LBL_MotivationValue
@onready var lbl_creativity_value     = $Skills/LBL_CreativityValue
@onready var lbl_anticipation_value   = $Skills/LBL_AnticipationValue

# ── NŒUDS — PHYSICAL ──────────────────────────────────────────────────────────
@onready var physical_bg        = $Physical/BG_CardBackground    # PanelContainer
@onready var lbl_physical_title = $Physical/LBL_PhysicalTitle
@onready var lbl_age_label      = $Physical/LBL_AgeLabel
@onready var lbl_height_label   = $Physical/LBL_HeightLabel
@onready var lbl_weight_label   = $Physical/LBL_WeightLabel
@onready var lbl_age_value      = $Physical/LBL_AgeValue
@onready var lbl_height_value   = $Physical/LBL_HeightValue
@onready var lbl_weight_value   = $Physical/LBL_WeightValue

# ── NŒUDS — EVOLUTION ─────────────────────────────────────────────────────────
@onready var lbl_rename_player   = $Evolution/LBL_RenamePlayer
@onready var btn_rename          = $Evolution/BTN_RenamePlayer          # Sprite2D
@onready var inp_firstname       = $Evolution/INP_FirstName
@onready var inp_lastname        = $Evolution/INP_LastName
@onready var lbl_pos2            = $Evolution/LBL_AttributePosition2
@onready var btn_pos2            = $Evolution/BTN_AttributePosition2    # Sprite2D
@onready var lbl_spec1           = $Evolution/LBL_AttributeSpecialty1
@onready var btn_spec1           = $Evolution/BTN_AttributeSpecialty1   # Sprite2D
@onready var lbl_spec2           = $Evolution/LBL_AttributeSpecialty2
@onready var btn_spec2           = $Evolution/BTN_AttributeSpecialty2   # Sprite2D
@onready var lbl_ball_color      = $Evolution/LBL_AttributeBallColor
@onready var btn_ball_color_menu = $Evolution/BTN_AttributeBallColor    # Sprite2D

# ── NŒUDS — ACHIEVEMENTS ──────────────────────────────────────────────────────
@onready var achievements_bg          = $Achievements/BG_CardBackground    # PanelContainer
@onready var lbl_achievements_title   = $Achievements/LBL_AchievementsTitle
@onready var lbl_played_label         = $Achievements/LBL_PlayedLabel
@onready var lbl_wins_label           = $Achievements/LBL_WinsLabel
@onready var lbl_losses_label         = $Achievements/LBL_LossesLabel
@onready var lbl_winrate_label        = $Achievements/LBL_WinRateLabel
@onready var lbl_competitions_label   = $Achievements/LBL_CompetitionsPlayedLabel
@onready var lbl_played_value         = $Achievements/LBL_PlayedValue
@onready var lbl_wins_value           = $Achievements/LBL_WinsValue
@onready var lbl_losses_value         = $Achievements/LBL_LossesValue
@onready var lbl_winrate_value        = $Achievements/LBL_WinRateValue
@onready var lbl_competitions_value   = $Achievements/LBL_CompetitionsPlayedValue

# ── NŒUDS — TRAINING ──────────────────────────────────────────────────────────
@onready var training_bg          = $Training/BG_CardBackground    # PanelContainer
@onready var training_formation   = $Training/TrainingFormation
@onready var training_classic     = $Training/TrainingClassic
@onready var lbl_training_f_title = $Training/TrainingFormation/LBL_TrainingTitle
@onready var lbl_training_c_title = $Training/TrainingClassic/LBL_TrainingTitle
@onready var lbl_matches_label    = $Training/TrainingClassic/LBL_MatchesLabel

# ── READY ──────────────────────────────────────────────────────────────────────
func _ready():
	note               = GameState.selected_note
	color              = GameState.selected_color
	position1          = GameState.selected_position1
	position2          = GameState.selected_position2
	position2_unlocked = GameState.selected_position2_unlocked
	age                = GameState.selected_age
	height             = GameState.selected_height
	weight             = GameState.selected_weight
	nationality        = GameState.selected_nationality
	specialty1         = GameState.selected_specialty1
	specialty2         = GameState.selected_specialty2
	firstname          = GameState.selected_firstname
	lastname           = GameState.selected_lastname
	ball_color         = GameState.selected_ball_color
	strength           = GameState.selected_strength
	speed              = GameState.selected_speed
	aggression         = GameState.selected_aggression
	positioning        = GameState.selected_positioning
	stamina            = GameState.selected_stamina
	creativity         = GameState.selected_creativity
	concentration      = GameState.selected_concentration
	motivation         = GameState.selected_motivation
	anticipation       = GameState.selected_anticipation
	communication      = GameState.selected_communication
	card_id            = GameState.selected_card_id
	is_formation_card  = (color == "white" and age < 18)
	Taskbar.visible    = false
	lbl_help.visible          = false
	pnl_player_future.visible = false
	inp_firstname.visible     = false
	inp_lastname.visible      = false
	_set_ball_menu_visible(false)
	_setup_ball_colors()
	_apply_translations()
	_display_player()
	_display_skills()
	_display_physical()
	_display_evolution()
	_display_achievements()
	_load_training_data()
	inp_firstname.text_submitted.connect(_on_firstname_submitted)
	inp_lastname.text_submitted.connect(_on_lastname_submitted)

# ── BALL COLOR SETUP ──────────────────────────────────────────────────────────
func _setup_ball_colors():
	for hex in BALL_HEX_TO_KEY:
		var btn = btn_ball_color_menu.get_node_or_null("PNL_AttributeBallColor/BTN_AttributeBall" + hex)
		if btn: btn.modulate = BALL_COLORS[BALL_HEX_TO_KEY[hex]]

func _set_ball_menu_visible(value: bool):
	var pnl = btn_ball_color_menu.get_node_or_null("PNL_AttributeBallColor")
	if pnl: pnl.visible = value
	for hex in BALL_HEX_TO_KEY:
		var btn = btn_ball_color_menu.get_node_or_null("PNL_AttributeBallColor/BTN_AttributeBall" + hex)
		if btn: btn.visible = value

# ── TRADUCTIONS — POPUP UNIQUEMENT ────────────────────────────────────────────
func _apply_translations():
	var t = TRANSLATIONS.get(GameState.language, TRANSLATIONS["en"])
	lbl_help.text          = t["help"]
	lbl_player_future.text = t["player_future"]
	# Tout le reste en anglais
	lbl_skills_title.text        = "SKILLS"
	lbl_strength_label.text      = "Strength"
	lbl_speed_label.text         = "Speed"
	lbl_aggression_label.text    = "Aggression"
	lbl_positioning_label.text   = "Positioning"
	lbl_stamina_label.text       = "Stamina"
	lbl_concentration_label.text = "Concentration"
	lbl_communication_label.text = "Communication"
	lbl_motivation_label.text    = "Motivation"
	lbl_creativity_label.text    = "Creativity"
	lbl_anticipation_label.text  = "Anticipation"
	lbl_physical_title.text      = "PHYSICAL"
	lbl_age_label.text           = "Age"
	lbl_height_label.text        = "Height"
	lbl_weight_label.text        = "Weight"
	lbl_achievements_title.text  = "ACHIEVEMENTS"
	lbl_played_label.text        = "Matches played"
	lbl_wins_label.text          = "Wins"
	lbl_losses_label.text        = "Losses"
	lbl_winrate_label.text       = "Win rate %"
	lbl_competitions_label.text  = "Competitions played"
	lbl_training_f_title.text    = "FORMATION"
	lbl_training_c_title.text    = "PRO TRAINING"
	lbl_matches_label.text       = "Matches :"
	lbl_rename_player.text       = "Rename player"
	lbl_pos2.text                = "Attribute Position 2"
	lbl_spec1.text               = "Attribute Specialty 1"
	lbl_spec2.text               = "Attribute Specialty 2"
	lbl_ball_color.text          = "Ball Color"
	_apply_training_formation_texts()

func _apply_training_formation_texts():
	for i in range(1, 12):
		var lbl = training_formation.get_node_or_null("LBL_Round%d" % i)
		if lbl == null: continue
		var idx = i - 1
		if idx < 9:
			lbl.text = "+ %d for %d" % [FORMATION_GAINS[idx], FORMATION_COSTS[idx]]
		elif idx == 9: lbl.text = "+ 1 position for"
		else:          lbl.text = "+ 1 specialty for"

# ── PANEL COLOR ───────────────────────────────────────────────────────────────
func _set_panel_color(panel: PanelContainer, c: Color):
	var style = panel.get_theme_stylebox("panel").duplicate()
	style.bg_color = c
	panel.add_theme_stylebox_override("panel", style)

# ── AFFICHAGE PLAYER ──────────────────────────────────────────────────────────
func _display_player():
	if color in CARD_COLORS: _set_panel_color(player_bg, CARD_COLORS[color])
	player_note.text      = str(note)
	player_pos1.text      = position1
	player_pos2.text      = position2 if position2_unlocked == 1 else ""
	player_pos2.visible   = (position2 != "" and position2_unlocked == 1)
	player_firstname.text = firstname
	player_lastname.text  = lastname
	player_spec1.visible  = (specialty1 != "")
	player_spec2.visible  = (specialty2 != "")
	if specialty1 != "":
		var p = "res://Sprites/Specialties/specialty_" + specialty1 + ".png"
		if ResourceLoader.exists(p): player_spec1.texture = load(p)
	if specialty2 != "":
		var p = "res://Sprites/Specialties/specialty_" + specialty2 + ".png"
		if ResourceLoader.exists(p): player_spec2.texture = load(p)
	var fp = "res://Sprites/Flags/flag_" + nationality + ".png"
	if ResourceLoader.exists(fp):
		player_flag.texture = load(fp); player_flag.visible = true
	else:
		player_flag.visible = false
	if ball_color != "" and ball_color in BALL_COLORS:
		player_ball_color.modulate = BALL_COLORS[ball_color]
		player_ball_color.visible  = true
	else:
		player_ball_color.visible  = false

# ── AFFICHAGE SKILLS ──────────────────────────────────────────────────────────
func _display_skills():
	if color in CARD_COLORS: _set_panel_color(skills_bg, CARD_COLORS[color])
	lbl_strength_value.text      = str(strength)
	lbl_speed_value.text         = str(speed)
	lbl_aggression_value.text    = str(aggression)
	lbl_positioning_value.text   = str(positioning)
	lbl_stamina_value.text       = str(stamina)
	lbl_concentration_value.text = str(concentration)
	lbl_communication_value.text = str(communication)
	lbl_motivation_value.text    = str(motivation)
	lbl_creativity_value.text    = str(creativity)
	lbl_anticipation_value.text  = str(anticipation)

# ── AFFICHAGE PHYSICAL ────────────────────────────────────────────────────────
func _display_physical():
	if age <= 21:   _set_panel_color(physical_bg, COLOR_GREEN)
	elif age <= 26: _set_panel_color(physical_bg, COLOR_BLUE)
	elif age <= 31: _set_panel_color(physical_bg, COLOR_ORANGE)
	else:           _set_panel_color(physical_bg, COLOR_RED)
	lbl_age_value.text    = str(age)
	lbl_height_value.text = str(height)
	lbl_weight_value.text = str(weight)

# ── AFFICHAGE EVOLUTION ───────────────────────────────────────────────────────
func _display_evolution():
	var can_rename = color in ["blue", "white", "special"]
	btn_rename.modulate        = COLOR_GREEN if can_rename else COLOR_RED
	btn_pos2.modulate          = COLOR_GREEN if manager_position2_stock > 0 else COLOR_RED
	btn_spec1.modulate         = COLOR_GREEN if manager_specialty_stock > 0 else COLOR_RED
	btn_spec2.modulate         = COLOR_GREEN if manager_specialty_stock > 0 else COLOR_RED
	btn_ball_color_menu.self_modulate = COLOR_GREEN

# ── AFFICHAGE ACHIEVEMENTS ────────────────────────────────────────────────────
func _display_achievements():
	var played_val       = 0
	var wins_val         = 0
	var losses_val       = 0
	var winrate_val      = 0
	var competitions_val = 0
	lbl_played_value.text       = str(played_val)
	lbl_wins_value.text         = str(wins_val)
	lbl_losses_value.text       = str(losses_val)
	lbl_winrate_value.text      = str(winrate_val)
	lbl_competitions_value.text = str(competitions_val)
	if winrate_val >= 75:        _set_panel_color(achievements_bg, COLOR_GREEN)
	elif winrate_val >= 50:      _set_panel_color(achievements_bg, COLOR_BLUE)
	elif winrate_val >= 25:      _set_panel_color(achievements_bg, COLOR_ORANGE)
	else:                        _set_panel_color(achievements_bg, COLOR_RED)

# ── AFFICHAGE TRAINING ────────────────────────────────────────────────────────
func _display_training():
	if color in CARD_COLORS: _set_panel_color(training_bg, CARD_COLORS[color])
	if is_formation_card:
		training_formation.visible = true
		training_classic.visible   = false
		_display_training_formation()
	else:
		training_formation.visible = false
		training_classic.visible   = true
		_display_training_classic()

func _display_training_formation():
	for i in range(1, 12):
		var lbl     = training_formation.get_node_or_null("LBL_Round%d" % i)
		if lbl == null: continue
		var diamond = lbl.get_node_or_null("IMG_Diamond")
		if i <= training_tier:
			lbl.modulate = COLOR_GREEN
			if diamond: diamond.modulate = COLOR_GREEN
		else:
			lbl.modulate = COLOR_WHITE
			if diamond: diamond.modulate = COLOR_WHITE

func _display_training_classic():
	for i in range(1, 21):
		var lbl = training_classic.get_node_or_null("LBL_Round%d" % i)
		if lbl: lbl.modulate = COLOR_WHITE
	var round_num = 0
	for tier_idx in range(CLASSIC_MATCHES.size()):
		var needed = CLASSIC_MATCHES[tier_idx]
		for j in range(needed):
			round_num += 1
			var lbl = training_classic.get_node_or_null("LBL_Round%d" % round_num)
			if lbl == null: continue
			if tier_idx < training_tier:
				lbl.modulate = COLOR_GREEN
			elif tier_idx == training_tier and j < training_matches:
				lbl.modulate = COLOR_GREEN

# ── FIRESTORE — TRAINING ──────────────────────────────────────────────────────
func _load_training_data():
	if card_id == "": _display_training(); return
	Firebase.firestore_success.connect(_on_training_loaded)
	Firebase.firestore_failed.connect(_on_training_failed)
	Firebase.get_document("managers/" + Firebase.user_id + "/cards", card_id)

func _on_training_loaded(data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_training_loaded):
		Firebase.firestore_success.disconnect(_on_training_loaded)
	if Firebase.firestore_failed.is_connected(_on_training_failed):
		Firebase.firestore_failed.disconnect(_on_training_failed)
	training_tier    = int(data.get("training_tier", 0))
	training_matches = int(data.get("training_matches", 0))
	_display_training()

func _on_training_failed(_error: String):
	if Firebase.firestore_success.is_connected(_on_training_loaded):
		Firebase.firestore_success.disconnect(_on_training_loaded)
	if Firebase.firestore_failed.is_connected(_on_training_failed):
		Firebase.firestore_failed.disconnect(_on_training_failed)
	_display_training()

# ── SAVE ──────────────────────────────────────────────────────────────────────
func _save_card():
	if card_id == "": return
	Firebase.update_document("managers/" + Firebase.user_id + "/cards", card_id, {
		"firstname":          firstname,
		"lastname":           lastname,
		"ball_color":         ball_color,
		"position2_unlocked": position2_unlocked,
		"specialty1":         specialty1,
		"specialty2":         specialty2,
		"training_tier":      training_tier,
		"training_matches":   training_matches,
	})

# ── BALL COLOR ────────────────────────────────────────────────────────────────
func _apply_ball_color(hex: String):
	ball_color     = BALL_HEX_TO_KEY.get(hex, "")
	ball_menu_open = false
	_set_ball_menu_visible(false)
	lbl_ball_color.visible = true
	_display_player(); _save_card()

func _remove_ball_color():
	ball_color     = ""
	ball_menu_open = false
	_set_ball_menu_visible(false)
	lbl_ball_color.visible = true
	_display_player(); _save_card()

# ── RENAME ────────────────────────────────────────────────────────────────────
func _enter_rename():
	inp_firstname.text    = firstname
	inp_lastname.text     = lastname
	inp_firstname.visible = true
	inp_lastname.visible  = true
	inp_firstname.grab_focus()
	rename_mode = "firstname"

func _on_firstname_submitted(text: String):
	firstname             = text.strip_edges().left(MAX_NAME_LENGTH)
	player_firstname.text = firstname
	rename_mode           = "lastname"
	inp_lastname.grab_focus()

func _on_lastname_submitted(text: String):
	lastname              = text.strip_edges().left(MAX_NAME_LENGTH)
	player_lastname.text  = lastname
	inp_firstname.visible = false
	inp_lastname.visible  = false
	rename_mode           = ""
	_save_card()

# ── ACTIONS PLAYER FUTURE ─────────────────────────────────────────────────────
func _action_sign_pro():
	# TODO : déclencher le contrat pro
	pass

func _action_sign_pantheon():
	# TODO : naviguer vers pantheon
	pass

func _action_sign_collection():
	GameState.selected_country        = nationality.to_upper()
	GameState.previous_scene          = "res://Scenes/detail_card_player.tscn"
	GameState.collection_card_to_add  = card_id
	get_tree().change_scene_to_file(SCENE_COLLECTION_COUNTRY)

func _action_sign_end_of_career():
	# TODO : mettre le joueur en retraite
	pass

# ── FERMETURE ─────────────────────────────────────────────────────────────────
func _close():
	_save_card()
	if GameState.selected_deco_index == 1:
		GameState.deco1_ball_color = ball_color
		GameState.deco1_firstname  = firstname
		GameState.deco1_lastname   = lastname
	elif GameState.selected_deco_index == 2:
		GameState.deco2_ball_color = ball_color
		GameState.deco2_firstname  = firstname
		GameState.deco2_lastname   = lastname
	Taskbar.visible = true
	get_tree().change_scene_to_file(GameState.previous_scene)

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	var pos = event.position

	# Fermer la scène
	if _sprite_hit(btn_close, pos):
		_close(); return

	# Toggle LBL_Help
	if _sprite_hit(btn_help, pos):
		lbl_help.visible = not lbl_help.visible
		pnl_player_future.visible = false
		return

	# Toggle PNL_PlayerFuture
	if _sprite_hit(btn_player_future, pos):
		pnl_player_future.visible = not pnl_player_future.visible
		lbl_help.visible = false
		return

	# Fermer popups si clic ailleurs
	if lbl_help.visible:
		lbl_help.visible = false; return
	if pnl_player_future.visible:
		# Actions PlayerFuture
		if _sprite_hit(btn_sign_pro, pos):
			pnl_player_future.visible = false; _action_sign_pro(); return
		if _sprite_hit(btn_sign_pantheon, pos):
			pnl_player_future.visible = false; _action_sign_pantheon(); return
		if _sprite_hit(btn_sign_collection, pos):
			pnl_player_future.visible = false; _action_sign_collection(); return
		if _sprite_hit(btn_sign_eoc, pos):
			pnl_player_future.visible = false; _action_sign_end_of_career(); return
		pnl_player_future.visible = false; return

	# Menu ball color ouvert
	if ball_menu_open:
		for hex in BALL_HEX_TO_KEY:
			var btn = btn_ball_color_menu.get_node_or_null("PNL_AttributeBallColor/BTN_AttributeBall" + hex)
			if btn and _sprite_hit(btn, pos):
				_apply_ball_color(hex); return
		ball_menu_open = false
		_set_ball_menu_visible(false)
		lbl_ball_color.visible = true
		return

	# BTN_RenamePlayer
	if _sprite_hit(btn_rename, pos):
		if color in ["blue", "white", "special"]: _enter_rename()
		return

	# BTN_AttributePosition2
	if _sprite_hit(btn_pos2, pos):
		if manager_position2_stock > 0:
			position2_unlocked = 1
			manager_position2_stock -= 1
			_display_player(); _display_evolution(); _save_card()
		return

	# BTN_AttributeSpecialty1 / 2
	if _sprite_hit(btn_spec1, pos):
		if manager_specialty_stock > 0 and specialty1 == "": pass
		return
	if _sprite_hit(btn_spec2, pos):
		if manager_specialty_stock > 0 and specialty2 == "": pass
		return

	# BTN_AttributeBallColor — toggle menu
	if _sprite_hit(btn_ball_color_menu, pos):
		if ball_menu_open:
			_remove_ball_color()
		else:
			ball_menu_open = true
			_set_ball_menu_visible(true)
			lbl_ball_color.visible = false
		return

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _label_hit(label: Label, pos: Vector2) -> bool:
	if label == null or not label.visible: return false
	return label.get_global_rect().has_point(pos)
