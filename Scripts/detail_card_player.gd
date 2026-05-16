extends Node2D

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

const SPECIALTY_FILES = {
	"GoalReflex":  "res://Sprites/Specialties/img_reflex_save.png",
	"GoalAerial":  "res://Sprites/Specialties/img_aerial-reach.png",
	"Tackling":    "res://Sprites/Specialties/img_tackling.png",
	"Passing":     "res://Sprites/Specialties/img_passing.png",
	"Heading":     "res://Sprites/Specialties/img_heading.png",
	"Shooting":    "res://Sprites/Specialties/img_shooting.png",
	"Dribbling":   "res://Sprites/Specialties/img_dribbling.png",
	"Creator":     "res://Sprites/Specialties/img_creator.png",
	"Leader":      "res://Sprites/Specialties/img_leader.png",
	"Fortress":    "res://Sprites/Specialties/img_Fortress.png",
	"Possession":  "res://Sprites/Specialties/img_possession.png",
	"TotalAttack": "res://Sprites/Specialties/img_total_attack.png",
}

# Noms des BTN de spécialité dans la scène (suffixe après BTN_)
const SPECIALTY_BTNS = [
	"GoalReflex","GoalAerial","Tackling","Passing","Heading","Shooting",
	"Dribbling","Creator","Leader","Fortress","Possession","TotalAttack"
]

const CARD_COLORS = {
	"yellow":  Color(1.0, 0.85, 0.0),
	"orange":  Color(1.0, 0.5,  0.0),
	"red":     Color(0.9, 0.1,  0.1),
	"magenta": Color(0.56, 0.016, 0.56),
	"blue":    Color(0.2,  0.5,  1.0),
	"white":   Color(1.0,  1.0,  1.0),
	"special": Color(0.0,  0.8,  0.4),
}

const FORMATION_COSTS = [100,200,300,400,500,600,700,800,900,0,0]
const FORMATION_GAINS = [15,9,8,7,6,5,4,3,2,0,0]
const CLASSIC_MATCHES = [1,1,1,1,2,2,2,2,3,3,2]

const COLOR_GREEN  = Color(0.0,  0.78, 0.22)
const COLOR_BLUE   = Color(0.2,  0.5,  1.0)
const COLOR_ORANGE = Color(1.0,  0.5,  0.0)
const COLOR_RED    = Color(0.9,  0.1,  0.1)
const COLOR_WHITE  = Color(1.0,  1.0,  1.0)

const MAX_NAME_LENGTH          = 10
const SCENE_COLLECTION_COUNTRY = "res://Scenes/collection_country.tscn"

# ── VARIABLES ─────────────────────────────────────────────────────────────────
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
var positioning_val:         int    = 0
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
var manager_position2_stock: int    = 0
var manager_specialty_stock: int    = 0

# ── NŒUDS — GÉNÉRAL ──────────────────────────────────────────────────────────
@onready var btn_close         = $BTN_Close
@onready var btn_help          = $BTN_Help
@onready var lbl_help          = $LBL_Help
@onready var btn_player_future = $BTN_PlayerFuture
@onready var pnl_player_future = $PNL_PlayerFuture
@onready var btn_sign_pro        = $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignPro
@onready var btn_sign_pantheon   = $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignPantheon
@onready var btn_sign_collection = $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignCollection
@onready var btn_sign_eoc        = $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignEndOfCareer
var lbl_player_future: Label = null

# ── NŒUDS — PLAYER ────────────────────────────────────────────────────────────
@onready var player_bg        = $Player/BG_CardBackground
@onready var player_note      = $Player/LBL_Note
@onready var player_pos1      = $Player/LBL_Position1
@onready var player_pos2      = $Player/LBL_Position2
@onready var player_spec1     = $Player/IMG_Specialty1
@onready var player_spec2     = $Player/IMG_Specialty2
@onready var player_flag      = $Player/IMG_Flag
@onready var player_img_ball  = $Player/IMG_BallColor
@onready var player_firstname = $Player/LBL_FirstName
@onready var player_lastname  = $Player/LBL_LastName

