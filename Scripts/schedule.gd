extends Node2D

# ── FEATUREBASE ───────────────────────────────────────────────────────────────
const FEATUREBASE_URL = "https://fcm.featurebase.app"

# ── COULEURS COMPÉTITIONS ─────────────────────────────────────────────────────
const COMP_COLORS = {
	"championnat_classique": Color(0.0,   0.200, 0.400),
	"coupe_classique":       Color(0.0,   0.808, 0.820),
	"championnat_pantheon":  Color(0.416, 0.051, 0.678),
	"coupe_pantheon":        Color(1.0,   0.412, 0.706),
	"championnat_jeunes":    Color(0.545, 0.271, 0.075),
	"coupe_jeunes":          Color(0.722, 0.722, 0.722),
	"championnat_asso":      Color(0.502, 0.0,   0.125),
	"coupe_asso":            Color(1.0,   0.420, 0.420),
	"championnat_special":   Color(0.176, 0.416, 0.310),
	"autre":                 Color(0.584, 0.835, 0.698),
}

# ── CATALOGUE SEMAINE — 7 compétitions de test ────────────────────────────────
const WEEKLY_CATALOGUE = [
	["Championnat Classique", "championnat_classique"],
	["Coupe Classique",       "coupe_classique"],
	["Championnat Panthéon",  "championnat_pantheon"],
	["Coupe Panthéon",        "coupe_pantheon"],
	["Championnat Jeunes",    "championnat_jeunes"],
	["Coupe Jeunes",          "coupe_jeunes"],
	["Matchs Amicaux",        "autre"],
]

# ── ACTUALITÉS SEMAINE — 5 news, à mettre à jour chaque semaine ──────────────
const WEEKLY_NEWS = {
	"fr": ["Bienvenue sur Football Cards Manager !", "Championnat Classique disponible.", "", "", ""],
	"en": ["Welcome to Football Cards Manager!", "Classic Championship available.", "", "", ""],
	"es": ["¡Bienvenido a Football Cards Manager!", "Campeonato Clásico disponible.", "", "", ""],
	"de": ["Willkommen bei Football Cards Manager!", "Klassische Meisterschaft verfügbar.", "", "", ""],
	"it": ["Benvenuto in Football Cards Manager!", "Campionato Classico disponibile.", "", "", ""],
	"pt": ["Bem-vindo ao Football Cards Manager!", "Campeonato Clássico disponível.", "", "", ""],
}

