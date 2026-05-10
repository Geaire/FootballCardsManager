extends Node2D

# ── CONSTANTES ────────────────────────────────────────────────────────────────
const POSITION2_KEYS  = ["DG","DD","DC","MDF","MG","MD","MC","MO","AG","AD","ATT","AC"]
const SPECIALTY_KEYS  = ["GoalReflex","GoalAerial","Tackling","Passing","Heading",
						  "Shooting","Dribbling","Creator","Leader","Fortress","Possession","TotalAttack"]
const GK_SPECIALTIES  = ["GoalReflex","GoalAerial"]
const BALL_COUNT      = 20
const DRAG_THRESHOLD  = 20.0

const CARD_COLORS = {
	"yellow":  Color(1.0, 0.85, 0.0), "orange":  Color(1.0, 0.5,  0.0),
	"red":     Color(0.9, 0.1,  0.1), "magenta": Color(0.56, 0.016, 0.56),
	"blue":    Color(0.2, 0.5,  1.0), "white":   Color(1.0,  1.0,  1.0),
	"special": Color(0.0, 0.8,  0.4),
}
const FORMATION_COSTS = [100,200,300,400,500,600,700,800,900,0,0]
const FORMATION_GAINS = [15,9,8,7,6,5,4,3,2,0,0]
const CLASSIC_MATCHES = [1,1,1,1,2,2,2,2,3,3,2]

const COLOR_GREEN  = Color(0.0,  0.78, 0.22)
const COLOR_BLUE   = Color(0.2,  0.5,  1.0)
const COLOR_ORANGE = Color(1.0,  0.5,  0.0)
const COLOR_RED    = Color(0.9,  0.1,  0.1)
const COLOR_WHITE  = Color(1.0,  1.0,  1.0)
const COLOR_GRAY   = Color(0.4,  0.4,  0.4, 0.6)

const MAX_NAME_LENGTH = 10
const SCENE_COLLECTION_COUNTRY = "res://Scenes/collection_country.tscn"

# ── VARIABLES CARTE ────────────────────────────────────────────────────────────
var note: int = 0;           var color: String = ""
var position1: String = "";  var position2: String = ""
var position2_unlocked: int = 0
var age: int = 0;            var height: int = 0;     var weight: int = 0
var nationality: String = ""
var specialty1: String = ""; var specialty2: String = ""
var firstname: String = "";  var lastname: String = ""
var ball_color: String = ""
var strength: int = 0;       var speed: int = 0;       var aggression: int = 0
var positioning: int = 0;    var stamina: int = 0;     var creativity: int = 0
var concentration: int = 0;  var motivation: int = 0;  var anticipation: int = 0
var communication: int = 0
var card_id: String = ""
var training_tier: int = 0;  var training_matches: int = 0
var is_formation_card: bool = false

# ── VARIABLES ÉTAT ────────────────────────────────────────────────────────────
var stocks: Dictionary = {}
var open_panel: String = ""        # "", "pos2", "spec1", "spec2", "ball"
var press_pos: Vector2 = Vector2.ZERO
var press_active: bool = false
var drag_active: bool = false
var drag_type: String = ""         # "pos2", "spec1", "spec2"
var drag_key: String = ""
var drag_visual: Node = null

# ── NŒUDS — GÉNÉRAL ──────────────────────────────────────────────────────────
@onready var btn_close           = $BTN_Close
@onready var btn_help            = $BTN_Help
@onready var lbl_help            = $LBL_Help
@onready var btn_player_future   = $BTN_PlayerFuture
@onready var pnl_player_future   = $PNL_PlayerFuture
@onready var btn_sign_pro        = $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignPro
@onready var btn_sign_pantheon   = $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignPantheon
@onready var btn_sign_collection = $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignCollection
@onready var btn_sign_eoc        = $PNL_PlayerFuture/CNT_PlayerFuture/BTN_SignEndOfCareer

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

