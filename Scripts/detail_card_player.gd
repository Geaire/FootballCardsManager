extends Node2D

# ── CONSTANTES ────────────────────────────────────────────────────────────────
const PIN_COLORS = {
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

# Correspondance hex → nom couleur
# Nœuds dans la scène : BTN_AttributePin#00CED1, BTN_AttributePin#003366, etc.
const PIN_HEX_TO_KEY = {
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

const FORMATION_COSTS = [100, 200, 300, 400, 500, 600, 700, 800, 900, 0, 0]
const FORMATION_GAINS = [15, 9, 8, 7, 6, 5, 4, 3, 2, 0, 0]
const CLASSIC_MATCHES = [1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 2]

const COLOR_GREEN  = Color(0.0,  0.78, 0.22)
const COLOR_BLUE   = Color(0.2,  0.5,  1.0)
const COLOR_ORANGE = Color(1.0,  0.5,  0.0)
const COLOR_RED    = Color(0.9,  0.1,  0.1)
const COLOR_WHITE  = Color(1.0,  1.0,  1.0)

const MAX_NAME_LENGTH = 10

const TRANSLATIONS = {
	"fr": {
		"popup":         "Renommer : cartes bleues, blanches et speciales uniquement.\nPoste & Specialite : obtenus via les recompenses de competition.\nCouleur Pin : organisez votre effectif par code couleur.\nEntrainement Pro : +1 tous les 20 matchs (1 match valide par jour).\nFormation : utilisez vos diamants pour progresser (1 palier par saison).",
		"rename":        "Renommer",
		"pos2":          "Attribuer Poste 2",
		"spec1":         "Attribuer Specialite 1",
		"spec2":         "Attribuer Specialite 2",
		"pincolor":      "Couleur Pin",
		"skills":        "COMPETENCES",
		"strength":      "Force",           "speed":         "Vitesse",
		"aggression":    "Agressivite",     "positioning":   "Positionnement",
		"stamina":       "Endurance",       "concentration": "Concentration",
		"communication": "Communication",   "motivation":    "Motivation",
		"creativity":    "Creativite",      "anticipation":  "Anticipation",
		"physical":      "PHYSIQUE",
		"age":           "Age",             "height":        "Taille",
		"weight":        "Poids",
		"achievements":  "PALMARES",
		"played":        "Matchs joues",    "wins":          "Victoires",
		"losses":        "Defaites",        "winrate":       "Taux de victoire",
		"competitions":  "Competitions",
		"training_f":    "FORMATION",       "training_c":    "ENTRAINEMENT PRO",
		"matches_label": "Matchs :",
		"for":           "pour",
		"position_tier": "+ 1 poste pour",
		"specialty_tier":"+ 1 specialite pour",
	},
	"en": {
		"popup":         "Rename: blue, white, and special cards only.\nPosition & Specialty: earned through competition rewards.\nPin Color: organize your squad using a color code.\nPro Training: +1 every 20 matches (1 valid match per day).\nFormation: spend diamonds to progress (1 tier per season).",
		"rename":        "Rename",
		"pos2":          "Assign Position 2",
		"spec1":         "Assign Specialty 1",
		"spec2":         "Assign Specialty 2",
		"pincolor":      "Pin Color",
		"skills":        "SKILLS",
		"strength":      "Strength",        "speed":         "Speed",
		"aggression":    "Aggression",      "positioning":   "Positioning",
		"stamina":       "Stamina",         "concentration": "Concentration",
		"communication": "Communication",   "motivation":    "Motivation",
		"creativity":    "Creativity",      "anticipation":  "Anticipation",
		"physical":      "PHYSICAL",
		"age":           "Age",             "height":        "Height",
		"weight":        "Weight",
		"achievements":  "ACHIEVEMENTS",
		"played":        "Matches played",  "wins":          "Wins",
		"losses":        "Losses",          "winrate":       "Win rate",
		"competitions":  "Competitions",
		"training_f":    "FORMATION",       "training_c":    "PRO TRAINING",
		"matches_label": "Matches :",
		"for":           "for",
		"position_tier": "+ 1 position for",
		"specialty_tier":"+ 1 specialty for",
	},
	"es": {
		"popup":         "Renombrar: solo cartas azules, blancas y especiales.\nPosicion y Especialidad: se obtienen con las recompensas de competicion.\nColor Pin: organiza tu plantilla con un codigo de color.\nEntrenamiento Pro: +1 cada 20 partidos (1 partido valido por dia).\nFormacion: gasta diamantes para avanzar (1 nivel por temporada).",
		"rename":        "Renombrar",
		"pos2":          "Asignar Posicion 2",
		"spec1":         "Asignar Especialidad 1",
		"spec2":         "Asignar Especialidad 2",
		"pincolor":      "Color Pin",
		"skills":        "HABILIDADES",
		"strength":      "Fuerza",          "speed":         "Velocidad",
		"aggression":    "Agresividad",     "positioning":   "Posicionamiento",
		"stamina":       "Resistencia",     "concentration": "Concentracion",
		"communication": "Comunicacion",    "motivation":    "Motivacion",
		"creativity":    "Creatividad",     "anticipation":  "Anticipacion",
		"physical":      "FISICO",
		"age":           "Edad",            "height":        "Altura",
		"weight":        "Peso",
		"achievements":  "PALMARES",
		"played":        "Partidos jugados","wins":          "Victorias",
		"losses":        "Derrotas",        "winrate":       "Porcentaje victorias",
		"competitions":  "Competiciones",
		"training_f":    "FORMACION",       "training_c":    "ENTRENAMIENTO PRO",
		"matches_label": "Partidos :",
		"for":           "por",
		"position_tier": "+ 1 posicion por",
		"specialty_tier":"+ 1 especialidad por",
	},
	"de": {
		"popup":         "Umbenennen: nur blaue, weisse und besondere Karten.\nPosition & Spezialitat: werden als Wettbewerbsbelohnungen freigeschaltet.\nPin-Farbe: organisiere dein Team mit einem Farbcode.\nProfi-Training: +1 alle 20 Spiele (1 gultige Partie pro Tag).\nAusbildung: nutze Diamanten zum Aufsteigen (1 Stufe pro Saison).",
		"rename":        "Umbenennen",
		"pos2":          "Position 2 zuweisen",
		"spec1":         "Spezialitat 1 zuweisen",
		"spec2":         "Spezialitat 2 zuweisen",
		"pincolor":      "Pin-Farbe",
		"skills":        "FAHIGKEITEN",
		"strength":      "Starke",           "speed":         "Geschwindigkeit",
		"aggression":    "Aggressivitat",    "positioning":   "Positionierung",
		"stamina":       "Ausdauer",         "concentration": "Konzentration",
		"communication": "Kommunikation",    "motivation":    "Motivation",
		"creativity":    "Kreativitat",      "anticipation":  "Antizipation",
		"physical":      "PHYSISCH",
		"age":           "Alter",            "height":        "Grosse",
		"weight":        "Gewicht",
		"achievements":  "ERFOLGE",
		"played":        "Partien gespielt", "wins":          "Siege",
		"losses":        "Niederlagen",      "winrate":       "Siegquote",
		"competitions":  "Wettbewerbe",
		"training_f":    "AUSBILDUNG",       "training_c":    "PROFI-TRAINING",
		"matches_label": "Spiele :",
		"for":           "fur",
		"position_tier": "+ 1 Position fur",
		"specialty_tier":"+ 1 Spezialitat fur",
	},
	"it": {
		"popup":         "Rinomina: solo carte blu, bianche e speciali.\nPosizione e Specialita: si ottengono con le ricompense di competizione.\nColore Pin: organizza la tua rosa con un codice colore.\nAllenamento Pro: +1 ogni 20 partite (1 partita valida al giorno).\nFormazione: usa i diamanti per progredire (1 livello per stagione).",
		"rename":        "Rinomina",
		"pos2":          "Assegna Posizione 2",
		"spec1":         "Assegna Specialita 1",
		"spec2":         "Assegna Specialita 2",
		"pincolor":      "Colore Pin",
		"skills":        "ABILITA",
		"strength":      "Forza",            "speed":         "Velocita",
		"aggression":    "Aggressivita",     "positioning":   "Posizionamento",
		"stamina":       "Resistenza",       "concentration": "Concentrazione",
		"communication": "Comunicazione",    "motivation":    "Motivazione",
		"creativity":    "Creativita",       "anticipation":  "Anticipazione",
		"physical":      "FISICO",
		"age":           "Eta",              "height":        "Altezza",
		"weight":        "Peso",
		"achievements":  "PALMARES",
		"played":        "Partite giocate",  "wins":          "Vittorie",
		"losses":        "Sconfitte",        "winrate":       "Percentuale vittorie",
		"competitions":  "Competizioni",
		"training_f":    "FORMAZIONE",       "training_c":    "ALLENAMENTO PRO",
		"matches_label": "Partite :",
		"for":           "per",
		"position_tier": "+ 1 posizione per",
		"specialty_tier":"+ 1 specialita per",
	},
	"pt": {
		"popup":         "Renomear: apenas cartas azuis, brancas e especiais.\nPosicao e Especialidade: obtidas atraves das recompensas de competicao.\nCor Pin: organize o seu plantel com um codigo de cor.\nTreino Pro: +1 a cada 20 jogos (1 jogo valido por dia).\nFormacao: gaste diamantes para progredir (1 nivel por epoca).",
		"rename":        "Renomear",
		"pos2":          "Atribuir Posicao 2",
		"spec1":         "Atribuir Especialidade 1",
		"spec2":         "Atribuir Especialidade 2",
		"pincolor":      "Cor Pin",
		"skills":        "HABILIDADES",
		"strength":      "Forca",            "speed":         "Velocidade",
		"aggression":    "Agressividade",    "positioning":   "Posicionamento",
		"stamina":       "Resistencia",      "concentration": "Concentracao",
		"communication": "Comunicacao",      "motivation":    "Motivacao",
		"creativity":    "Criatividade",     "anticipation":  "Antecipacao",
		"physical":      "FISICO",
		"age":           "Idade",            "height":        "Altura",
		"weight":        "Peso",
		"achievements":  "PALMARES",
		"played":        "Jogos disputados", "wins":          "Vitorias",
		"losses":        "Derrotas",         "winrate":       "Taxa de vitorias",
		"competitions":  "Competicoes",
		"training_f":    "FORMACAO",         "training_c":    "TREINO PRO",
		"matches_label": "Jogos :",
		"for":           "para",
		"position_tier": "+ 1 posicao para",
		"specialty_tier":"+ 1 especialidade para",
	},
}

# ── ÉTAT ──────────────────────────────────────────────────────────────────────
var note: int                    = 0
var color: String                = ""
var position1: String            = ""
var position2: String            = ""
var position2_unlocked: int      = 0
var age: int                     = 0
var height: int                  = 0
var weight: int                  = 0
var nationality: String          = ""
var specialty1: String           = ""
var specialty2: String           = ""
var firstname: String            = ""
var lastname: String             = ""
var pin_color: String            = ""
var strength: int                = 0
var speed: int                   = 0
var aggression: int              = 0
var positioning: int             = 0
var stamina: int                 = 0
var creativity: int              = 0
var concentration: int           = 0
var motivation: int              = 0
var anticipation: int            = 0
var communication: int           = 0
var card_id: String              = ""
var training_tier: int           = 0
var training_matches: int        = 0
var is_formation_card: bool      = false
var pin_menu_open: bool          = false
var rename_mode: String          = ""
var manager_position2_stock: int = 0
var manager_specialty_stock: int = 0

# ── NŒUDS — GÉNÉRAL ──────────────────────────────────────────────────────────
@onready var btn_close = $BTN_Close
@onready var btn_help  = $BTN_Help
@onready var txt_popup = $BTN_Help/TXT_Popup

# ── NŒUDS — PLAYER ───────────────────────────────────────────────────────────
@onready var player_bg        = $Player/BG_CardBackground
@onready var player_note      = $Player/TXT_Note
@onready var player_pos1      = $Player/TXT_Position1
@onready var player_pos2      = $Player/TXT_Position2
@onready var player_spec1     = $Player/IMG_Specialty1
@onready var player_spec2     = $Player/IMG_Specialty2
@onready var player_flag      = $Player/IMG_Flag
@onready var player_firstname = $Player/TXT_FirstName
@onready var player_lastname  = $Player/TXT_LastName
@onready var player_soccer    = $Player/IMG_SoccerBall
@onready var player_pincolor  = $Player/BTN_PinColor

# ── NŒUDS — SKILLS ───────────────────────────────────────────────────────────
@onready var skills_bg               = $Skills/BG_CardBackground
@onready var txt_skills_title        = $Skills/TXT_SkillsTitle
@onready var txt_strength_label      = $Skills/TXT_StrengthLabel
@onready var txt_speed_label         = $Skills/TXT_SpeedLabel
@onready var txt_aggression_label    = $Skills/TXT_AggressionLabel
@onready var txt_positioning_label   = $Skills/TXT_PositioningLabel
@onready var txt_stamina_label       = $Skills/TXT_StaminaLabel
@onready var txt_concentration_label = $Skills/TXT_ConcentrationLabel
@onready var txt_communication_label = $Skills/TXT_CommunicationLabel
@onready var txt_motivation_label    = $Skills/TXT_MotivationLabel
@onready var txt_creativity_label    = $Skills/TXT_CreativityLabel
@onready var txt_anticipation_label  = $Skills/TXT_AnticipationLabel
@onready var txt_strength_value      = $Skills/TXT_StrengthValue
@onready var txt_speed_value         = $Skills/TXT_SpeedValue
@onready var txt_aggression_value    = $Skills/TXT_AggressionValue
@onready var txt_positioning_value   = $Skills/TXT_PositioningValue
@onready var txt_stamina_value       = $Skills/TXT_StaminaValue
@onready var txt_concentration_value = $Skills/TXT_ConcentrationValue
@onready var txt_communication_value = $Skills/TXT_CommunicationValue
@onready var txt_motivation_value    = $Skills/TXT_MotivationValue
@onready var txt_creativity_value    = $Skills/TXT_CreativityValue
@onready var txt_anticipation_value  = $Skills/TXT_AnticipationValue

# ── NŒUDS — PHYSICAL ─────────────────────────────────────────────────────────
@onready var physical_bg        = $Physical/BG_CardBackground
@onready var txt_physical_title = $Physical/TXT_PhysicalTitle
@onready var txt_age_label      = $Physical/TXT_AgeLabel
@onready var txt_height_label   = $Physical/TXT_HeightLabel
@onready var txt_weight_label   = $Physical/TXT_WeightLabel
@onready var txt_age_value      = $Physical/TXT_AgeValue
@onready var txt_height_value   = $Physical/TXT_HeightValue
@onready var txt_weight_value   = $Physical/TXT_WeightValue

# ── NŒUDS — EVOLUTION ────────────────────────────────────────────────────────
@onready var txt_rename_label   = $Evolution/TXT_RenamePlayer
@onready var btn_rename         = $Evolution/BTN_RenamePlayer
@onready var lineedit_firstname = $Evolution/LineEdit_FirstName
@onready var lineedit_lastname  = $Evolution/LineEdit_LastName
@onready var txt_pos2_label     = $Evolution/TXT_AttributePosition2
@onready var btn_pos2           = $Evolution/BTN_AttributePosition2
@onready var txt_spec1_label    = $Evolution/TXT_AttributeSpecialty1
@onready var btn_spec1          = $Evolution/BTN_AttributeSpecialty1
@onready var txt_spec2_label    = $Evolution/TXT_AttributeSpecialty2
@onready var btn_spec2          = $Evolution/BTN_AttributeSpecialty2
@onready var txt_pincolor_label = $Evolution/TXT_AttributePinColor
@onready var btn_pincolor_menu  = $Evolution/BTN_AttributePinColor

# ── NŒUDS — ACHIEVEMENTS ─────────────────────────────────────────────────────
@onready var achievements_bg        = $Achievements/BG_CardBackground
@onready var txt_achievements_title = $Achievements/TXT_AchievementsTitle
@onready var txt_played_label       = $Achievements/TXT_PlayedLabel
@onready var txt_wins_label         = $Achievements/TXT_WinsLabel
@onready var txt_losses_label       = $Achievements/TXT_LossesLabel
@onready var txt_winrate_label      = $Achievements/TXT_WinRateLabel
@onready var txt_competitions_label = $Achievements/TXT_CompetitionsPlayedLabel
@onready var txt_played_value       = $Achievements/TXT_PlayedValue
@onready var txt_wins_value         = $Achievements/TXT_WinsValue
@onready var txt_losses_value       = $Achievements/TXT_LossesValue
@onready var txt_winrate_value      = $Achievements/TXT_WinRateValue
@onready var txt_competitions_value = $Achievements/TXT_CompetitionsPlayedValue

# ── NŒUDS — TRAINING ─────────────────────────────────────────────────────────
@onready var training_bg          = $Training/BG_CardBackground
@onready var training_formation   = $Training/TrainingFormation
@onready var training_classic     = $Training/TrainingClassic
@onready var txt_training_f_title = $Training/TrainingFormation/TXT_TrainingTitle
@onready var txt_training_c_title = $Training/TrainingClassic/TXT_TrainingTitle
@onready var txt_matches_label    = $Training/TrainingClassic/TXT_MatchesLabel

# ── READY ─────────────────────────────────────────────────────────────────────
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
	pin_color          = GameState.selected_pin_color
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
	Taskbar.visible = false
	txt_popup.visible          = false
	lineedit_firstname.visible = false
	lineedit_lastname.visible  = false
	_set_pin_menu_visible(false)
	_setup_pin_colors()
	_apply_translations()
	_display_player()
	_display_skills()
	_display_physical()
	_display_evolution()
	_display_achievements()
	_load_training_data()
	lineedit_firstname.text_submitted.connect(_on_firstname_submitted)
	lineedit_lastname.text_submitted.connect(_on_lastname_submitted)

# ── PIN COLOR SETUP ───────────────────────────────────────────────────────────
func _setup_pin_colors():
	for hex in PIN_HEX_TO_KEY:
		var btn = btn_pincolor_menu.get_node_or_null("BTN_AttributePin" + hex)
		if btn: btn.modulate = PIN_COLORS[PIN_HEX_TO_KEY[hex]]

func _set_pin_menu_visible(value: bool):
	for hex in PIN_HEX_TO_KEY:
		var btn = btn_pincolor_menu.get_node_or_null("BTN_AttributePin" + hex)
		if btn: btn.visible = value

# ── TRADUCTIONS ───────────────────────────────────────────────────────────────
func _apply_translations():
	var t = TRANSLATIONS.get(GameState.language, TRANSLATIONS["en"])
	txt_popup.text               = t["popup"]
	txt_rename_label.text        = t["rename"]
	txt_pos2_label.text          = t["pos2"]
	txt_spec1_label.text         = t["spec1"]
	txt_spec2_label.text         = t["spec2"]
	txt_pincolor_label.text      = t["pincolor"]
	txt_skills_title.text        = t["skills"]
	txt_strength_label.text      = t["strength"]
	txt_speed_label.text         = t["speed"]
	txt_aggression_label.text    = t["aggression"]
	txt_positioning_label.text   = t["positioning"]
	txt_stamina_label.text       = t["stamina"]
	txt_concentration_label.text = t["concentration"]
	txt_communication_label.text = t["communication"]
	txt_motivation_label.text    = t["motivation"]
	txt_creativity_label.text    = t["creativity"]
	txt_anticipation_label.text  = t["anticipation"]
	txt_physical_title.text      = t["physical"]
	txt_age_label.text           = t["age"]
	txt_height_label.text        = t["height"]
	txt_weight_label.text        = t["weight"]
	txt_achievements_title.text  = t["achievements"]
	txt_played_label.text        = t["played"]
	txt_wins_label.text          = t["wins"]
	txt_losses_label.text        = t["losses"]
	txt_winrate_label.text       = t["winrate"]
	txt_competitions_label.text  = t["competitions"]
	txt_training_f_title.text    = t["training_f"]
	txt_training_c_title.text    = t["training_c"]
	txt_matches_label.text       = t["matches_label"]
	_apply_training_formation_texts(t)

func _apply_training_formation_texts(t: Dictionary):
	for i in range(1, 12):
		var txt = training_formation.get_node_or_null("TXT_Round%d" % i)
		if txt == null: continue
		var idx = i - 1
		if idx < 9:
			txt.text = "+ %d %s %d" % [FORMATION_GAINS[idx], t["for"], FORMATION_COSTS[idx]]
		elif idx == 9: txt.text = t["position_tier"]
		else:          txt.text = t["specialty_tier"]

# ── AFFICHAGE PLAYER ─────────────────────────────────────────────────────────
func _display_player():
	if color in CARD_COLORS: player_bg.modulate = CARD_COLORS[color]
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
	else: player_flag.visible = false
	# Pin color — invisible par defaut, visible seulement si pin attribuee
	if pin_color != "" and pin_color in PIN_COLORS:
		player_pincolor.modulate = PIN_COLORS[pin_color]
		player_pincolor.z_index  = 5
		player_pincolor.visible  = true
	else:
		player_pincolor.visible  = false
		player_pincolor.z_index  = 3
	player_soccer.z_index = 4

# ── AFFICHAGE SKILLS ─────────────────────────────────────────────────────────
func _display_skills():
	if skills_bg and color in CARD_COLORS: skills_bg.modulate = CARD_COLORS[color]
	txt_strength_value.text      = str(strength)
	txt_speed_value.text         = str(speed)
	txt_aggression_value.text    = str(aggression)
	txt_positioning_value.text   = str(positioning)
	txt_stamina_value.text       = str(stamina)
	txt_concentration_value.text = str(concentration)
	txt_communication_value.text = str(communication)
	txt_motivation_value.text    = str(motivation)
	txt_creativity_value.text    = str(creativity)
	txt_anticipation_value.text  = str(anticipation)

# ── AFFICHAGE PHYSICAL ────────────────────────────────────────────────────────
func _display_physical():
	if physical_bg:
		if age <= 21:   physical_bg.modulate = COLOR_GREEN    # 11-21 ans : jeune talent
		elif age <= 26: physical_bg.modulate = COLOR_BLUE     # 22-26 ans : pleine prime
		elif age <= 31: physical_bg.modulate = COLOR_ORANGE   # 27-31 ans : veteran
		else:           physical_bg.modulate = COLOR_RED      # 32+ ans : fin de carriere
	txt_age_value.text    = str(age)
	txt_height_value.text = str(height)
	txt_weight_value.text = str(weight)

# ── AFFICHAGE EVOLUTION ──────────────────────────────────────────────────────
func _display_evolution():
	var can_rename = color in ["blue", "white", "special"]
	btn_rename.modulate = COLOR_GREEN if can_rename else COLOR_RED
	btn_pos2.modulate   = COLOR_GREEN if manager_position2_stock > 0 else COLOR_RED
	btn_spec1.modulate  = COLOR_GREEN if manager_specialty_stock > 0 else COLOR_RED
	btn_spec2.modulate  = COLOR_GREEN if manager_specialty_stock > 0 else COLOR_RED
	# IMPORTANT : self_modulate et non modulate
	# modulate se propage aux enfants (les 10 boutons pin) et fausse leurs couleurs
	# self_modulate n'affecte que le nœud BTN_AttributePinColor lui-meme
	btn_pincolor_menu.self_modulate = COLOR_GREEN

# ── AFFICHAGE ACHIEVEMENTS ───────────────────────────────────────────────────
func _display_achievements():
	var played_val       = 0
	var wins_val         = 0
	var losses_val       = 0
	var winrate_val      = 0
	var competitions_val = 0
	txt_played_value.text       = str(played_val)
	txt_wins_value.text         = str(wins_val)
	txt_losses_value.text       = str(losses_val)
	txt_winrate_value.text      = str(winrate_val)
	txt_competitions_value.text = str(competitions_val)
	if achievements_bg:
		if winrate_val >= 75:   achievements_bg.modulate = COLOR_GREEN
		elif winrate_val >= 50: achievements_bg.modulate = COLOR_BLUE
		elif winrate_val >= 25: achievements_bg.modulate = COLOR_ORANGE
		else:                   achievements_bg.modulate = COLOR_RED

# ── AFFICHAGE TRAINING ───────────────────────────────────────────────────────
func _display_training():
	# BG Training = couleur de la carte
	if training_bg and color in CARD_COLORS:
		training_bg.modulate = CARD_COLORS[color]
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
		var txt = training_formation.get_node_or_null("TXT_Round%d" % i)
		if txt == null: continue
		var diamond = txt.get_node_or_null("Diamond")
		if i <= training_tier:
			txt.modulate = COLOR_GREEN
			if diamond: diamond.modulate = COLOR_GREEN
		else:
			txt.modulate = COLOR_WHITE
			if diamond: diamond.modulate = COLOR_WHITE

func _display_training_classic():
	# 1. Reset tout en blanc
	for i in range(1, 21):
		var txt = training_classic.get_node_or_null("TXT_Round%d" % i)
		if txt: txt.modulate = COLOR_WHITE
	# 2. Colorer en vert selon la progression
	var round_num = 0
	for tier_idx in range(CLASSIC_MATCHES.size()):
		var needed = CLASSIC_MATCHES[tier_idx]
		for j in range(needed):
			round_num += 1
			var txt = training_classic.get_node_or_null("TXT_Round%d" % round_num)
			if txt == null: continue
			if tier_idx < training_tier:
				txt.modulate = COLOR_GREEN
			elif tier_idx == training_tier and j < training_matches:
				txt.modulate = COLOR_GREEN

# ── FIRESTORE — TRAINING ─────────────────────────────────────────────────────
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
	var d = _find_card_by_id(card_id)
	if d.is_empty(): return
	d["firstname"]          = firstname
	d["lastname"]           = lastname
	d["pin_color"]          = pin_color
	d["position2_unlocked"] = position2_unlocked
	d["specialty1"]         = specialty1
	d["specialty2"]         = specialty2
	d["training_tier"]      = training_tier
	d["training_matches"]   = training_matches
	Firebase.update_document("managers/" + Firebase.user_id + "/cards", card_id, d)

func _find_card_by_id(cid: String) -> Dictionary:
	for arr in [GameState.cards_yellow, GameState.cards_orange, GameState.cards_red,
				GameState.cards_magenta, GameState.cards_blue, GameState.cards_white,
				GameState.cards_special]:
		for d in arr:
			if d.get("card_id", "") == cid: return d
	return {}

# ── PIN COLOR ─────────────────────────────────────────────────────────────────
func _apply_pin(hex: String):
	pin_color     = PIN_HEX_TO_KEY.get(hex, "")
	pin_menu_open = false
	_set_pin_menu_visible(false)
	txt_pincolor_label.visible = true
	_display_player()
	_save_card()

func _remove_pin():
	pin_color     = ""
	pin_menu_open = false
	_set_pin_menu_visible(false)
	txt_pincolor_label.visible = true
	_display_player()
	_save_card()

# ── RENAME ────────────────────────────────────────────────────────────────────
func _enter_rename():
	lineedit_firstname.text    = firstname
	lineedit_lastname.text     = lastname
	lineedit_firstname.visible = true
	lineedit_lastname.visible  = true
	lineedit_firstname.grab_focus()
	rename_mode = "firstname"

func _on_firstname_submitted(text: String):
	firstname             = text.strip_edges().left(MAX_NAME_LENGTH)
	player_firstname.text = firstname
	rename_mode           = "lastname"
	lineedit_lastname.grab_focus()

func _on_lastname_submitted(text: String):
	lastname              = text.strip_edges().left(MAX_NAME_LENGTH)
	player_lastname.text  = lastname
	lineedit_firstname.visible = false
	lineedit_lastname.visible  = false
	rename_mode = ""
	_save_card()

# ── FERMETURE ─────────────────────────────────────────────────────────────────
func _close():
	_save_card()
	if GameState.selected_deco_index == 1:
		GameState.deco1_pin_color = pin_color
		GameState.deco1_firstname = firstname
		GameState.deco1_lastname  = lastname
	elif GameState.selected_deco_index == 2:
		GameState.deco2_pin_color = pin_color
		GameState.deco2_firstname = firstname
		GameState.deco2_lastname  = lastname
	Taskbar.visible = true
	get_tree().change_scene_to_file(GameState.previous_scene)

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	var pos = event.position
	if txt_popup.visible and _label_hit(txt_popup, pos):
		txt_popup.visible = false; return
	if _sprite_hit(btn_help, pos):
		txt_popup.visible = true; return
	if _sprite_hit(btn_close, pos):
		_close(); return
	if pin_menu_open:
		for hex in PIN_HEX_TO_KEY:
			var btn = btn_pincolor_menu.get_node_or_null("BTN_AttributePin" + hex)
			if btn and _sprite_hit(btn, pos):
				_apply_pin(hex); return
		pin_menu_open = false
		_set_pin_menu_visible(false)
		txt_pincolor_label.visible = true
		return
	if _sprite_hit(btn_rename, pos):
		if color in ["blue", "white", "special"]: _enter_rename()
		return
	if _sprite_hit(btn_pos2, pos):
		if manager_position2_stock > 0:
			position2_unlocked = 1
			manager_position2_stock -= 1
			_display_player(); _display_evolution(); _save_card()
		return
	if _sprite_hit(btn_spec1, pos):
		if manager_specialty_stock > 0 and specialty1 == "": pass
		return
	if _sprite_hit(btn_spec2, pos):
		if manager_specialty_stock > 0 and specialty2 == "": pass
		return
	if _sprite_hit(btn_pincolor_menu, pos):
		if pin_menu_open:
			_remove_pin()
		else:
			pin_menu_open = true
			_set_pin_menu_visible(true)
			txt_pincolor_label.visible = false
		return

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _label_hit(label: Label, pos: Vector2) -> bool:
	if label == null or not label.visible: return false
	return label.get_global_rect().has_point(pos)