# ── TRADUCTIONS ───────────────────────────────────────────────────────────────
const TRANSLATIONS = {
	"fr": {
		"title_competitions": "Compétitions de la semaine",
		"news_title":         "Newsletter !",
		"bonus":        "BONUS",
		"competitions": "COMPÉTITIONS",
		"design":       "DESIGN",
		"others":       "AUTRES",
		"bugs":         "BUGS",
		"popup_comp":   "- FCM s'adapte à votre vie et à vos envies.\n- Choisissez quand jouer et quoi jouer.\n- Programmez vos compétitions pour la semaine prochaine.\n- Glissez / Déposez. Glissez / Retirez.\n- 1 championnat occupe 2 Shots espacés de 6h.\n- Planning verrouillé le dimanche à 18h.",
		"popup_evo":    "- FCM évoluera avec vos idées.\n- Cliquez sur votre thématique, soyez le plus précis possible.\n- Nous sélectionnerons et intégrerons vos meilleures suggestions.",
	},
	"en": {
		"title_competitions": "Next week competitions",
		"news_title":         "Newsletter!",
		"bonus":        "BONUS",
		"competitions": "COMPETITIONS",
		"design":       "DESIGN",
		"others":       "OTHERS",
		"bugs":         "BUGS",
		"popup_comp":   "- FCM adapts to your life and desires.\n- Choose when to play and what to play.\n- Schedule your competitions for next week.\n- Drag / Drop. Drag / Remove.\n- 1 championship occupies 2 Shots spaced 6h apart.\n- Schedule locked on Sunday at 18h.",
		"popup_evo":    "- FCM will evolve with your ideas.\n- Click on your topic, be as precise as possible.\n- We will select and integrate your best suggestions.",
	},
	"es": {
		"title_competitions": "Competiciones de la semana",
		"news_title":         "¡Newsletter!",
		"bonus":        "BONUS",
		"competitions": "COMPETICIONES",
		"design":       "DISEÑO",
		"others":       "OTROS",
		"bugs":         "BUGS",
		"popup_comp":   "- FCM se adapta a tu vida y deseos.\n- Elige cuándo y qué jugar.\n- Programa tus competiciones para la semana próxima.\n- Arrastra / Suelta. Arrastra / Retira.\n- 1 campeonato ocupa 2 Shots espaciados 6h.\n- Planificación bloqueada el domingo a las 18h.",
		"popup_evo":    "- FCM evolucionará con tus ideas.\n- Haz clic en tu tema, sé lo más preciso posible.\n- Seleccionaremos e integraremos tus mejores sugerencias.",
	},
	"de": {
		"title_competitions": "Wettkämpfe der Woche",
		"news_title":         "Newsletter!",
		"bonus":        "BONUS",
		"competitions": "WETTKÄMPFE",
		"design":       "DESIGN",
		"others":       "ANDERE",
		"bugs":         "BUGS",
		"popup_comp":   "- FCM passt sich deinem Leben an.\n- Wähle wann und was du spielst.\n- Plane deine Lieblingsbewerbe für nächste Woche.\n- Ziehen / Ablegen. Ziehen / Entfernen.\n- 1 Meisterschaft belegt 2 Shots mit 6h Abstand.\n- Zeitplan gesperrt am Sonntag um 18h.",
		"popup_evo":    "- FCM wird mit deinen Ideen wachsen.\n- Klicke auf dein Thema, sei so präzise wie möglich.\n- Wir wählen deine besten Vorschläge aus.",
	},
	"it": {
		"title_competitions": "Competizioni della settimana",
		"news_title":         "Newsletter!",
		"bonus":        "BONUS",
		"competitions": "COMPETIZIONI",
		"design":       "DESIGN",
		"others":       "ALTRI",
		"bugs":         "BUGS",
		"popup_comp":   "- FCM si adatta alla tua vita e ai tuoi desideri.\n- Scegli quando e cosa giocare.\n- Programma le tue competizioni per la prossima settimana.\n- Trascina / Rilascia. Trascina / Rimuovi.\n- 1 campionato occupa 2 Shot distanziati di 6h.\n- Pianificazione bloccata domenica alle 18h.",
		"popup_evo":    "- FCM evolverà con le tue idee.\n- Clicca sul tuo tema, sii il più preciso possibile.\n- Selezioneremo e integreremo i tuoi migliori suggerimenti.",
	},
	"pt": {
		"title_competitions": "Competições da semana",
		"news_title":         "Newsletter!",
		"bonus":        "BONUS",
		"competitions": "COMPETIÇÕES",
		"design":       "DESIGN",
		"others":       "OUTROS",
		"bugs":         "BUGS",
		"popup_comp":   "- FCM adapta-se à sua vida e desejos.\n- Escolha quando e o que jogar.\n- Programe as suas competições para a semana próxima.\n- Arraste / Solte. Arraste / Retire.\n- 1 campeonato ocupa 2 Shots espaçados 6h.\n- Planeamento bloqueado no domingo às 18h.",
		"popup_evo":    "- FCM evoluirá com as suas ideias.\n- Clique no seu tema, seja o mais preciso possível.\n- Selecionaremos e integraremos as suas melhores sugestões.",
	},
}

# ── CONSTANTES ────────────────────────────────────────────────────────────────
const CHAMPIONSHIP_PAIRS  = {1: 4, 2: 5, 3: 6, 4: 7, 5: 8}
const CHAMPIONSHIP_TYPES  = ["championnat_classique", "championnat_pantheon", "championnat_jeunes", "championnat_asso", "championnat_special"]
const SHOT_TIMES          = {1:"0h - 3h", 2:"3h - 6h", 3:"6h - 9h", 4:"9h - 12h", 5:"12h - 15h", 6:"15h - 18h", 7:"18h - 21h", 8:"21h - 24h"}
const LONG_PRESS_DURATION = 0.5
const SLIDE_DURATION      = 0.35

# ── ÉTAT ──────────────────────────────────────────────────────────────────────
var shot_data:           Dictionary = {}
var catalogue_available: Array      = []
var drag_active:         bool       = false
var drag_comp_name:      String     = ""
var drag_comp_type:      String     = ""
var drag_origin_shot:    int        = -1
var drag_origin_cat:     int        = -1
var drag_visual:         Label      = null
var press_slot:          int        = -1
var press_timer:         float      = 0.0
var press_holding:       bool       = false
var current_page:        int        = 1
var is_animating:        bool       = false
var touch_start:         Vector2    = Vector2.ZERO
var locked:              bool       = false
var page1_nodes:         Array      = []

