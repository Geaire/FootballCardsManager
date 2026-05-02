extends Node2D

const FEATUREBASE_URL = "https://fcm.featurebase.app"

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

const CATALOGUE_TRANSLATIONS = {
	"championnat_classique": {"fr":"Champ. Classique","en":"Classic Champ.","es":"Camp. Clásico","de":"Klass. Meistersch.","it":"Camp. Classico","pt":"Camp. Clássico"},
	"coupe_classique":       {"fr":"Coupe Classique","en":"Classic Cup","es":"Copa Clásica","de":"Klassischer Pokal","it":"Coppa Classica","pt":"Taça Clássica"},
	"championnat_pantheon":  {"fr":"Champ. Panthéon","en":"Pantheon Champ.","es":"Camp. Panteón","de":"Pantheon Meistersch.","it":"Camp. Pantheon","pt":"Camp. Panteão"},
	"coupe_pantheon":        {"fr":"Coupe Panthéon","en":"Pantheon Cup","es":"Copa Panteón","de":"Pantheon Pokal","it":"Coppa Pantheon","pt":"Taça Panteão"},
	"championnat_jeunes":    {"fr":"Champ. Jeunes","en":"Youth Champ.","es":"Camp. Juvenil","de":"Jugend Meistersch.","it":"Camp. Giovani","pt":"Camp. Jovens"},
	"coupe_jeunes":          {"fr":"Coupe Jeunes","en":"Youth Cup","es":"Copa Juvenil","de":"Jugendpokal","it":"Coppa Giovani","pt":"Taça Jovens"},
}

const WEEKLY_CATALOGUE = [
	["championnat_classique"],
	["coupe_classique"],
	["championnat_pantheon"],
	["coupe_pantheon"],
	["championnat_jeunes"],
	["coupe_jeunes"],
]

const WEEKLY_NEWS = {
	"fr": ["Bienvenue sur Football Cards Manager !", "Championnat Classique disponible.", "", "", ""],
	"en": ["Welcome to Football Cards Manager!", "Classic Championship available.", "", "", ""],
	"es": ["Bienvenido a Football Cards Manager!", "Campeonato Clásico disponible.", "", "", ""],
	"de": ["Willkommen bei Football Cards Manager!", "Klassische Meisterschaft verfügbar.", "", "", ""],
	"it": ["Benvenuto in Football Cards Manager!", "Campionato Classico disponibile.", "", "", ""],
	"pt": ["Bem-vindo ao Football Cards Manager!", "Campeonato Clássico disponível.", "", "", ""],
}