# ── NŒUDS — EVOLUTION RENAME ──────────────────────────────────────────────────
@onready var btn_rename   = $Evolution/RenamePlayer/BTN_RenamePlayer
@onready var lbl_rename   = $Evolution/RenamePlayer/LBL_RenamePlayer
@onready var inp_firstname = $Evolution/RenamePlayer/INP_FirstName
@onready var inp_lastname  = $Evolution/RenamePlayer/INP_LastName

# ── NŒUDS — EVOLUTION POSITION2 ───────────────────────────────────────────────
@onready var pos2_node     = $Evolution/AttributePosition2
@onready var btn_attr_pos2 = $Evolution/AttributePosition2/BTN_AttributePosition2
@onready var pnl_attr_pos2 = $Evolution/AttributePosition2/PNL_AttributePosition2

# ── NŒUDS — EVOLUTION SPECIALTY1 ─────────────────────────────────────────────
@onready var spec1_node     = $Evolution/AttributeSpecialty1
@onready var btn_attr_spec1 = $Evolution/AttributeSpecialty1/BTN_AttributeSpecialty1
@onready var pnl_attr_spec1 = $Evolution/AttributeSpecialty1/PNL_AttributeSpecialty1

# ── NŒUDS — EVOLUTION SPECIALTY2 ─────────────────────────────────────────────
@onready var spec2_node     = $Evolution/AttributeSpecialty2
@onready var btn_attr_spec2 = $Evolution/AttributeSpecialty2/BTN_AttributeSpecialty2
@onready var pnl_attr_spec2 = $Evolution/AttributeSpecialty2/PNL_AttributeSpecialty2

# ── NŒUDS — EVOLUTION BALL COLOR ─────────────────────────────────────────────
@onready var btn_attr_ball = $Evolution/AttributeBallColor/BTN_AttributeBallColor
@onready var pnl_attr_ball = $Evolution/AttributeBallColor/PNL_AttributeBallColor

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

# ── HELPERS NŒUDS DYNAMIQUES ──────────────────────────────────────────────────
func _pos2_lbl(k: String) -> Label:    return pos2_node.get_node_or_null("LBL_" + k)
func _pos2_ctr(k: String) -> Label:    return pos2_node.get_node_or_null("LBL_Counter" + k)
func _spec_btn(n: Node2D, k: String) -> Sprite2D: return n.get_node_or_null("BTN_" + k)
func _spec_ctr(n: Node2D, k: String) -> Label:    return n.get_node_or_null("LBL_" + k + "Counter")
func _spec_nml(n: Node2D, k: String) -> Label:    return n.get_node_or_null("LBL_" + k + "Name")
func _ball_btn(i: int) -> Sprite2D:   return pnl_attr_ball.get_node_or_null("BTN_AttributeBallColor%d" % i)

# ── READY ──────────────────────────────────────────────────────────────────────
func _ready():
	# 1. Couleur immédiatement (anti-flash blanc)
	color = GameState.selected_color
	if color in CARD_COLORS: _set_panel_color(player_bg, CARD_COLORS[color])

	# 2. Données carte
	note               = GameState.selected_note
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
	strength           = GameState.selected_strength;      speed          = GameState.selected_speed
	aggression         = GameState.selected_aggression;    positioning    = GameState.selected_positioning
	stamina            = GameState.selected_stamina;       creativity     = GameState.selected_creativity
	concentration      = GameState.selected_concentration; motivation     = GameState.selected_motivation
	anticipation       = GameState.selected_anticipation;  communication  = GameState.selected_communication
	card_id            = GameState.selected_card_id
	is_formation_card  = (color == "white" and age < 18)

	# 3. État UI initial
	Taskbar.visible           = false
	lbl_help.visible          = false
	pnl_player_future.visible = false
	inp_firstname.visible     = false
	inp_lastname.visible      = false
	_close_all_panels()

	# 4. Cache textures Figma dans GameState
	_cache_textures()

	# 5. Affichage statique
	_display_labels()
	_display_player()
	_display_skills()
	_display_physical()
	_display_achievements()

	# 6. Chargement asynchrone (training → stocks)
	_load_training_data()

	inp_firstname.text_submitted.connect(_on_firstname_submitted)
	inp_lastname.text_submitted.connect(_on_lastname_submitted)