# ── NŒUDS PAGE 1 ─────────────────────────────────────────────────────────────
@onready var txt_title_competitions = $TXT_TitleCompetitions
@onready var btn_help_competitions  = $BTN_HelpCompetitions
@onready var txt_popup_competitions = $TXT_PopupCompetitions
@onready var swipe_down             = $Swipe_Down
@onready var catalogue              = $Catalogue
@onready var bg_catalogue           = $Catalogue/BG_Catalogue

# ── NŒUDS PAGE 2 ─────────────────────────────────────────────────────────────
@onready var page2                = $Page2
@onready var swipe_up             = $Page2/Swipe_Up
@onready var txt_title_newsletter = $Page2/TXT_TitleNewsletter
@onready var txt_news1            = $Page2/TXT_News1
@onready var txt_news2            = $Page2/TXT_News2
@onready var txt_news3            = $Page2/TXT_News3
@onready var txt_news4            = $Page2/TXT_News4
@onready var txt_news5            = $Page2/TXT_News5
@onready var txt_title_evolution  = $Page2/TXT_TitleEvolution
@onready var btn_help_evolution   = $Page2/BTN_HelpEvolution
@onready var txt_popup_evolution  = $Page2/TXT_PopupEvolution
@onready var txt_bonus            = $Page2/TXT_Bonus
@onready var txt_feat_comp        = $Page2/TXT_Competitions
@onready var txt_design           = $Page2/TXT_Design
@onready var txt_others           = $Page2/TXT_Others
@onready var txt_bugs             = $Page2/TXT_Bugs

var shot_nodes:  Array = []
var comp_labels: Array = []

# ── READY ─────────────────────────────────────────────────────────────────────
func _ready():
	for i in range(1, 9):
		shot_data[i] = {}
		shot_nodes.append(get_node("Shot_%d" % i))
	catalogue_available = []
	for i in range(WEEKLY_CATALOGUE.size()):
		catalogue_available.append(true)
	for i in range(1, WEEKLY_CATALOGUE.size() + 1):
		comp_labels.append(catalogue.get_node("TXT_Competition%d" % i))
	txt_popup_competitions.visible = false
	txt_popup_evolution.visible    = false
	_setup_shot_times()
	_setup_catalogue()
	_setup_news()
	_apply_translations()
	_refresh_shots()
	_check_lock()
	# Nœuds Page1 à masquer lors du passage en Page2
	page1_nodes = [txt_title_competitions, btn_help_competitions,
		txt_popup_competitions, swipe_down, catalogue]
	for i in range(1, 9):
		page1_nodes.append(shot_nodes[i-1])

# ── SETUP ─────────────────────────────────────────────────────────────────────
func _setup_shot_times():
	for i in range(1, 9):
		shot_nodes[i-1].get_node("TXT_Time").text = SHOT_TIMES[i]

func _setup_catalogue():
	for i in range(comp_labels.size()):
		comp_labels[i].visible = false
	for i in range(WEEKLY_CATALOGUE.size()):
		comp_labels[i].text     = WEEKLY_CATALOGUE[i][0]
		comp_labels[i].modulate = COMP_COLORS[WEEKLY_CATALOGUE[i][1]]
		comp_labels[i].visible  = catalogue_available[i]

func _setup_news():
	var news   = WEEKLY_NEWS.get(GameState.language, WEEKLY_NEWS["fr"])
	var labels = [txt_news1, txt_news2, txt_news3, txt_news4, txt_news5]
	for i in range(labels.size()):
		var text          = news[i] if i < news.size() else ""
		labels[i].text    = text
		labels[i].visible = (text != "")

func _apply_translations():
	var t = TRANSLATIONS.get(GameState.language, TRANSLATIONS["fr"])
	txt_title_competitions.text = t["title_competitions"]
	txt_title_newsletter.text   = t["news_title"]
	txt_title_evolution.text    = "Football Cards Manager Evolution"
	txt_bonus.text              = t["bonus"]
	txt_feat_comp.text          = t["competitions"]
	txt_design.text             = t["design"]
	txt_others.text             = t["others"]
	txt_bugs.text               = t["bugs"]
	txt_popup_competitions.text = t["popup_comp"]
	txt_popup_evolution.text    = t["popup_evo"]