# ── NŒUDS — SKILLS ────────────────────────────────────────────────────────────
@onready var skills_bg               = $Skills/BG_CardBackground
@onready var lbl_skills_title        = $Skills/LBL_SkillsTitle
@onready var lbl_strength_label      = $Skills/LBL_StrengthLabel
@onready var lbl_speed_label         = $Skills/LBL_SpeedLabel
@onready var lbl_aggression_label    = $Skills/LBL_AggressionLabel
@onready var lbl_positioning_label   = $Skills/LBL_PositioningLabel
@onready var lbl_stamina_label       = $Skills/LBL_StaminaLabel
@onready var lbl_concentration_label = $Skills/LBL_ConcentrationLabel
@onready var lbl_communication_label = $Skills/LBL_CommunicationLabel
@onready var lbl_motivation_label    = $Skills/LBL_MotivationLabel
@onready var lbl_creativity_label    = $Skills/LBL_CreativityLabel
@onready var lbl_anticipation_label  = $Skills/LBL_AnticipationLabel
@onready var lbl_strength_value      = $Skills/LBL_StrengthValue
@onready var lbl_speed_value         = $Skills/LBL_SpeedValue
@onready var lbl_aggression_value    = $Skills/LBL_AggressionValue
@onready var lbl_positioning_value   = $Skills/LBL_PositioningValue
@onready var lbl_stamina_value       = $Skills/LBL_StaminaValue
@onready var lbl_concentration_value = $Skills/LBL_ConcentrationValue
@onready var lbl_communication_value = $Skills/LBL_CommunicationValue
@onready var lbl_motivation_value    = $Skills/LBL_MotivationValue
@onready var lbl_creativity_value    = $Skills/LBL_CreativityValue
@onready var lbl_anticipation_value  = $Skills/LBL_AnticipationValue

# ── NŒUDS — PHYSICAL ──────────────────────────────────────────────────────────
@onready var physical_bg        = $Physical/BG_CardBackground
@onready var lbl_physical_title = $Physical/LBL_PhysicalTitle
@onready var lbl_age_label      = $Physical/LBL_AgeLabel
@onready var lbl_height_label   = $Physical/LBL_HeightLabel
@onready var lbl_weight_label   = $Physical/LBL_WeightLabel
@onready var lbl_age_value      = $Physical/LBL_AgeValue
@onready var lbl_height_value   = $Physical/LBL_HeightValue
@onready var lbl_weight_value   = $Physical/LBL_WeightValue

# ── NŒUDS — EVOLUTION (chemins corrects avec sous-nœuds intermédiaires) ───────
@onready var evolution_node    = $Evolution
@onready var lbl_rename_player = $Evolution/RenamePlayer/LBL_RenamePlayer
@onready var btn_rename        = $Evolution/RenamePlayer/BTN_RenamePlayer
@onready var inp_firstname     = $Evolution/RenamePlayer/INP_FirstName
@onready var inp_lastname      = $Evolution/RenamePlayer/INP_LastName
@onready var lbl_pos2          = $Evolution/AttributePosition2/LBL_AttributePosition2
@onready var btn_pos2          = $Evolution/AttributePosition2/BTN_AttributePosition2
@onready var pnl_pos2_menu     = $Evolution/AttributePosition2/PNL_AttributePosition2
@onready var lbl_spec1         = $Evolution/AttributeSpecialty1/LBL_AttributeSpecialty1
@onready var btn_spec1         = $Evolution/AttributeSpecialty1/BTN_AttributeSpecialty1
@onready var pnl_spec1_menu    = $Evolution/AttributeSpecialty1/PNL_AttributeSpecialty1
@onready var lbl_spec2         = $Evolution/AttributeSpecialty2/LBL_AttributeSpecialty2
@onready var btn_spec2         = $Evolution/AttributeSpecialty2/BTN_AttributeSpecialty2
@onready var pnl_spec2_menu    = $Evolution/AttributeSpecialty2/PNL_AttributeSpecialty2
@onready var lbl_ball_color    = $Evolution/AttributeBallColor/LBL_AttributeBallColor
@onready var btn_ball_color_menu = $Evolution/AttributeBallColor/BTN_AttributeBallColor
@onready var pnl_ball_menu     = $Evolution/AttributeBallColor/PNL_AttributeBallColor