const TRANSLATIONS = {
	"fr": {
		"title_competitions": "Compétitions de la semaine", "news_title": "Newsletter !",
		"bonus": "BONUS", "competitions": "COMPÉTITIONS", "design": "DESIGN", "others": "AUTRES", "bugs": "BUGS",
		"popup_comp": "- FCM s'adapte à votre vie et à vos envies.\n- Choisissez quand jouer et quoi jouer.\n- Programmez vos compétitions pour la semaine prochaine.\n- Glissez / Déposez. Glissez / Retirez.\n- 1 championnat occupe 2 Shots espacés de 6h.\n- Planning verrouillé le dimanche à 18h.",
		"popup_evo": "- FCM évoluera avec vos idées.\n- Cliquez sur votre thématique, soyez le plus précis possible.\n- Nous sélectionnerons et intégrerons vos meilleures suggestions.",
	},
	"en": {
		"title_competitions": "Next week competitions", "news_title": "Newsletter!",
		"bonus": "BONUS", "competitions": "COMPETITIONS", "design": "DESIGN", "others": "OTHERS", "bugs": "BUGS",
		"popup_comp": "- FCM adapts to your life and desires.\n- Choose when to play and what to play.\n- Schedule your competitions for next week.\n- Drag / Drop. Drag / Remove.\n- 1 championship occupies 2 Shots spaced 6h apart.\n- Schedule locked on Sunday at 18h.",
		"popup_evo": "- FCM will evolve with your ideas.\n- Click on your topic, be as precise as possible.\n- We will select and integrate your best suggestions.",
	},
	"es": {
		"title_competitions": "Competiciones de la semana", "news_title": "Newsletter!",
		"bonus": "BONUS", "competitions": "COMPETICIONES", "design": "DISEÑO", "others": "OTROS", "bugs": "BUGS",
		"popup_comp": "- FCM se adapta a tu vida y deseos.\n- Elige cuándo y qué jugar.\n- Programa tus competiciones para la semana próxima.\n- Arrastra / Suelta. Arrastra / Retira.\n- 1 campeonato ocupa 2 Shots espaciados 6h.\n- Planificación bloqueada el domingo a las 18h.",
		"popup_evo": "- FCM evolucionará con tus ideas.\n- Haz clic en tu tema, sé lo más preciso posible.\n- Seleccionaremos e integraremos tus mejores sugerencias.",
	},
	"de": {
		"title_competitions": "Wettkämpfe der Woche", "news_title": "Newsletter!",
		"bonus": "BONUS", "competitions": "WETTKÄMPFE", "design": "DESIGN", "others": "ANDERE", "bugs": "BUGS",
		"popup_comp": "- FCM passt sich deinem Leben an.\n- Wähle wann und was du spielst.\n- Plane deine Lieblingsbewerbe für nächste Woche.\n- Ziehen / Ablegen. Ziehen / Entfernen.\n- 1 Meisterschaft belegt 2 Shots mit 6h Abstand.\n- Zeitplan gesperrt am Sonntag um 18h.",
		"popup_evo": "- FCM wird mit deinen Ideen wachsen.\n- Klicke auf dein Thema, sei so präzise wie möglich.\n- Wir wählen deine besten Vorschläge aus.",
	},
	"it": {
		"title_competitions": "Competizioni della settimana", "news_title": "Newsletter!",
		"bonus": "BONUS", "competitions": "COMPETIZIONI", "design": "DESIGN", "others": "ALTRI", "bugs": "BUGS",
		"popup_comp": "- FCM si adatta alla tua vita e ai tuoi desideri.\n- Scegli quando e cosa giocare.\n- Programma le tue competizioni per la prossima settimana.\n- Trascina / Rilascia. Trascina / Rimuovi.\n- 1 campionato occupa 2 Shot distanziati di 6h.\n- Pianificazione bloccata domenica alle 18h.",
		"popup_evo": "- FCM evolverà con le tue idee.\n- Clicca sul tuo tema, sii il più preciso possibile.\n- Selezioneremo e integreremo i tuoi migliori suggerimenti.",
	},
	"pt": {
		"title_competitions": "Competições da semana", "news_title": "Newsletter!",
		"bonus": "BONUS", "competitions": "COMPETIÇÕES", "design": "DESIGN", "others": "OUTROS", "bugs": "BUGS",
		"popup_comp": "- FCM adapta-se à sua vida e desejos.\n- Escolha quando e o que jogar.\n- Programe as suas competições para a semana próxima.\n- Arraste / Solte. Arraste / Retire.\n- 1 campeonato ocupa 2 Shots espaçados 6h.\n- Planeamento bloqueado no domingo às 18h.",
		"popup_evo": "- FCM evoluirá com as suas ideias.\n- Clique no seu tema, seja o mais preciso possível.\n- Selecionaremos e integraremos as suas melhores sugestões.",
	},
}

const CHAMPIONSHIP_PAIRS  = {1:4, 2:5, 3:6, 4:7, 5:8}
const CHAMPIONSHIP_TYPES  = ["championnat_classique","championnat_pantheon","championnat_jeunes","championnat_asso","championnat_special"]
const SHOT_TIMES          = {1:"0h - 3h",2:"3h - 6h",3:"6h - 9h",4:"9h - 12h",5:"12h - 15h",6:"15h - 18h",7:"18h - 21h",8:"21h - 24h"}
const LONG_PRESS_DURATION = 0.5
const SLIDE_DURATION      = 0.35

var shot_data:Dictionary={}; var catalogue_available:Array=[]; var drag_active:bool=false
var drag_comp_name:String=""; var drag_comp_type:String=""; var drag_origin_shot:int=-1
var drag_origin_cat:int=-1; var drag_visual:Label=null; var press_slot:int=-1
var press_timer:float=0.0; var press_holding:bool=false; var current_page:int=1
var is_animating:bool=false; var touch_start:Vector2=Vector2.ZERO; var locked:bool=false
var page1_nodes:Array=[]