# ── CACHE TEXTURES ────────────────────────────────────────────────────────────
func _cache_textures():
	# Ball colors 1..20 depuis PNL_AttributeBallColor
	for i in range(1, BALL_COUNT + 1):
		var key = "ball_%d" % i
		if GameState.ball_textures.has(key): continue
		var btn = _ball_btn(i)
		if btn and btn.texture: GameState.ball_textures[key] = btn.texture

	# Spécialités depuis spec1_node (mêmes textures que spec2_node)
	for k in SPECIALTY_KEYS:
		if GameState.specialty_textures.has(k): continue
		var btn = _spec_btn(spec1_node, k)
		if btn and btn.texture: GameState.specialty_textures[k] = btn.texture

# ── PANELS OPEN/CLOSE ─────────────────────────────────────────────────────────
func _close_all_panels():
	open_panel = ""
	pnl_attr_pos2.visible  = false
	pnl_attr_spec1.visible = false
	pnl_attr_spec2.visible = false
	pnl_attr_ball.visible  = false
	for k in POSITION2_KEYS:
		var l = _pos2_lbl(k); var c = _pos2_ctr(k)
		if l: l.visible = false
		if c: c.visible = false
	for k in SPECIALTY_KEYS:
		for n in [spec1_node, spec2_node]:
			var b = _spec_btn(n, k); var c = _spec_ctr(n, k); var nl = _spec_nml(n, k)
			if b: b.visible = false
			if c: c.visible = false
			if nl: nl.visible = false

func _open_panel(panel: String):
	open_panel = panel
	match panel:
		"pos2":
			pnl_attr_pos2.visible = true
			for k in POSITION2_KEYS:
				var l = _pos2_lbl(k); var c = _pos2_ctr(k)
				if l: l.visible = true
				if c: c.visible = true
		"spec1":
			pnl_attr_spec1.visible = true
			_show_spec_elements(spec1_node)
		"spec2":
			pnl_attr_spec2.visible = true
			_show_spec_elements(spec2_node)
		"ball":
			pnl_attr_ball.visible = true

func _show_spec_elements(node: Node2D):
	for k in SPECIALTY_KEYS:
		var b = _spec_btn(node, k); var c = _spec_ctr(node, k); var nl = _spec_nml(node, k)
		if b: b.visible = true
		if c: c.visible = true
		if nl: nl.visible = true

func _toggle_panel(panel: String):
	if open_panel == panel: _close_all_panels()
	else: _close_all_panels(); _open_panel(panel)

# ── AFFICHAGE LABELS STATIQUES ────────────────────────────────────────────────
func _display_labels():
	lbl_skills_title.text        = "SKILLS"
	lbl_strength_label.text      = "Strength";     lbl_speed_label.text         = "Speed"
	lbl_aggression_label.text    = "Aggression";   lbl_positioning_label.text   = "Positioning"
	lbl_stamina_label.text       = "Stamina";      lbl_concentration_label.text = "Concentration"
	lbl_communication_label.text = "Communication";lbl_motivation_label.text    = "Motivation"
	lbl_creativity_label.text    = "Creativity";   lbl_anticipation_label.text  = "Anticipation"
	lbl_physical_title.text      = "PHYSICAL"
	lbl_age_label.text           = "Age";          lbl_height_label.text        = "Height"
	lbl_weight_label.text        = "Weight"
	lbl_achievements_title.text  = "ACHIEVEMENTS"
	lbl_played_label.text        = "Played";       lbl_wins_label.text          = "Wins"
	lbl_losses_label.text        = "Losses";       lbl_winrate_label.text       = "Win rate %"
	lbl_competitions_label.text  = "Competitions played"
	lbl_training_f_title.text    = "FORMATION";    lbl_training_c_title.text    = "PRO TRAINING"
	lbl_matches_label.text       = "Matches :"
	lbl_rename.text              = "Rename player"
	# Labels postes traduits dans les panels (visible dans le panel ouvert)
	for k in POSITION2_KEYS:
		var l = _pos2_lbl(k)
		if l: l.text = GameState.get_pos_label(k)
	# Noms spécialités (LBL_*Name) restent en anglais tels quels (déjà définis dans l'éditeur)