# ── NŒUDS — ACHIEVEMENTS ──────────────────────────────────────────────────────
@onready var achievements_bg        = $Achievements/BG_CardBackground
@onready var lbl_achievements_title = $Achievements/LBL_AchievementsTitle
@onready var lbl_played_label       = $Achievements/LBL_PlayedLabel
@onready var lbl_wins_label         = $Achievements/LBL_WinsLabel
@onready var lbl_losses_label       = $Achievements/LBL_LossesLabel
@onready var lbl_winrate_label      = $Achievements/LBL_WinRateLabel
@onready var lbl_competitions_label = $Achievements/LBL_CompetitionsPlayedLabel
@onready var lbl_played_value       = $Achievements/LBL_PlayedValue
@onready var lbl_wins_value         = $Achievements/LBL_WinsValue
@onready var lbl_losses_value       = $Achievements/LBL_LossesValue
@onready var lbl_winrate_value      = $Achievements/LBL_WinRateValue
@onready var lbl_competitions_value = $Achievements/LBL_CompetitionsPlayedValue

# ── NŒUDS — TRAINING ──────────────────────────────────────────────────────────
@onready var training_bg          = $Training/BG_CardBackground
@onready var training_formation   = $Training/TrainingFormation
@onready var training_classic     = $Training/TrainingClassic
@onready var lbl_training_f_title = $Training/TrainingFormation/LBL_TrainingTitle
@onready var lbl_training_c_title = $Training/TrainingClassic/LBL_TrainingTitle
@onready var lbl_matches_label    = $Training/TrainingClassic/LBL_MatchesLabel

# ── READY ──────────────────────────────────────────────────────────────────────
func _ready():
	note              = GameState.selected_note
	color             = GameState.selected_color
	position1         = GameState.selected_position1
	position2         = GameState.selected_position2
	position2_unlocked= GameState.selected_position2_unlocked
	age               = GameState.selected_age
	height            = GameState.selected_height
	weight            = GameState.selected_weight
	nationality       = GameState.selected_nationality
	specialty1        = GameState.selected_specialty1
	specialty2        = GameState.selected_specialty2
	firstname         = GameState.selected_firstname
	lastname          = GameState.selected_lastname
	ball_color        = GameState.selected_ball_color
	strength          = GameState.selected_strength
	speed             = GameState.selected_speed
	aggression        = GameState.selected_aggression
	positioning_val   = GameState.selected_positioning
	stamina           = GameState.selected_stamina
	creativity        = GameState.selected_creativity
	concentration     = GameState.selected_concentration
	motivation        = GameState.selected_motivation
	anticipation      = GameState.selected_anticipation
	communication     = GameState.selected_communication
	card_id           = GameState.selected_card_id
	is_formation_card = (color == "white" and age < 18)
	manager_position2_stock = GameState.manager_position2_stock
	manager_specialty_stock = GameState.manager_specialty_stock

	Taskbar.visible           = false
	lbl_help.visible          = false
	pnl_player_future.visible = false
	inp_firstname.visible     = false
	inp_lastname.visible      = false
	pnl_ball_menu.visible     = false
	pnl_pos2_menu.visible     = false
	pnl_spec1_menu.visible    = false
	pnl_spec2_menu.visible    = false

	# Z-index : help et player_future au-dessus de tout
	lbl_help.z_index          = 100
	pnl_player_future.z_index = 100

	# LBL_PlayerFuture optionnel
	lbl_player_future = $PNL_PlayerFuture/CNT_PlayerFuture.get_node_or_null("LBL_PlayerFuture")

	_apply_translations()
	_display_player()
	_display_skills()
	_display_physical()
	_display_evolution()
	_display_achievements()
	_load_training_and_stocks()

	inp_firstname.max_length = MAX_NAME_LENGTH
	inp_lastname.max_length  = MAX_NAME_LENGTH
	inp_firstname.text_submitted.connect(_on_firstname_submitted)
	inp_lastname.text_submitted.connect(_on_lastname_submitted)

# ── TRADUCTIONS (tout en anglais — UI labels) ─────────────────────────────────
func _apply_translations():
	if lbl_player_future:
		lbl_player_future.text = "Warning! The chosen action cannot be undone."
	lbl_help.text                = "Rename: blue, white, and special cards only.\nPosition & Specialty: earned through rewards.\nBall Color: organize your squad using color codes.\nPro Training: +1 every 20 matches (1 match/day).\nFormation: use diamonds to upgrade (1 level/season)."
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
	lbl_played_label.text        = "Played"
	lbl_wins_label.text          = "Wins"
	lbl_losses_label.text        = "Losses"
	lbl_winrate_label.text       = "Win rate %"
	lbl_competitions_label.text  = "Competitions"
	lbl_training_f_title.text    = "FORMATION"
	lbl_training_c_title.text    = "PRO TRAINING"
	lbl_matches_label.text       = "Matches :"
	lbl_rename_player.text       = "Rename player"
	lbl_pos2.text                = "Attribute Position 2"
	lbl_spec1.text               = "Attribute Specialty 1"
	lbl_spec2.text               = "Attribute Specialty 2"
	lbl_ball_color.text          = "Attribute Ball Color"
	_apply_training_formation_texts()