# ── NŒUDS ─────────────────────────────────────────────────────────────────────
@onready var lbl_title_competitions = $LBL_TitleCompetitions   # Label
@onready var btn_help_competitions  = $BTN_HelpCompetitions     # Sprite2D
@onready var lbl_popup_competitions = $LBL_PopupCompetitions    # Label
@onready var btn_next_page          = $BTN_NextPage             # Sprite2D
@onready var pnl_competitions       = $PNL_Competitions         # PanelContainer

@onready var page2               = $Page2
@onready var btn_prev_page       = $Page2/BTN_PrevPage          # Sprite2D
@onready var lbl_title_news      = $Page2/LBL_TitleNews         # Label
@onready var lbl_news1           = $Page2/PNL_News/LBL_News1
@onready var lbl_news2           = $Page2/PNL_News/LBL_News2
@onready var lbl_news3           = $Page2/PNL_News/LBL_News3
@onready var lbl_news4           = $Page2/PNL_News/LBL_News4
@onready var lbl_news5           = $Page2/PNL_News/LBL_News5
@onready var lbl_title_evolution = $Page2/LBL_TitleEvolution    # Label
@onready var btn_help_evolution  = $Page2/BTN_HelpEvolution      # Sprite2D
@onready var lbl_popup_evolution = $Page2/LBL_PopupEvolution     # Label
@onready var btn_bonus           = $Page2/PNL_Evolution/BTN_Bonus          # Label
@onready var btn_feat_comp       = $Page2/PNL_Evolution/BTN_Competitions   # Label
@onready var btn_design          = $Page2/PNL_Evolution/BTN_Design         # Label
@onready var btn_others          = $Page2/PNL_Evolution/BTN_Others         # Label
@onready var btn_bugs            = $Page2/PNL_Evolution/BTN_Bugs           # Label

var shot_nodes: Array = []
var comp_btns:  Array = []

# ── READY ──────────────────────────────────────────────────────────────────────
func _ready():
	Taskbar.visible = true
	for i in range(1, 9):
		shot_data[i] = {}
		shot_nodes.append(get_node("Shot_%d" % i))
	for i in range(WEEKLY_CATALOGUE.size()):
		catalogue_available.append(true)
	for i in range(1, WEEKLY_CATALOGUE.size() + 1):
		comp_btns.append(pnl_competitions.get_node("BTN_Competition%d" % i))
	lbl_popup_competitions.visible = false
	lbl_popup_evolution.visible    = false
	_setup_shot_times()
	_setup_catalogue()
	_setup_news()
	_apply_translations()
	_refresh_shots()
	_check_lock()
	page1_nodes = [lbl_title_competitions, btn_help_competitions, btn_next_page, pnl_competitions]
	for i in range(1, 9):
		page1_nodes.append(shot_nodes[i - 1])

# ── HEURES SHOTS ──────────────────────────────────────────────────────────────
func _setup_shot_times():
	for i in range(1, 9):
		shot_nodes[i - 1].get_node("LBL_Time").text = SHOT_TIMES[i]

# ── CATALOGUE ─────────────────────────────────────────────────────────────────
func _setup_catalogue():
	var lang = GameState.language
	for i in range(comp_btns.size()):
		comp_btns[i].visible = false
	for i in range(WEEKLY_CATALOGUE.size()):
		var ct = WEEKLY_CATALOGUE[i][0]
		comp_btns[i].text     = CATALOGUE_TRANSLATIONS[ct].get(lang, CATALOGUE_TRANSLATIONS[ct]["en"])
		comp_btns[i].modulate = COMP_COLORS[ct]
		comp_btns[i].visible  = catalogue_available[i]

# ── NEWS ──────────────────────────────────────────────────────────────────────
func _setup_news():
	var news   = WEEKLY_NEWS.get(GameState.language, WEEKLY_NEWS["fr"])
	var labels = [lbl_news1, lbl_news2, lbl_news3, lbl_news4, lbl_news5]
	for i in range(labels.size()):
		var text      = news[i] if i < news.size() else ""
		labels[i].text    = text
		labels[i].visible = (text != "")