# ── AFFICHAGE PLAYER ──────────────────────────────────────────────────────────
func _display_player():
	if color in CARD_COLORS: _set_panel_color(player_bg, CARD_COLORS[color])
	player_note.text      = str(note)
	player_pos1.text      = GameState.get_pos_label(position1)
	player_pos2.text      = GameState.get_pos_label(position2) if position2 != "" else ""
	player_pos2.visible   = (position2 != "" and position2_unlocked == 1)
	player_firstname.text = firstname;   player_lastname.text = lastname
	player_spec1.visible  = (specialty1 != "")
	player_spec2.visible  = (specialty2 != "")
	if specialty1 != "":
		var t = GameState.specialty_textures.get(specialty1, null)
		if t: player_spec1.texture = t
	if specialty2 != "":
		var t = GameState.specialty_textures.get(specialty2, null)
		if t: player_spec2.texture = t
	var fp = "res://Sprites/Flags/flag_" + nationality + ".png"
	if ResourceLoader.exists(fp): player_flag.texture = load(fp); player_flag.visible = true
	else: player_flag.visible = false
	_display_ball_sprite()

func _display_ball_sprite():
	if ball_color == "": player_img_ball.visible = false; return
	var t = GameState.ball_textures.get(ball_color, null)
	if t: player_img_ball.texture = t; player_img_ball.visible = true
	else: player_img_ball.visible = false

# ── AFFICHAGE SKILLS ──────────────────────────────────────────────────────────
func _display_skills():
	if color in CARD_COLORS: _set_panel_color(skills_bg, CARD_COLORS[color])
	lbl_strength_value.text      = str(strength);      lbl_speed_value.text         = str(speed)
	lbl_aggression_value.text    = str(aggression);    lbl_positioning_value.text   = str(positioning)
	lbl_stamina_value.text       = str(stamina);       lbl_concentration_value.text = str(concentration)
	lbl_communication_value.text = str(communication); lbl_motivation_value.text    = str(motivation)
	lbl_creativity_value.text    = str(creativity);    lbl_anticipation_value.text  = str(anticipation)

# ── AFFICHAGE PHYSICAL ────────────────────────────────────────────────────────
func _display_physical():
	if age <= 21:   _set_panel_color(physical_bg, COLOR_GREEN)
	elif age <= 26: _set_panel_color(physical_bg, COLOR_BLUE)
	elif age <= 31: _set_panel_color(physical_bg, COLOR_ORANGE)
	else:           _set_panel_color(physical_bg, COLOR_RED)
	lbl_age_value.text    = str(age)
	lbl_height_value.text = str(height)
	lbl_weight_value.text = str(weight)

# ── AFFICHAGE ACHIEVEMENTS ────────────────────────────────────────────────────
func _display_achievements():
	lbl_played_value.text = "0"; lbl_wins_value.text = "0"; lbl_losses_value.text = "0"
	lbl_winrate_value.text = "0"; lbl_competitions_value.text = "0"
	_set_panel_color(achievements_bg, COLOR_RED)

# ── AFFICHAGE TRAINING ────────────────────────────────────────────────────────
func _display_training():
	if color in CARD_COLORS: _set_panel_color(training_bg, CARD_COLORS[color])
	if is_formation_card:
		training_formation.visible = true;  training_classic.visible = false
		_display_training_formation()
	else:
		training_formation.visible = false; training_classic.visible = true
		_display_training_classic()
	# Labels formation
	for i in range(1, 12):
		var lbl = training_formation.get_node_or_null("LBL_Round%d" % i)
		if lbl == null: continue
		var idx = i - 1
		if idx < 9:    lbl.text = "+ %d for %d" % [FORMATION_GAINS[idx], FORMATION_COSTS[idx]]
		elif idx == 9: lbl.text = "+ 1 position for"
		else:          lbl.text = "+ 1 specialty for"