func _apply_training_formation_texts():
	for i in range(1, 12):
		var lbl = training_formation.get_node_or_null("LBL_Round%d" % i)
		if lbl == null: continue
		var idx = i - 1
		if idx < 9:    lbl.text = "+ %d for %d" % [FORMATION_GAINS[idx], FORMATION_COSTS[idx]]
		elif idx == 9: lbl.text = "+ 1 position for"
		else:          lbl.text = "+ 1 specialty for"

# ── PANEL COLOR ───────────────────────────────────────────────────────────────
func _set_panel_color(panel: PanelContainer, c: Color):
	var existing = panel.get_theme_stylebox("panel")
	var style: StyleBoxFlat
	if existing is StyleBoxFlat:
		style = existing.duplicate() as StyleBoxFlat
	else:
		style = StyleBoxFlat.new()
		style.set_corner_radius_all(12)
	style.bg_color = c
	panel.add_theme_stylebox_override("panel", style)

# ── AFFICHAGE PLAYER ──────────────────────────────────────────────────────────
func _display_player():
	if color in CARD_COLORS: _set_panel_color(player_bg, CARD_COLORS[color])
	player_note.text = str(note)
	player_pos1.text = position1
	player_pos2.text    = position2 if position2_unlocked == 1 else ""
	player_pos2.visible = (position2 != "" and position2_unlocked == 1)
	player_firstname.text = firstname
	player_lastname.text  = lastname
	# FIX : taille de police suffisamment grande pour être lisible
	_apply_name_font_size()
	player_spec1.visible = (specialty1 != "")
	player_spec2.visible = (specialty2 != "")
	if specialty1 != "" and specialty1 in SPECIALTY_FILES:
		var p = SPECIALTY_FILES[specialty1]
		if ResourceLoader.exists(p): player_spec1.texture = load(p)
	if specialty2 != "" and specialty2 in SPECIALTY_FILES:
		var p = SPECIALTY_FILES[specialty2]
		if ResourceLoader.exists(p): player_spec2.texture = load(p)
	var fp = "res://Sprites/Flags/flag_" + nationality + ".png"
	if ResourceLoader.exists(fp):
		player_flag.texture = load(fp); player_flag.visible = true
	else:
		player_flag.visible = false
	# Ball color : charge la texture depuis BTN_AttributeBallColor{N}
	# (les BTN Sprite2D ont déjà leur texture chargée dans l'éditeur)
	if ball_color != "" and ball_color != "0":
		var n   = int(ball_color)
		var btn = pnl_ball_menu.get_node_or_null("BTN_AttributeBallColor%d" % n)
		if btn and btn.texture:
			player_img_ball.texture = btn.texture
			player_img_ball.visible = true
		else:
			player_img_ball.visible = false
	else:
		player_img_ball.visible = false

func _apply_name_font_size():
	var max_len = max(firstname.length(), lastname.length())
	# FIX : taille de base augmentée — était trop petite
	var fs = 28
	if max_len > 13:   fs = 18
	elif max_len > 10: fs = 22
	player_firstname.add_theme_font_size_override("font_size", fs)
	player_lastname.add_theme_font_size_override("font_size", fs)

# ── AFFICHAGE SKILLS ──────────────────────────────────────────────────────────
func _display_skills():
	if color in CARD_COLORS: _set_panel_color(skills_bg, CARD_COLORS[color])
	lbl_strength_value.text      = str(strength)
	lbl_speed_value.text         = str(speed)
	lbl_aggression_value.text    = str(aggression)
	lbl_positioning_value.text   = str(positioning_val)
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
	lbl_rename_player.modulate   = Color(1,1,1,1)
	lbl_pos2.modulate            = Color(1,1,1,1)
	lbl_spec1.modulate           = Color(1,1,1,1)
	lbl_spec2.modulate           = Color(1,1,1,1)
	lbl_ball_color.modulate      = Color(1,1,1,1)
	btn_rename.modulate          = COLOR_GREEN if can_rename else COLOR_RED
	btn_pos2.modulate            = COLOR_GREEN if manager_position2_stock > 0 else COLOR_RED
	btn_spec1.modulate           = COLOR_GREEN if manager_specialty_stock > 0 else COLOR_RED
	btn_spec2.modulate           = COLOR_GREEN if manager_specialty_stock > 0 else COLOR_RED
	btn_ball_color_menu.modulate = COLOR_GREEN