# ── REFRESH SHOTS ─────────────────────────────────────────────────────────────
func _refresh_shots():
	for i in range(1, 9):
		var txt_c = shot_nodes[i-1].get_node("TXT_Competition")
		var bg    = shot_nodes[i-1].get_node("Card_Background_Shot")
		if shot_data[i].is_empty():
			txt_c.text  = ""
			bg.modulate = Color(1.0, 1.0, 1.0)
		else:
			txt_c.text  = shot_data[i]["name"]
			bg.modulate = COMP_COLORS[shot_data[i]["type"]]
	_setup_catalogue()
	_update_shot_availability()

func _update_shot_availability():
	if not drag_active or drag_comp_type not in CHAMPIONSHIP_TYPES:
		for i in range(1, 9):
			shot_nodes[i-1].modulate = Color(1.0, 1.0, 1.0)
		return
	for i in range(1, 9):
		shot_nodes[i-1].modulate = Color(1.0, 1.0, 1.0) if _is_shot_available_for_champ(i) else Color(0.5, 0.5, 0.5)

func _is_shot_available_for_champ(slot: int) -> bool:
	if slot not in CHAMPIONSHIP_PAIRS: return false
	var pair = CHAMPIONSHIP_PAIRS[slot]
	if not shot_data[slot].is_empty() and drag_origin_shot != slot: return false
	if not shot_data[pair].is_empty():
		var origin_pair = CHAMPIONSHIP_PAIRS.get(drag_origin_shot, -1)
		if origin_pair != pair: return false
	return true

func _check_lock():
	var now = Time.get_datetime_dict_from_system()
	locked  = (now["weekday"] == 0 and now["hour"] >= 18)
	for i in range(1, 9):
		shot_nodes[i-1].get_node("OVL_Lock").visible = locked

# ── PROCESS — clic long ───────────────────────────────────────────────────────
func _process(delta):
	if press_holding and press_slot > 0:
		press_timer += delta
		if press_timer >= LONG_PRESS_DURATION:
			press_holding = false
			press_timer   = 0.0
			if not locked:
				var slot = press_slot
				press_slot = -1
				_end_drag()
				_clear_shot(slot)
				_refresh_shots()

# ── NAVIGATION PAGES — slide vertical ────────────────────────────────────────
func _animate_to_page(page: int):
	if is_animating: return
	is_animating = true
	txt_popup_competitions.visible = false
	txt_popup_evolution.visible    = false
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	if page == 2:
		current_page = 2
		for n in page1_nodes: n.visible = false
		tween.tween_property(page2, "position:y", -1080.0, SLIDE_DURATION)
		tween.tween_callback(func(): is_animating = false)
	else:
		current_page = 1
		tween.tween_property(page2, "position:y", 0.0, SLIDE_DURATION)
		tween.tween_callback(func():
			for n in page1_nodes: n.visible = true
			is_animating = false)

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			touch_start = event.position
			_on_press(event.position)
		else:
			_on_release(event.position)
	elif event is InputEventMouseMotion:
		if press_holding:
			if event.position.distance_to(touch_start) > 10:
				press_holding = false
				press_timer   = 0.0
		if drag_active and drag_visual:
			drag_visual.position = event.position - Vector2(drag_visual.size.x / 2, drag_visual.size.y / 2)

func _on_press(pos: Vector2):
	if txt_popup_competitions.visible and _label_hit(txt_popup_competitions, pos):
		txt_popup_competitions.visible = false; return
	if txt_popup_evolution.visible and _label_hit(txt_popup_evolution, pos):
		txt_popup_evolution.visible = false; return
	if _sprite_hit(swipe_down, pos) and current_page == 1:
		_animate_to_page(2); return
	if _sprite_hit(swipe_up, pos) and current_page == 2:
		_animate_to_page(1); return
	if _sprite_hit(btn_help_competitions, pos) and current_page == 1:
		txt_popup_competitions.visible = true; return
	if _sprite_hit(btn_help_evolution, pos) and current_page == 2:
		txt_popup_evolution.visible = true; return
	if current_page == 2:
		if _label_hit(txt_bonus, pos):     OS.shell_open(FEATUREBASE_URL + "?category=bonus"); return
		if _label_hit(txt_feat_comp, pos): OS.shell_open(FEATUREBASE_URL + "?category=competitions"); return
		if _label_hit(txt_design, pos):    OS.shell_open(FEATUREBASE_URL + "?category=design"); return
		if _label_hit(txt_others, pos):    OS.shell_open(FEATUREBASE_URL + "?category=others"); return
		if _label_hit(txt_bugs, pos):      OS.shell_open(FEATUREBASE_URL + "?category=bugs"); return
	if current_page != 1 or locked: return
	for i in range(1, 9):
		if _shot_hit(i, pos) and not shot_data[i].is_empty():
			press_slot    = i
			press_holding = true
			press_timer   = 0.0
			_start_drag(shot_data[i]["name"], shot_data[i]["type"], i, shot_data[i].get("cat_idx", -1))
			return
	for i in range(WEEKLY_CATALOGUE.size()):
		if catalogue_available[i] and _label_hit(comp_labels[i], pos):
			_start_drag(WEEKLY_CATALOGUE[i][0], WEEKLY_CATALOGUE[i][1], -1, i)
			return