func _display_training_formation():
	for i in range(1, 12):
		var lbl = training_formation.get_node_or_null("LBL_Round%d" % i)
		if lbl == null: continue
		var d = lbl.get_node_or_null("IMG_Diamond")
		lbl.modulate = COLOR_GREEN if i <= training_tier else COLOR_WHITE
		if d: d.modulate = lbl.modulate

func _display_training_classic():
	for i in range(1, 21):
		var lbl = training_classic.get_node_or_null("LBL_Round%d" % i)
		if lbl: lbl.modulate = COLOR_WHITE
	var rn = 0
	for ti in range(CLASSIC_MATCHES.size()):
		for j in range(CLASSIC_MATCHES[ti]):
			rn += 1
			var lbl = training_classic.get_node_or_null("LBL_Round%d" % rn)
			if lbl == null: continue
			if ti < training_tier or (ti == training_tier and j < training_matches):
				lbl.modulate = COLOR_GREEN

# ── GRISAGE PANELS ────────────────────────────────────────────────────────────
func _update_pos2_display():
	for k in POSITION2_KEYS:
		var l = _pos2_lbl(k); var c = _pos2_ctr(k)
		if l == null: continue
		var count  = stocks.get(k, 0)
		var grayed = (count == 0 or k == position1)
		var mod    = COLOR_GRAY if grayed else Color(1,1,1,1)
		l.modulate = mod
		if c: c.text = str(count).lpad(3,"0"); c.modulate = mod

func _update_spec_display(node: Node2D, cur: String, other: String):
	var is_gk = (position1 == "GB")
	for k in SPECIALTY_KEYS:
		var b = _spec_btn(node, k); var c = _spec_ctr(node, k); var nl = _spec_nml(node, k)
		if b == null: continue
		var count    = stocks.get(k, 0)
		var is_gk_sp = k in GK_SPECIALTIES
		var wrong    = (is_gk and not is_gk_sp) or (not is_gk and is_gk_sp)
		var grayed   = count == 0 or wrong or k == cur or k == other
		var mod      = COLOR_GRAY if grayed else Color(1,1,1,1)
		b.modulate = mod
		if c: c.text = str(count).lpad(3,"0"); c.modulate = mod
		if nl: nl.modulate = mod

# ── DRAG & DROP — DÉTECTION ───────────────────────────────────────────────────
func _identify_draggable(pos: Vector2) -> bool:
	drag_type = ""; drag_key = ""
	if open_panel == "pos2":
		for k in POSITION2_KEYS:
			var l = _pos2_lbl(k)
			if l and l.visible and _label_hit(l, pos):
				if stocks.get(k, 0) > 0 and k != position1:
					drag_type = "pos2"; drag_key = k; return true
	elif open_panel == "spec1":
		for k in SPECIALTY_KEYS:
			var b = _spec_btn(spec1_node, k)
			if b and b.visible and _sprite_hit(b, pos):
				var is_gk = position1 == "GB"; var is_gk_sp = k in GK_SPECIALTIES
				var wrong = (is_gk and not is_gk_sp) or (not is_gk and is_gk_sp)
				if stocks.get(k, 0) > 0 and not wrong and k != specialty1:
					drag_type = "spec1"; drag_key = k; return true
	elif open_panel == "spec2":
		for k in SPECIALTY_KEYS:
			var b = _spec_btn(spec2_node, k)
			if b and b.visible and _sprite_hit(b, pos):
				var is_gk = position1 == "GB"; var is_gk_sp = k in GK_SPECIALTIES
				var wrong = (is_gk and not is_gk_sp) or (not is_gk and is_gk_sp)
				if stocks.get(k, 0) > 0 and not wrong and k != specialty2 and k != specialty1:
					drag_type = "spec2"; drag_key = k; return true
	return false