# ── AFFICHAGE ACHIEVEMENTS ────────────────────────────────────────────────────
func _display_achievements():
	var played_val = 0; var wins_val = 0; var losses_val = 0
	var winrate_val = 0; var competitions_val = 0
	lbl_played_value.text       = str(played_val)
	lbl_wins_value.text         = str(wins_val)
	lbl_losses_value.text       = str(losses_val)
	lbl_winrate_value.text      = str(winrate_val)
	lbl_competitions_value.text = str(competitions_val)
	if winrate_val >= 75:   _set_panel_color(achievements_bg, COLOR_GREEN)
	elif winrate_val >= 50: _set_panel_color(achievements_bg, COLOR_BLUE)
	elif winrate_val >= 25: _set_panel_color(achievements_bg, COLOR_ORANGE)
	else:                   _set_panel_color(achievements_bg, COLOR_RED)

# ── AFFICHAGE TRAINING ────────────────────────────────────────────────────────
func _display_training():
	if color in CARD_COLORS: _set_panel_color(training_bg, CARD_COLORS[color])
	if is_formation_card:
		training_formation.visible = true;  training_classic.visible = false
		_display_training_formation()
	else:
		training_formation.visible = false; training_classic.visible = true
		_display_training_classic()

func _display_training_formation():
	for i in range(1, 12):
		var lbl = training_formation.get_node_or_null("LBL_Round%d" % i)
		if lbl == null: continue
		var diamond = lbl.get_node_or_null("IMG_Diamond")
		if i <= training_tier:
			lbl.modulate = COLOR_GREEN; if diamond: diamond.modulate = COLOR_GREEN
		else:
			lbl.modulate = COLOR_WHITE; if diamond: diamond.modulate = COLOR_WHITE

func _display_training_classic():
	for i in range(1, 21):
		var lbl = training_classic.get_node_or_null("LBL_Round%d" % i)
		if lbl: lbl.modulate = COLOR_WHITE
	var round_num = 0
	for tier_idx in range(CLASSIC_MATCHES.size()):
		for j in range(CLASSIC_MATCHES[tier_idx]):
			round_num += 1
			var lbl = training_classic.get_node_or_null("LBL_Round%d" % round_num)
			if lbl == null: continue
			if tier_idx < training_tier: lbl.modulate = COLOR_GREEN
			elif tier_idx == training_tier and j < training_matches: lbl.modulate = COLOR_GREEN

# ── FIRESTORE — TRAINING + STOCKS ────────────────────────────────────────────
func _load_training_and_stocks():
	if card_id == "":
		_display_training(); _load_manager_stocks(); return
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
	_load_manager_stocks()

func _on_training_failed(_error: String):
	if Firebase.firestore_success.is_connected(_on_training_loaded):
		Firebase.firestore_success.disconnect(_on_training_loaded)
	if Firebase.firestore_failed.is_connected(_on_training_failed):
		Firebase.firestore_failed.disconnect(_on_training_failed)
	_display_training()
	_load_manager_stocks()

func _load_manager_stocks():
	Firebase.firestore_success.connect(_on_stocks_loaded)
	Firebase.firestore_failed.connect(_on_stocks_failed)
	Firebase.get_document("managers", Firebase.user_id)

func _on_stocks_loaded(data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_stocks_loaded):
		Firebase.firestore_success.disconnect(_on_stocks_loaded)
	if Firebase.firestore_failed.is_connected(_on_stocks_failed):
		Firebase.firestore_failed.disconnect(_on_stocks_failed)
	manager_position2_stock           = int(data.get("position2_stock", 0))
	manager_specialty_stock           = int(data.get("specialty_stock", 0))
	GameState.manager_position2_stock = manager_position2_stock
	GameState.manager_specialty_stock = manager_specialty_stock
	_display_evolution()