func _on_release(pos: Vector2):
	press_holding = false
	press_timer   = 0.0
	if not drag_active: return
	for i in range(1, 9):
		if _shot_hit(i, pos):
			_drop_on_shot(i); return
	if drag_origin_shot > 0 and _catalogue_hit(pos):
		_clear_shot(drag_origin_shot)
		_end_drag()
		_refresh_shots(); return
	_end_drag()

# ── DRAG & DROP ───────────────────────────────────────────────────────────────
func _start_drag(comp_name: String, comp_type: String, origin_shot: int, origin_cat: int):
	drag_active      = true
	drag_comp_name   = comp_name
	drag_comp_type   = comp_type
	drag_origin_shot = origin_shot
	drag_origin_cat  = origin_cat
	drag_visual      = Label.new()
	drag_visual.text = comp_name
	drag_visual.modulate = COMP_COLORS[comp_type]
	add_child(drag_visual)
	_update_shot_availability()

func _end_drag():
	drag_active      = false
	drag_comp_name   = ""
	drag_comp_type   = ""
	drag_origin_shot = -1
	drag_origin_cat  = -1
	if drag_visual:
		drag_visual.queue_free()
		drag_visual = null
	_update_shot_availability()

func _drop_on_shot(slot: int):
	if not shot_data[slot].is_empty() and slot != drag_origin_shot:
		_end_drag(); return
	if drag_comp_type in CHAMPIONSHIP_TYPES:
		if not _is_shot_available_for_champ(slot): _end_drag(); return
		var pair = CHAMPIONSHIP_PAIRS[slot]
		if drag_origin_shot > 0 and drag_origin_shot != slot:
			var old_pair = CHAMPIONSHIP_PAIRS.get(drag_origin_shot, -1)
			shot_data[drag_origin_shot] = {}
			if old_pair > 0: shot_data[old_pair] = {}
		shot_data[slot] = {"name": drag_comp_name, "type": drag_comp_type, "cat_idx": drag_origin_cat}
		shot_data[pair] = {"name": drag_comp_name, "type": drag_comp_type, "cat_idx": -1}
		if drag_origin_cat >= 0: catalogue_available[drag_origin_cat] = false
	else:
		if drag_origin_shot > 0 and drag_origin_shot != slot:
			shot_data[drag_origin_shot] = {}
		shot_data[slot] = {"name": drag_comp_name, "type": drag_comp_type, "cat_idx": drag_origin_cat}
		if drag_origin_cat >= 0: catalogue_available[drag_origin_cat] = false
	_end_drag()
	_refresh_shots()

func _clear_shot(slot: int):
	if shot_data[slot].is_empty(): return
	var t       = shot_data[slot].get("type", "")
	var cat_idx = shot_data[slot].get("cat_idx", -1)
	if t in CHAMPIONSHIP_TYPES:
		if cat_idx >= 0:
			var pair = CHAMPIONSHIP_PAIRS.get(slot, -1)
			if pair > 0: shot_data[pair] = {}
		else:
			for k in CHAMPIONSHIP_PAIRS:
				if CHAMPIONSHIP_PAIRS[k] == slot:
					var main_cat = shot_data[k].get("cat_idx", -1)
					if main_cat >= 0: catalogue_available[main_cat] = true
					shot_data[k] = {}
	if cat_idx >= 0: catalogue_available[cat_idx] = true
	shot_data[slot] = {}

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _shot_hit(slot: int, pos: Vector2) -> bool:
	var bg = shot_nodes[slot-1].get_node_or_null("Card_Background_Shot")
	if bg == null: return false
	return bg.get_rect().has_point(bg.to_local(pos))

func _catalogue_hit(pos: Vector2) -> bool:
	if bg_catalogue == null: return false
	return bg_catalogue.get_rect().has_point(bg_catalogue.to_local(pos))

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _label_hit(label: Label, pos: Vector2) -> bool:
	if label == null or not label.visible: return false
	return label.get_global_rect().has_point(pos)