func _create_drag_visual(pos: Vector2):
	match drag_type:
		"pos2":
			var lbl = Label.new()
			lbl.text = GameState.get_pos_label(drag_key)
			lbl.add_theme_font_size_override("font_size", 42)
			lbl.add_theme_color_override("font_color", Color.WHITE)
			add_child(lbl)
			drag_visual = lbl
		"spec1", "spec2":
			var src = spec1_node if drag_type == "spec1" else spec2_node
			var btn = _spec_btn(src, drag_key)
			if btn:
				var spr = Sprite2D.new()
				spr.texture = btn.texture
				spr.scale   = btn.scale * 0.8
				add_child(spr)
				drag_visual = spr
	if drag_visual:
		drag_visual.z_index = 200
		if drag_visual is Label: drag_visual.global_position = pos - Vector2(40, 25)
		else:                    drag_visual.global_position = pos

func _try_drop(pos: Vector2):
	if player_bg.get_global_rect().has_point(pos):
		match drag_type:
			"pos2":  _apply_position2(drag_key)
			"spec1": _apply_specialty1(drag_key)
			"spec2": _apply_specialty2(drag_key)

# ── APPLY ACTIONS ─────────────────────────────────────────────────────────────
func _apply_position2(key: String):
	if position2 != "" and position2 != key:
		stocks[position2] = stocks.get(position2, 0) + 1
	position2 = key; position2_unlocked = 1
	stocks[key] = max(0, stocks.get(key, 0) - 1)
	player_pos2.text    = GameState.get_pos_label(position2)
	player_pos2.visible = true
	_update_pos2_display()
	_save_card(); _save_stocks(); _close_all_panels()

func _apply_specialty1(key: String):
	if specialty1 != "" and specialty1 != key:
		stocks[specialty1] = stocks.get(specialty1, 0) + 1
	specialty1 = key
	stocks[key] = max(0, stocks.get(key, 0) - 1)
	var t = GameState.specialty_textures.get(key, null)
	if t: player_spec1.texture = t; player_spec1.visible = true
	_update_spec_display(spec1_node, specialty1, specialty2)
	_update_spec_display(spec2_node, specialty2, specialty1)
	_save_card(); _save_stocks(); _close_all_panels()

func _apply_specialty2(key: String):
	if specialty2 != "" and specialty2 != key:
		stocks[specialty2] = stocks.get(specialty2, 0) + 1
	specialty2 = key
	stocks[key] = max(0, stocks.get(key, 0) - 1)
	var t = GameState.specialty_textures.get(key, null)
	if t: player_spec2.texture = t; player_spec2.visible = true
	_update_spec_display(spec1_node, specialty1, specialty2)
	_update_spec_display(spec2_node, specialty2, specialty1)
	_save_card(); _save_stocks(); _close_all_panels()

func _apply_ball_color(index: int):
	ball_color = "ball_%d" % index
	GameState.selected_ball_color = ball_color
	var t = GameState.ball_textures.get(ball_color, null)
	if t: player_img_ball.texture = t; player_img_ball.visible = true
	_save_card(); _close_all_panels()

# ── RENAME ────────────────────────────────────────────────────────────────────
func _enter_rename():
	inp_firstname.text = firstname; inp_lastname.text = lastname
	inp_firstname.visible = true;   inp_lastname.visible = true
	inp_firstname.grab_focus()

func _on_firstname_submitted(text: String):
	firstname = text.strip_edges().left(MAX_NAME_LENGTH)
	player_firstname.text = firstname; inp_lastname.grab_focus()

func _on_lastname_submitted(text: String):
	lastname = text.strip_edges().left(MAX_NAME_LENGTH)
	player_lastname.text = lastname
	inp_firstname.visible = false; inp_lastname.visible = false; _save_card()

# ── SAVE ──────────────────────────────────────────────────────────────────────
func _save_card():
	if card_id == "": return
	SquadLoader.update_card({
		"card_id": card_id, "note": note, "color": color,
		"position1": position1, "position2": position2,
		"position2_unlocked": position2_unlocked,
		"age": age, "height": height, "weight": weight,
		"nationality": nationality, "specialty1": specialty1, "specialty2": specialty2,
		"firstname": firstname, "lastname": lastname, "ball_color": ball_color,
		"strength": strength, "speed": speed, "aggression": aggression,
		"positioning": positioning, "stamina": stamina, "creativity": creativity,
		"concentration": concentration, "motivation": motivation,
		"anticipation": anticipation, "communication": communication,
		"training_tier": training_tier, "training_matches": training_matches,
	})