func _on_stocks_failed(_error: String):
	if Firebase.firestore_success.is_connected(_on_stocks_loaded):
		Firebase.firestore_success.disconnect(_on_stocks_loaded)
	if Firebase.firestore_failed.is_connected(_on_stocks_failed):
		Firebase.firestore_failed.disconnect(_on_stocks_failed)

# ── SAVE ─────────────────────────────────────────────────────────────────────
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
	_update_gamestate_card()

func _update_gamestate_card():
	var all_arrays = [
		GameState.cards_yellow, GameState.cards_orange, GameState.cards_red,
		GameState.cards_magenta, GameState.cards_blue, GameState.cards_white, GameState.cards_special
	]
	for arr in all_arrays:
		for i in range(arr.size()):
			if arr[i].get("card_id", "") == card_id:
				arr[i]["ball_color"]         = ball_color
				arr[i]["firstname"]          = firstname
				arr[i]["lastname"]           = lastname
				arr[i]["position2_unlocked"] = position2_unlocked
				arr[i]["specialty1"]         = specialty1
				arr[i]["specialty2"]         = specialty2
				return

func _save_manager_stocks():
	Firebase.update_document("managers", Firebase.user_id, {
		"position2_stock": manager_position2_stock,
		"specialty_stock": manager_specialty_stock,
	})
	GameState.manager_position2_stock = manager_position2_stock
	GameState.manager_specialty_stock = manager_specialty_stock

# ── BALL COLOR ────────────────────────────────────────────────────────────────
# BTN_AttributeBallColor1-10 sont des Sprite2D avec leur texture de couleur intégrée
# On ne touche PAS au modulate des BTN — on laisse leurs sprites tels quels
func _apply_ball_color(color_key: String):
	ball_color             = color_key
	ball_menu_open         = false
	pnl_ball_menu.visible  = false
	lbl_ball_color.visible = true
	_display_player()
	_save_card()

func _remove_ball_color():
	ball_color             = ""
	ball_menu_open         = false
	pnl_ball_menu.visible  = false
	lbl_ball_color.visible = true
	_display_player()
	_save_card()

# ── RENAME ────────────────────────────────────────────────────────────────────
func _enter_rename():
	inp_firstname.text    = firstname
	inp_lastname.text     = lastname
	inp_firstname.visible = true
	inp_lastname.visible  = true
	inp_firstname.grab_focus()

func _on_firstname_submitted(text: String):
	firstname             = text.strip_edges().left(MAX_NAME_LENGTH)
	player_firstname.text = firstname
	_apply_name_font_size()
	inp_lastname.grab_focus()

func _on_lastname_submitted(text: String):
	lastname              = text.strip_edges().left(MAX_NAME_LENGTH)
	player_lastname.text  = lastname
	_apply_name_font_size()
	inp_firstname.visible = false
	inp_lastname.visible  = false
	_save_card()

# ── FIN DE CARRIÈRE — suppression définitive ──────────────────────────────────
func _action_sign_end_of_career():
	if card_id == "": return
	# Supprimer de Firestore
	Firebase.delete_document("managers/" + Firebase.user_id + "/cards", card_id)
	# Supprimer de GameState
	_remove_from_gamestate()
	# Retour
	get_tree().change_scene_to_file(GameState.previous_scene)

func _remove_from_gamestate():
	var all_arrays = [
		GameState.cards_yellow, GameState.cards_orange, GameState.cards_red,
		GameState.cards_magenta, GameState.cards_blue, GameState.cards_white, GameState.cards_special
	]
	for arr in all_arrays:
		for i in range(arr.size()):
			if arr[i].get("card_id", "") == card_id:
				arr.remove_at(i); return

# ── COLLECTION ────────────────────────────────────────────────────────────────
func _action_sign_collection():
	if age < 30:
		# TODO : afficher message "Player must be 30+"
		return
	GameState.selected_country       = nationality.to_upper()
	GameState.collection_card_to_add = card_id
	GameState.previous_scene         = "res://Scenes/detail_card_player.tscn"
	get_tree().change_scene_to_file(SCENE_COLLECTION_COUNTRY)