# ── TRADUCTIONS ────────────────────────────────────────────────────────────────
func _apply_translations():
	var t = TRANSLATIONS.get(GameState.language, TRANSLATIONS["fr"])
	lbl_title_competitions.text = t["title_competitions"]
	lbl_title_news.text         = t["news_title"]
	lbl_title_evolution.text    = "Football Cards Manager Evolution"
	btn_bonus.text              = t["bonus"]
	btn_feat_comp.text          = t["competitions"]
	btn_design.text             = t["design"]
	btn_others.text             = t["others"]
	btn_bugs.text               = t["bugs"]
	lbl_popup_competitions.text = t["popup_comp"]
	lbl_popup_evolution.text    = t["popup_evo"]

# ── REFRESH SHOTS ─────────────────────────────────────────────────────────────
func _refresh_shots():
	for i in range(1, 9):
		var lbl_c = shot_nodes[i - 1].get_node("LBL_Competition")
		var bg    = shot_nodes[i - 1].get_node("BG_Shot")
		if shot_data[i].is_empty():
			lbl_c.text = ""
			_set_bg_color(bg, Color(1, 1, 1))
		else:
			lbl_c.text = shot_data[i]["name"]
			_set_bg_color(bg, COMP_COLORS[shot_data[i]["type"]])
	_setup_catalogue()
	_update_shot_availability()

func _set_bg_color(panel: PanelContainer, color: Color):
	var style = panel.get_theme_stylebox("panel").duplicate()
	style.bg_color = color
	panel.add_theme_stylebox_override("panel", style)

# ── DISPONIBILITÉ SHOTS ───────────────────────────────────────────────────────
func _update_shot_availability():
	if not drag_active or drag_comp_type not in CHAMPIONSHIP_TYPES:
		for i in range(1, 9): shot_nodes[i - 1].modulate = Color(1, 1, 1)
		return
	for i in range(1, 9):
		shot_nodes[i - 1].modulate = Color(1, 1, 1) if _is_shot_available_for_champ(i) else Color(0.5, 0.5, 0.5)

func _is_shot_available_for_champ(slot: int) -> bool:
	if slot not in CHAMPIONSHIP_PAIRS: return false
	var pair = CHAMPIONSHIP_PAIRS[slot]
	if not shot_data[slot].is_empty() and drag_origin_shot != slot: return false
	if not shot_data[pair].is_empty():
		if CHAMPIONSHIP_PAIRS.get(drag_origin_shot, -1) != pair: return false
	return true

# ── VERROU DIMANCHE 18H ───────────────────────────────────────────────────────
func _check_lock():
	var now = Time.get_datetime_dict_from_system()
	locked = (now["weekday"] == 0 and now["hour"] >= 18)
	for i in range(1, 9):
		shot_nodes[i - 1].get_node("OVL_Lock").visible = locked

# ── PROCESS — appui long ──────────────────────────────────────────────────────
func _process(delta):
	if press_holding and press_slot > 0:
		press_timer += delta
		if press_timer >= LONG_PRESS_DURATION:
			press_holding = false; press_timer = 0.0
			if not locked:
				var slot = press_slot; press_slot = -1
				_end_drag(); _clear_shot(slot); _refresh_shots()

# ── ANIMATION PAGE ────────────────────────────────────────────────────────────
func _animate_to_page(page: int):
	if is_animating: return
	is_animating = true
	lbl_popup_competitions.visible = false
	lbl_popup_evolution.visible    = false
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT); tween.set_trans(Tween.TRANS_CUBIC)
	if page == 2:
		current_page = 2
		for n in page1_nodes: n.visible = false
		tween.tween_property(page2, "position:y", -1080.0, SLIDE_DURATION)
		tween.tween_callback(func(): is_animating = false)
	else:
		current_page = 1
		tween.tween_property(page2, "position:y", 0.0, SLIDE_DURATION)
		tween.tween_callback(func(): for n in page1_nodes: n.visible = true; is_animating = false)

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			touch_start = event.position
			_on_press(event.position)
		else:
			_on_release(event.position)
	elif event is InputEventMouseMotion:
		if press_holding and event.position.distance_to(touch_start) > 10:
			press_holding = false; press_timer = 0.0
		if drag_active and drag_visual:
			drag_visual.position = event.position - Vector2(drag_visual.size.x / 2, drag_visual.size.y / 2)