func _save_stocks():
	GameState.stocks = stocks.duplicate()
	Firebase.update_document("managers/" + Firebase.user_id + "/stocks", "inventory", stocks)

# ── TRAINING FIRESTORE ────────────────────────────────────────────────────────
func _load_training_data():
	if card_id == "": _display_training(); _load_stocks(); return
	Firebase.firestore_success.connect(_on_training_loaded)
	Firebase.firestore_failed.connect(_on_training_failed)
	Firebase.get_document("managers/" + Firebase.user_id + "/cards", card_id)

func _on_training_loaded(data: Dictionary):
	_disconnect_training()
	training_tier = int(data.get("training_tier", 0))
	training_matches = int(data.get("training_matches", 0))
	_display_training(); _load_stocks()

func _on_training_failed(_err: String):
	_disconnect_training(); _display_training(); _load_stocks()

func _disconnect_training():
	if Firebase.firestore_success.is_connected(_on_training_loaded):
		Firebase.firestore_success.disconnect(_on_training_loaded)
	if Firebase.firestore_failed.is_connected(_on_training_failed):
		Firebase.firestore_failed.disconnect(_on_training_failed)

# ── STOCKS FIRESTORE ──────────────────────────────────────────────────────────
func _load_stocks():
	if GameState.stocks_loaded:
		stocks = GameState.stocks.duplicate()
		_update_pos2_display()
		_update_spec_display(spec1_node, specialty1, specialty2)
		_update_spec_display(spec2_node, specialty2, specialty1)
		return
	Firebase.firestore_success.connect(_on_stocks_loaded)
	Firebase.firestore_failed.connect(_on_stocks_failed)
	Firebase.get_document("managers/" + Firebase.user_id + "/stocks", "inventory")

func _on_stocks_loaded(data: Dictionary):
	_disconnect_stocks()
	stocks = data.duplicate()
	GameState.stocks = stocks.duplicate(); GameState.stocks_loaded = true
	_update_pos2_display()
	_update_spec_display(spec1_node, specialty1, specialty2)
	_update_spec_display(spec2_node, specialty2, specialty1)

func _on_stocks_failed(_err: String):
	_disconnect_stocks(); stocks = {}
	_update_pos2_display()
	_update_spec_display(spec1_node, specialty1, specialty2)
	_update_spec_display(spec2_node, specialty2, specialty1)

func _disconnect_stocks():
	if Firebase.firestore_success.is_connected(_on_stocks_loaded):
		Firebase.firestore_success.disconnect(_on_stocks_loaded)
	if Firebase.firestore_failed.is_connected(_on_stocks_failed):
		Firebase.firestore_failed.disconnect(_on_stocks_failed)

# ── FERMETURE ─────────────────────────────────────────────────────────────────
func _action_sign_collection():
	GameState.selected_country       = nationality.to_upper()
	GameState.previous_scene         = "res://Scenes/detail_card_player.tscn"
	GameState.collection_card_to_add = card_id
	get_tree().change_scene_to_file(SCENE_COLLECTION_COUNTRY)

func _close():
	_save_card()
	GameState.selected_ball_color = ball_color
	GameState.selected_specialty1 = specialty1
	GameState.selected_specialty2 = specialty2
	GameState.selected_position2  = position2
	GameState.selected_position2_unlocked = position2_unlocked
	if GameState.selected_deco_index == 1:
		GameState.deco1_ball_color         = ball_color
		GameState.deco1_specialty1         = specialty1
		GameState.deco1_specialty2         = specialty2
		GameState.deco1_firstname          = firstname
		GameState.deco1_lastname           = lastname
	elif GameState.selected_deco_index == 2:
		GameState.deco2_ball_color         = ball_color
		GameState.deco2_specialty1         = specialty1
		GameState.deco2_specialty2         = specialty2
		GameState.deco2_firstname          = firstname
		GameState.deco2_lastname           = lastname
	get_tree().change_scene_to_file(GameState.previous_scene)