func _action_sign_pro():      pass
func _action_sign_pantheon(): pass

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
	get_tree().change_scene_to_file(GameState.previous_scene)

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	var pos = event.position

	if _sprite_hit(btn_close, pos):       _close(); return
	if _sprite_hit(btn_help, pos):
		lbl_help.visible = not lbl_help.visible
		pnl_player_future.visible = false; return
	if _sprite_hit(btn_player_future, pos):
		pnl_player_future.visible = not pnl_player_future.visible
		lbl_help.visible = false; return
	if lbl_help.visible: lbl_help.visible = false; return

	if pnl_player_future.visible:
		if _button_hit(btn_sign_pro, pos):
			pnl_player_future.visible = false; _action_sign_pro(); return
		if _button_hit(btn_sign_pantheon, pos):
			pnl_player_future.visible = false; _action_sign_pantheon(); return
		if _button_hit(btn_sign_collection, pos):
			pnl_player_future.visible = false; _action_sign_collection(); return
		if _button_hit(btn_sign_eoc, pos):
			pnl_player_future.visible = false; _action_sign_end_of_career(); return
		pnl_player_future.visible = false; return

	# Menu ball color — BTN_AttributeBallColor1-20 Sprite2D déjà texturés
	if ball_menu_open:
		for i in range(1, 21):
			var btn = pnl_ball_menu.get_node_or_null("BTN_AttributeBallColor%d" % i)
			if btn and _sprite_hit(btn, pos):
				_apply_ball_color(str(i)); return
		ball_menu_open = false; pnl_ball_menu.visible = false; lbl_ball_color.visible = true; return

	if _sprite_hit(btn_ball_color_menu, pos):
		if ball_menu_open: _remove_ball_color()
		else:
			ball_menu_open = true; pnl_ball_menu.visible = true; lbl_ball_color.visible = false
		return

	if _sprite_hit(btn_rename, pos):
		if color in ["blue", "white", "special"]: _enter_rename(); return

	if _sprite_hit(btn_pos2, pos):
		if manager_position2_stock > 0:
			pnl_pos2_menu.visible = not pnl_pos2_menu.visible; return

	if _sprite_hit(btn_spec1, pos):
		if manager_specialty_stock > 0:
			pnl_spec1_menu.visible = not pnl_spec1_menu.visible; return

	if _sprite_hit(btn_spec2, pos):
		if manager_specialty_stock > 0:
			pnl_spec2_menu.visible = not pnl_spec2_menu.visible; return

	# Sélection spécialité 1 — BTN_GoalReflex, BTN_Tackling, etc. dans AttributeSpecialty1
	if pnl_spec1_menu.visible:
		var spec1_node = evolution_node.get_node_or_null("AttributeSpecialty1")
		if spec1_node:
			for s in SPECIALTY_BTNS:
				var btn = spec1_node.get_node_or_null("BTN_" + s)
				if btn and _sprite_hit(btn, pos):
					specialty1              = s
					manager_specialty_stock -= 1
					pnl_spec1_menu.visible  = false
					_display_player(); _display_evolution()
					_save_card(); _save_manager_stocks(); return
		if not pnl_spec1_menu.get_global_rect().has_point(pos):
			pnl_spec1_menu.visible = false

	# Sélection spécialité 2 — BTN_GoalReflex, BTN_Tackling, etc. dans AttributeSpecialty2
	if pnl_spec2_menu.visible:
		var spec2_node = evolution_node.get_node_or_null("AttributeSpecialty2")
		if spec2_node:
			for s in SPECIALTY_BTNS:
				var btn = spec2_node.get_node_or_null("BTN_" + s)
				if btn and _sprite_hit(btn, pos):
					specialty2              = s
					manager_specialty_stock -= 1
					pnl_spec2_menu.visible  = false
					_display_player(); _display_evolution()
					_save_card(); _save_manager_stocks(); return
		if not pnl_spec2_menu.get_global_rect().has_point(pos):
			pnl_spec2_menu.visible = false
	if pnl_pos2_menu.visible  and not pnl_pos2_menu.get_global_rect().has_point(pos):
		pnl_pos2_menu.visible  = false
	if pnl_spec1_menu.visible and not pnl_spec1_menu.get_global_rect().has_point(pos):
		pnl_spec1_menu.visible = false
	if pnl_spec2_menu.visible and not pnl_spec2_menu.get_global_rect().has_point(pos):
		pnl_spec2_menu.visible = false

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _button_hit(button: Button, pos: Vector2) -> bool:
	if button == null or not button.visible: return false
	return button.get_global_rect().has_point(pos)