func _on_press(pos: Vector2):
	# Fermer popups si ouvertes
	if lbl_popup_competitions.visible and _label_hit(lbl_popup_competitions, pos):
		lbl_popup_competitions.visible = false; return
	if lbl_popup_evolution.visible and _label_hit(lbl_popup_evolution, pos):
		lbl_popup_evolution.visible = false; return
	# Navigation pages — Sprite2D
	if _sprite_hit(btn_next_page, pos) and current_page == 1:
		_animate_to_page(2); return
	if _sprite_hit(btn_prev_page, pos) and current_page == 2:
		_animate_to_page(1); return
	# Boutons aide — Sprite2D
	if _sprite_hit(btn_help_competitions, pos) and current_page == 1:
		lbl_popup_competitions.visible = true; return
	if _sprite_hit(btn_help_evolution, pos) and current_page == 2:
		lbl_popup_evolution.visible = true; return
	# Page 2 — Evolution — Labels
	if current_page == 2:
		if _label_hit(btn_bonus, pos):     OS.shell_open(FEATUREBASE_URL + "?category=bonus"); return
		if _label_hit(btn_feat_comp, pos): OS.shell_open(FEATUREBASE_URL + "?category=competitions"); return
		if _label_hit(btn_design, pos):    OS.shell_open(FEATUREBASE_URL + "?category=design"); return
		if _label_hit(btn_others, pos):    OS.shell_open(FEATUREBASE_URL + "?category=others"); return
		if _label_hit(btn_bugs, pos):      OS.shell_open(FEATUREBASE_URL + "?category=bugs"); return
	# Page 1 uniquement
	if current_page != 1 or locked: return
	# Appui long sur shot occupé
	for i in range(1, 9):
		if _shot_hit(i, pos) and not shot_data[i].is_empty():
			press_slot = i; press_holding = true; press_timer = 0.0
			_start_drag(shot_data[i]["name"], shot_data[i]["type"], i, shot_data[i].get("cat_idx", -1))
			return
	# Drag depuis catalogue
	for i in range(WEEKLY_CATALOGUE.size()):
		if catalogue_available[i] and _label_hit(comp_btns[i], pos):
			_start_drag(comp_btns[i].text, WEEKLY_CATALOGUE[i][0], -1, i)
			return

func _on_release(pos: Vector2):
	press_holding = false; press_timer = 0.0
	if not drag_active: return
	for i in range(1, 9):
		if _shot_hit(i, pos): _drop_on_shot(i); return
	if drag_origin_shot > 0 and _pnl_hit(pos):
		_clear_shot(drag_origin_shot); _end_drag(); _refresh_shots(); return
	_end_drag()

# ── DRAG ──────────────────────────────────────────────────────────────────────
func _start_drag(comp_name: String, comp_type: String, origin_shot: int, origin_cat: int):
	drag_active = true; drag_comp_name = comp_name; drag_comp_type = comp_type
	drag_origin_shot = origin_shot; drag_origin_cat = origin_cat
	drag_visual = Label.new()
	drag_visual.text     = comp_name
	drag_visual.modulate = COMP_COLORS[comp_type]
	add_child(drag_visual)
	_update_shot_availability()

func _end_drag():
	drag_active = false; drag_comp_name = ""; drag_comp_type = ""
	drag_origin_shot = -1; drag_origin_cat = -1
	if drag_visual: drag_visual.queue_free(); drag_visual = null
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
	_end_drag(); _refresh_shots()

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
					var mc = shot_data[k].get("cat_idx", -1)
					if mc >= 0: catalogue_available[mc] = true
					shot_data[k] = {}
	if cat_idx >= 0: catalogue_available[cat_idx] = true
	shot_data[slot] = {}

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _shot_hit(slot: int, pos: Vector2) -> bool:
	var bg = shot_nodes[slot - 1].get_node_or_null("BG_Shot")
	if bg == null: return false
	return bg.get_global_rect().has_point(pos)

func _pnl_hit(pos: Vector2) -> bool:
	if pnl_competitions == null: return false
	return pnl_competitions.get_global_rect().has_point(pos)

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _label_hit(label: Label, pos: Vector2) -> bool:
	if label == null or not label.visible: return false
	return label.get_global_rect().has_point(pos)