# ── PANEL COLOR ───────────────────────────────────────────────────────────────
func _set_panel_color(panel: PanelContainer, c: Color):
	var style = StyleBoxFlat.new()
	style.bg_color = c
	panel.add_theme_stylebox_override("panel", style)

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	# Mouse (test PC)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed: _on_press(event.position)
		else:             _on_release(event.position)
	elif event is InputEventMouseMotion:
		_on_move(event.position)
	# Touch (mobile)
	elif event is InputEventScreenTouch:
		if event.pressed: _on_press(event.position)
		else:             _on_release(event.position)
	elif event is InputEventScreenDrag:
		_on_move(event.position)

func _on_press(pos: Vector2):
	press_pos    = pos
	press_active = true
	_identify_draggable(pos)   # stocke drag_type / drag_key si applicable

func _on_move(pos: Vector2):
	if press_active and not drag_active:
		if drag_type != "" and pos.distance_to(press_pos) > DRAG_THRESHOLD:
			drag_active = true
			_create_drag_visual(pos)
	if drag_active and drag_visual:
		if drag_visual is Label: drag_visual.global_position = pos - Vector2(40, 25)
		else:                    drag_visual.global_position = pos

func _on_release(pos: Vector2):
	press_active = false
	if drag_active:
		_try_drop(pos)
		drag_active = false; drag_type = ""; drag_key = ""
		if drag_visual: drag_visual.queue_free(); drag_visual = null
	else:
		_handle_tap(pos)

func _handle_tap(pos: Vector2):
	# Contrôles généraux
	if _sprite_hit(btn_close, pos): _close(); return
	if _sprite_hit(btn_help, pos):
		lbl_help.visible = not lbl_help.visible
		pnl_player_future.visible = false; return
	if lbl_help.visible: lbl_help.visible = false; return
	if _sprite_hit(btn_player_future, pos):
		pnl_player_future.visible = not pnl_player_future.visible; return
	if pnl_player_future.visible:
		if _sprite_hit(btn_sign_pro, pos):        pnl_player_future.visible = false; return
		if _sprite_hit(btn_sign_pantheon, pos):   pnl_player_future.visible = false; return
		if _sprite_hit(btn_sign_collection, pos): pnl_player_future.visible = false; _action_sign_collection(); return
		if _sprite_hit(btn_sign_eoc, pos):        pnl_player_future.visible = false; return
		pnl_player_future.visible = false; return

	# Boutons Evolution — toggle panels
	if _sprite_hit(btn_attr_pos2, pos):  _toggle_panel("pos2");  return
	if _sprite_hit(btn_attr_spec1, pos): _toggle_panel("spec1"); return
	if _sprite_hit(btn_attr_spec2, pos): _toggle_panel("spec2"); return
	if _sprite_hit(btn_attr_ball, pos):  _toggle_panel("ball");  return

	# Sélection ball color (clic dans le panel ouvert)
	if open_panel == "ball":
		for i in range(1, BALL_COUNT + 1):
			var b = _ball_btn(i)
			if b and _sprite_hit(b, pos): _apply_ball_color(i); return
		_close_all_panels(); return

	# Clic hors du panel ouvert → fermer
	if open_panel != "":
		var pnl_rect: Rect2
		match open_panel:
			"pos2":  pnl_rect = pnl_attr_pos2.get_global_rect()
			"spec1": pnl_rect = pnl_attr_spec1.get_global_rect()
			"spec2": pnl_rect = pnl_attr_spec2.get_global_rect()
			"ball":  pnl_rect = pnl_attr_ball.get_global_rect()
		if not pnl_rect.has_point(pos): _close_all_panels(); return

	# Rename (cartes bleues, blanches, spéciales uniquement)
	if _sprite_hit(btn_rename, pos):
		if color in ["blue", "white", "special"]: _enter_rename()
		return

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _label_hit(label: Label, pos: Vector2) -> bool:
	if label == null or not label.visible: return false
	return label.get_global_rect().has_point(pos)
