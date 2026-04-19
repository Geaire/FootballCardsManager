extends Node2D

# ── CONSTANTES ────────────────────────────────────────────────────────────────
const PAGE_HEIGHT : float = 1080.0
const LOCK_DAY    : int   = 0
const LOCK_HOUR   : int   = 18
const FIREBASE_BASE = "https://firestore.googleapis.com/v1/projects/football-cards-manager/databases/(default)/documents"

const SHOT_TIMES = [
	"0h - 3h","3h - 6h","6h - 9h","9h - 12h",
	"12h - 15h","15h - 18h","18h - 21h","21h - 24h"
]

# 7 compétitions fixes du catalogue
const CATALOGUE_KEYS = [
	"champ_classique","coupe_classique","champ_pantheon",
	"coupe_pantheon","champ_jeunes","coupe_jeunes","amicaux"
]

const COMP_COLORS = {
	"champ_classique":  Color("#FFD700"),
	"coupe_classique":  Color("#00BFFF"),
	"champ_pantheon":   Color("#9B59B6"),
	"coupe_pantheon":   Color("#E74C3C"),
	"champ_jeunes":     Color("#F39C12"),
	"coupe_jeunes":     Color("#FF6347"),
	"amicaux":          Color("#2ECC71"),
}

const TRANSLATIONS = {
	"fr": {
		"title_comp": "Compétitions de la semaine prochaine",
		"title_news": "Newsletter",
		"title_evol": "FCM Evolution",
		"popup_comp": "- FCM s'adapte à votre vie et à vos envies.\n- Choisissez quand jouer et quoi jouer.\n- Programmez vos compétitions préférées pour la semaine prochaine.\n- Glissez / Déposez. Glissez / Retirez.\n- 1 championnat occupe 2 shots espacé de 3 shots.\n- Slots valides pour un championnat : 1 à 5.\n- Planning verrouillé le dimanche à 18h.",
		"popup_evol": "- FCM évoluera avec vos idées.\n- Cliquez sur votre thématique, soyez le plus précis possible, nous sélectionnerons et intégrerons vos meilleures suggestions.",
		"btn_bonus": "Bonus", "btn_comp": "Compétitions", "btn_design": "Design",
		"btn_others": "Autres", "btn_bugs": "Bugs",
		"thanks": "Merci pour votre suggestion !",
		"placeholder": "Écrivez votre suggestion ici...",
		"send": "Envoyer",
		"comps": {
			"champ_classique": "Championnat Classique", "coupe_classique": "Coupe Classique",
			"champ_pantheon": "Championnat Panthéon", "coupe_pantheon": "Coupe Panthéon",
			"champ_jeunes": "Championnat Jeunes", "coupe_jeunes": "Coupe Jeunes",
			"amicaux": "Matchs Amicaux",
		}
	},
	"en": {
		"title_comp": "Next week competitions",
		"title_news": "Newsletter",
		"title_evol": "FCM Evolution",
		"popup_comp": "- FCM adapts to your life and desires.\n- Choose when to play and what to play.\n- Schedule your favorite competitions for next week.\n- Drag / Drop. Drag / Remove.\n- 1 championship occupies 2 slots spaced 3 slots apart.\n- Valid slots for a championship: 1 to 5.\n- Schedule locked on Sunday at 6pm.",
		"popup_evol": "- FCM will evolve with your ideas.\n- Click on your topic, be as precise as possible, we will select and integrate your best suggestions.",
		"btn_bonus": "Bonus", "btn_comp": "Competitions", "btn_design": "Design",
		"btn_others": "Others", "btn_bugs": "Bugs",
		"thanks": "Thank you for your suggestion!",
		"placeholder": "Write your suggestion here...",
		"send": "Send",
		"comps": {
			"champ_classique": "Classic Championship", "coupe_classique": "Classic Cup",
			"champ_pantheon": "Pantheon Championship", "coupe_pantheon": "Pantheon Cup",
			"champ_jeunes": "Youth Championship", "coupe_jeunes": "Youth Cup",
			"amicaux": "Friendly Matches",
		}
	},
	"es": {
		"title_comp": "Competiciones próxima semana",
		"title_news": "Boletín",
		"title_evol": "FCM Evolución",
		"popup_comp": "- FCM se adapta a tu vida y deseos.\n- Elige cuándo jugar y qué jugar.\n- Programa tus competiciones favoritas para la próxima semana.\n- Arrastra / Suelta. Arrastra / Retira.\n- 1 campeonato ocupa 2 slots separados 3 slots.\n- Slots válidos para un campeonato: 1 a 5.\n- Planificación bloqueada el domingo a las 18h.",
		"popup_evol": "- FCM evolucionará con tus ideas.\n- Haz clic en tu temática, sé preciso, seleccionaremos e integraremos tus mejores sugerencias.",
		"btn_bonus": "Bonus", "btn_comp": "Competiciones", "btn_design": "Diseño",
		"btn_others": "Otros", "btn_bugs": "Errores",
		"thanks": "¡Gracias por tu sugerencia!",
		"placeholder": "Escribe tu sugerencia aquí...",
		"send": "Enviar",
		"comps": {
			"champ_classique": "Campeonato Clásico", "coupe_classique": "Copa Clásica",
			"champ_pantheon": "Campeonato Panteón", "coupe_pantheon": "Copa Panteón",
			"champ_jeunes": "Campeonato Juvenil", "coupe_jeunes": "Copa Juvenil",
			"amicaux": "Partidos Amistosos",
		}
	},
	"de": {
		"title_comp": "Nächste Woche Wettbewerbe",
		"title_news": "Newsletter",
		"title_evol": "FCM Evolution",
		"popup_comp": "- FCM passt sich Ihrem Leben an.\n- Wählen Sie wann und was Sie spielen.\n- Planen Sie Ihre Wettbewerbe für nächste Woche.\n- Ziehen / Ablegen. Ziehen / Entfernen.\n- 1 Meisterschaft belegt 2 Slots mit 3 Slots Abstand.\n- Gültige Slots für eine Meisterschaft: 1 bis 5.\n- Planung gesperrt Sonntag um 18 Uhr.",
		"popup_evol": "- FCM entwickelt sich mit Ihren Ideen.\n- Klicken Sie auf Ihr Thema, seien Sie präzise, wir wählen Ihre besten Vorschläge aus.",
		"btn_bonus": "Bonus", "btn_comp": "Wettbewerbe", "btn_design": "Design",
		"btn_others": "Andere", "btn_bugs": "Fehler",
		"thanks": "Danke für Ihren Vorschlag!",
		"placeholder": "Schreiben Sie Ihren Vorschlag hier...",
		"send": "Senden",
		"comps": {
			"champ_classique": "Klassische Meisterschaft", "coupe_classique": "Klassischer Pokal",
			"champ_pantheon": "Pantheon Meisterschaft", "coupe_pantheon": "Pantheon Pokal",
			"champ_jeunes": "Jugend Meisterschaft", "coupe_jeunes": "Jugend Pokal",
			"amicaux": "Freundschaftsspiele",
		}
	},
	"it": {
		"title_comp": "Competizioni prossima settimana",
		"title_news": "Newsletter",
		"title_evol": "FCM Evoluzione",
		"popup_comp": "- FCM si adatta alla tua vita.\n- Scegli quando e cosa giocare.\n- Programma le tue competizioni per la prossima settimana.\n- Trascina / Rilascia. Trascina / Rimuovi.\n- 1 campionato occupa 2 slot distanziati 3 slot.\n- Slot validi per un campionato: da 1 a 5.\n- Pianificazione bloccata domenica alle 18h.",
		"popup_evol": "- FCM evolverà con le tue idee.\n- Clicca sul tuo tema, sii preciso, selezioneremo e integreremo i tuoi suggerimenti.",
		"btn_bonus": "Bonus", "btn_comp": "Competizioni", "btn_design": "Design",
		"btn_others": "Altri", "btn_bugs": "Bug",
		"thanks": "Grazie per il tuo suggerimento!",
		"placeholder": "Scrivi il tuo suggerimento qui...",
		"send": "Invia",
		"comps": {
			"champ_classique": "Campionato Classico", "coupe_classique": "Coppa Classica",
			"champ_pantheon": "Campionato Pantheon", "coupe_pantheon": "Coppa Pantheon",
			"champ_jeunes": "Campionato Giovani", "coupe_jeunes": "Coppa Giovani",
			"amicaux": "Partite Amichevoli",
		}
	},
	"pt": {
		"title_comp": "Competições próxima semana",
		"title_news": "Newsletter",
		"title_evol": "FCM Evolução",
		"popup_comp": "- FCM adapta-se à sua vida.\n- Escolha quando e o que jogar.\n- Programe as suas competições para a próxima semana.\n- Arraste / Solte. Arraste / Remova.\n- 1 campeonato ocupa 2 slots espaçados 3 slots.\n- Slots válidos para um campeonato: 1 a 5.\n- Planeamento bloqueado domingo às 18h.",
		"popup_evol": "- FCM evoluirá com as suas ideias.\n- Clique no seu tema, seja preciso, selecionaremos e integraremos as suas sugestões.",
		"btn_bonus": "Bonus", "btn_comp": "Competições", "btn_design": "Design",
		"btn_others": "Outros", "btn_bugs": "Bugs",
		"thanks": "Obrigado pela sua sugestão!",
		"placeholder": "Escreva a sua sugestão aqui...",
		"send": "Enviar",
		"comps": {
			"champ_classique": "Campeonato Clássico", "coupe_classique": "Copa Clássica",
			"champ_pantheon": "Campeonato Panteão", "coupe_pantheon": "Copa Panteão",
			"champ_jeunes": "Campeonato Jovens", "coupe_jeunes": "Copa Jovens",
			"amicaux": "Jogos Amigáveis",
		}
	},
}

# ── VARIABLES ─────────────────────────────────────────────────────────────────
var lang              : String = "fr"
var on_page2          : bool   = false
var is_locked         : bool   = false
var scroll_y          : float  = 0.0
var popup_comp_visible: bool   = false
var popup_evol_visible: bool   = false
var current_feedback_category : String = ""

# shot_data : clé interne par slot 1-8, "" si vide
var shot_data : Dictionary = {1:"",2:"",3:"",4:"",5:"",6:"",7:"",8:""}

# catalogue_slots : 7 clés fixes, "" si la compétition est dans un shot
var catalogue_slots : Array = []

var drag_active      : bool   = false
var drag_comp_key    : String = ""
var drag_origin_slot : int    = -1  # -1 = depuis catalogue, >0 = depuis shot
var drag_cat_index   : int    = -1  # index dans catalogue_slots
var drag_visual      : Label  = null

var shot_nodes  : Array = []
var cat_labels  : Array = []
var http        : HTTPRequest

# UI feedback
var feedback_overlay  : ColorRect = null
var feedback_lineedit : LineEdit  = null
var feedback_btn_send : Label     = null

# ── NŒUDS ─────────────────────────────────────────────────────────────────────
@onready var txt_title_comp  = $TXT_TitleCompetitions
@onready var btn_help_comp   = $BTN_HelpCompetitions
@onready var txt_popup_comp  = $TXT_PopupCompetitions
@onready var swipe_down      = $Swipe_Down
@onready var bg_catalogue    = $Catalogue/BG_Catalogue

@onready var txt_title_news  = $Page2/TXT_TitleNewsletter
@onready var txt_title_evol  = $Page2/TXT_TitleEvolution
@onready var btn_help_evol   = $Page2/BTN_HelpEvolution
@onready var txt_popup_evol  = $Page2/TXT_PopupEvolution
@onready var swipe_up        = $Page2/Swipe_Up
@onready var txt_bonus       = $Page2/TXT_Bonus
@onready var txt_comp_btn    = $Page2/TXT_Competitions
@onready var txt_design      = $Page2/TXT_Design
@onready var txt_others      = $Page2/TXT_Others
@onready var txt_bugs        = $Page2/TXT_Bugs

# ── READY ─────────────────────────────────────────────────────────────────────
func _ready():
	lang = GameState.language
	http = HTTPRequest.new()
	add_child(http)

	for i in range(1, 9):
		shot_nodes.append(get_node("Shot_%d" % i))
	for i in range(1, 8):
		cat_labels.append(get_node("Catalogue/TXT_Competition%d" % i))

	catalogue_slots = CATALOGUE_KEYS.duplicate()

	_check_lock()
	_apply_translations()
	_setup_shot_times()
	_refresh_shots()
	_refresh_catalogue()
	txt_popup_comp.visible = false
	txt_popup_evol.visible = false

# ── TRADUCTIONS ────────────────────────────────────────────────────────────────
func _apply_translations():
	var t = TRANSLATIONS.get(lang, TRANSLATIONS["fr"])
	txt_title_comp.text = t["title_comp"]
	txt_title_news.text = t["title_news"]
	txt_title_evol.text = t["title_evol"]
	txt_popup_comp.text = t["popup_comp"]
	txt_popup_evol.text = t["popup_evol"]
	txt_bonus.text      = t["btn_bonus"]
	txt_comp_btn.text   = t["btn_comp"]
	txt_design.text     = t["btn_design"]
	txt_others.text     = t["btn_others"]
	txt_bugs.text       = t["btn_bugs"]

func _comp_name(key: String) -> String:
	if key == "": return ""
	var t = TRANSLATIONS.get(lang, TRANSLATIONS["fr"])
	return t["comps"].get(key, key)

# ── VERROUILLAGE ──────────────────────────────────────────────────────────────
func _check_lock():
	var dt = Time.get_date_dict_from_system()
	var tm = Time.get_time_dict_from_system()
	is_locked = (dt["weekday"] == LOCK_DAY and tm["hour"] >= LOCK_HOUR)

# ── CATALOGUE ─────────────────────────────────────────────────────────────────
func _refresh_catalogue():
	for i in range(7):
		var lbl = cat_labels[i]
		var key = catalogue_slots[i]
		if key != "":
			lbl.text     = _comp_name(key)
			lbl.modulate = COMP_COLORS.get(key, Color.WHITE)
			lbl.visible  = true
		else:
			lbl.text    = ""
			lbl.visible = false

# ── SHOTS ─────────────────────────────────────────────────────────────────────
func _setup_shot_times():
	for i in range(1, 9):
		shot_nodes[i-1].get_node("TXT_Time").text = SHOT_TIMES[i-1]

func _refresh_shots():
	for i in range(1, 9):
		var shot     = shot_nodes[i-1]
		var txt_comp = shot.get_node("TXT_Competition")
		var ovl_lock = shot.get_node("OVL_Lock")
		var bg_shot  = shot.get_node("Card_Background_Shot")
		ovl_lock.visible = is_locked
		if shot_data[i] != "":
			var key = shot_data[i]
			txt_comp.text     = _comp_name(key)
			txt_comp.modulate = Color.WHITE
			bg_shot.modulate  = COMP_COLORS.get(key, Color.WHITE)
		else:
			txt_comp.text    = ""
			bg_shot.modulate = Color.WHITE

# ── INPUT ─────────────────────────────────────────────────────────────────────
func _input(event):
	if drag_active and drag_visual:
		if event is InputEventMouseMotion:
			drag_visual.position = event.position - Vector2(50, 20)
		elif event is InputEventScreenDrag:
			drag_visual.position = event.position - Vector2(50, 20)

	var pos     : Vector2 = Vector2.ZERO
	var pressed : bool    = false
	var released: bool    = false

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		pos = event.position
		if event.pressed: pressed = true
		else:             released = true
	elif event is InputEventScreenTouch:
		pos = event.position
		if event.pressed: pressed = true
		else:             released = true
	else:
		return

	if pressed:  _on_press(pos)
	if released: _on_release(pos)

# ── PRESSE ────────────────────────────────────────────────────────────────────
func _on_press(pos: Vector2):
	# Overlay feedback ouvert
	if feedback_overlay != null and feedback_overlay.visible:
		if _label_hit(feedback_btn_send, pos):
			_submit_feedback(); return
		_close_feedback_overlay(); return

	# ── Clic sur popup ouvert → ferme popup ──
	if popup_comp_visible and _label_hit(txt_popup_comp, pos):
		popup_comp_visible = false
		txt_popup_comp.visible = false
		return

	if popup_evol_visible and _label_hit(txt_popup_evol, pos):
		popup_evol_visible = false
		txt_popup_evol.visible = false
		return

	# ── BTN Help ──
	if _sprite_hit_distance(btn_help_comp, pos, 80):
		popup_comp_visible = !popup_comp_visible
		txt_popup_comp.visible = popup_comp_visible
		return

	if _sprite_hit_distance(btn_help_evol, pos, 80):
		popup_evol_visible = !popup_evol_visible
		txt_popup_evol.visible = popup_evol_visible
		return

	# ── Navigation pages ──
	if _sprite_hit_distance(swipe_down, pos, 100) and not on_page2:
		_go_to_page2(); return
	if _sprite_hit_distance(swipe_up, pos, 100) and on_page2:
		_go_to_page1(); return

	# ── Fermer popups si clic ailleurs ──
	if popup_comp_visible:
		popup_comp_visible = false
		txt_popup_comp.visible = false
	if popup_evol_visible:
		popup_evol_visible = false
		txt_popup_evol.visible = false

	# ── Boutons feedback Page2 ──
	if on_page2:
		if _label_hit(txt_bonus,    pos): _open_feedback_overlay("bonus");        return
		if _label_hit(txt_comp_btn, pos): _open_feedback_overlay("competitions"); return
		if _label_hit(txt_design,   pos): _open_feedback_overlay("design");       return
		if _label_hit(txt_others,   pos): _open_feedback_overlay("others");       return
		if _label_hit(txt_bugs,     pos): _open_feedback_overlay("bugs");         return
		return

	if is_locked: return

	# ── Drag depuis catalogue ──
	for i in range(7):
		var lbl = cat_labels[i]
		if lbl.visible and catalogue_slots[i] != "" and _label_hit(lbl, pos):
			_start_drag(catalogue_slots[i], -1, i); return

	# ── Drag depuis shot ──
	for i in range(1, 9):
		var shot = shot_nodes[i-1]
		var bg   = shot.get_node("Card_Background_Shot")
		if shot_data[i] != "" and _sprite_hit(bg, pos):
			_start_drag(shot_data[i], i, -1); return

# ── RELÂCHE ───────────────────────────────────────────────────────────────────
func _on_release(pos: Vector2):
	if not drag_active: return

	# Déposer sur shot
	for i in range(1, 9):
		var shot = shot_nodes[i-1]
		var bg   = shot.get_node("Card_Background_Shot")
		if _sprite_hit(bg, pos):
			_drop_on_shot(i)
			_end_drag(); return

	# Déposer sur catalogue → retirer du/des shot(s)
	if _sprite_hit(bg_catalogue, pos) and drag_origin_slot > 0:
		_remove_from_shots(drag_comp_key)
		if drag_cat_index >= 0:
			catalogue_slots[drag_cat_index] = drag_comp_key
		_refresh_shots()
		_refresh_catalogue()

	_end_drag()

# ── DRAG & DROP ───────────────────────────────────────────────────────────────
func _start_drag(comp_key: String, origin_slot: int, cat_index: int):
	drag_active      = true
	drag_comp_key    = comp_key
	drag_origin_slot = origin_slot
	drag_cat_index   = cat_index
	drag_visual      = Label.new()
	drag_visual.text = _comp_name(comp_key)
	drag_visual.modulate = COMP_COLORS.get(comp_key, Color.WHITE)
	drag_visual.z_index  = 10
	drag_visual.add_theme_font_size_override("font_size", 40)
	drag_visual.position = Vector2(400, 300)
	add_child(drag_visual)

func _end_drag():
	drag_active      = false
	drag_comp_key    = ""
	drag_origin_slot = -1
	drag_cat_index   = -1
	if drag_visual: drag_visual.queue_free(); drag_visual = null

func _remove_from_shots(key: String):
	for k in shot_data:
		if shot_data[k] == key:
			shot_data[k] = ""

func _drop_on_shot(slot: int):
	var is_champ = drag_comp_key.begins_with("champ_")

	if is_champ:
		# Slots valides : 1 à 5 seulement
		if slot > 5:
			_end_drag(); return

		var paired_slot = slot + 3

		# Slot+3 doit être libre ou occupé par la même compétition
		if shot_data[paired_slot] != "" and shot_data[paired_slot] != drag_comp_key:
			_end_drag(); return

		# Si drag depuis shot → libérer les anciens slots
		if drag_origin_slot > 0:
			_remove_from_shots(drag_comp_key)
		else:
			# Vient du catalogue → vider le slot catalogue
			if drag_cat_index >= 0:
				catalogue_slots[drag_cat_index] = ""

		# Placer sur les 2 slots automatiquement
		shot_data[slot]        = drag_comp_key
		shot_data[paired_slot] = drag_comp_key

	else:
		# Coupe ou amicaux → 1 seul slot
		if shot_data[slot] != "":
			_end_drag(); return

		if drag_origin_slot > 0:
			shot_data[drag_origin_slot] = ""
		else:
			if drag_cat_index >= 0:
				catalogue_slots[drag_cat_index] = ""

		shot_data[slot] = drag_comp_key

	_refresh_shots()
	_refresh_catalogue()

# ── NAVIGATION ────────────────────────────────────────────────────────────────
func _go_to_page2():
	if on_page2: return
	on_page2 = true
	var tween = create_tween()
	tween.tween_method(_set_scroll, 0.0, PAGE_HEIGHT, 0.35)

func _go_to_page1():
	if not on_page2: return
	on_page2 = false
	var tween = create_tween()
	tween.tween_method(_set_scroll, PAGE_HEIGHT, 0.0, 0.35)

func _set_scroll(y: float):
	scroll_y = y
	get_viewport().canvas_transform = Transform2D(0, Vector2(0, -y))

# ── OVERLAY FEEDBACK ──────────────────────────────────────────────────────────
func _open_feedback_overlay(category: String):
	current_feedback_category = category
	var t = TRANSLATIONS.get(lang, TRANSLATIONS["fr"])

	feedback_overlay = ColorRect.new()
	feedback_overlay.color = Color(0, 0, 0, 0.85)
	feedback_overlay.set_size(Vector2(1920, 1080))
	feedback_overlay.position = Vector2(0, PAGE_HEIGHT)
	feedback_overlay.z_index = 50
	add_child(feedback_overlay)

	var title = Label.new()
	var cat_key = "btn_" + category if category != "competitions" else "btn_comp"
	title.text = t.get(cat_key, category)
	title.add_theme_font_size_override("font_size", 60)
	title.modulate = Color.CYAN
	title.position = Vector2(760, 1150)
	title.z_index = 51
	add_child(title)

	feedback_lineedit = LineEdit.new()
	feedback_lineedit.placeholder_text = t["placeholder"]
	feedback_lineedit.set_size(Vector2(1400, 100))
	feedback_lineedit.position = Vector2(260, 1300)
	feedback_lineedit.z_index = 51
	feedback_lineedit.add_theme_font_size_override("font_size", 40)
	add_child(feedback_lineedit)
	feedback_lineedit.grab_focus()

	feedback_btn_send = Label.new()
	feedback_btn_send.text = t["send"]
	feedback_btn_send.add_theme_font_size_override("font_size", 55)
	feedback_btn_send.modulate = Color.GREEN
	feedback_btn_send.position = Vector2(860, 1450)
	feedback_btn_send.z_index = 51
	add_child(feedback_btn_send)

func _close_feedback_overlay():
	if feedback_overlay:  feedback_overlay.queue_free();  feedback_overlay  = null
	if feedback_lineedit: feedback_lineedit.queue_free(); feedback_lineedit = null
	if feedback_btn_send: feedback_btn_send.queue_free(); feedback_btn_send = null

func _submit_feedback():
	if feedback_lineedit == null: return
	var message = feedback_lineedit.text.strip_edges()
	if message == "": _close_feedback_overlay(); return

	var t = TRANSLATIONS.get(lang, TRANSLATIONS["fr"])
	var dt = Time.get_date_dict_from_system()
	var date_str = "%d-%02d-%02d" % [dt["year"], dt["month"], dt["day"]]

	var url  = FIREBASE_BASE + "/feedbacks/" + current_feedback_category + "/suggestions"
	var body = JSON.stringify({
		"fields": {
			"message":  {"stringValue": message},
			"category": {"stringValue": current_feedback_category},
			"date":     {"stringValue": date_str},
			"lang":     {"stringValue": lang}
		}
	})
	http.request(url, ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	_close_feedback_overlay()
	_show_thanks()

func _show_thanks():
	var t   = TRANSLATIONS.get(lang, TRANSLATIONS["fr"])
	var lbl = Label.new()
	lbl.text     = t["thanks"]
	lbl.modulate = Color.GREEN
	lbl.position = Vector2(500, 1800)
	lbl.z_index  = 20
	lbl.add_theme_font_size_override("font_size", 50)
	add_child(lbl)
	var tw = create_tween()
	tw.tween_interval(2.5)
	tw.tween_callback(lbl.queue_free)

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _sprite_hit_distance(sprite: Sprite2D, pos: Vector2, radius: float) -> bool:
	if sprite == null or not sprite.visible: return false
	var vp     = get_viewport().get_canvas_transform()
	var center = vp * sprite.global_position
	return pos.distance_to(center) < radius

func _sprite_screen_rect(sprite: Sprite2D) -> Rect2:
	var vp  = get_viewport().get_canvas_transform()
	var ct  = vp * sprite.get_global_transform()
	var r   = sprite.get_rect()
	var tl  = ct * r.position
	var br  = ct * (r.position + r.size)
	var tl2 = ct * Vector2(r.position.x + r.size.x, r.position.y)
	var br2 = ct * Vector2(r.position.x, r.position.y + r.size.y)
	var min_x = min(min(tl.x, br.x), min(tl2.x, br2.x))
	var min_y = min(min(tl.y, br.y), min(tl2.y, br2.y))
	var max_x = max(max(tl.x, br.x), max(tl2.x, br2.x))
	var max_y = max(max(tl.y, br.y), max(tl2.y, br2.y))
	return Rect2(min_x, min_y, max_x - min_x, max_y - min_y)

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return _sprite_screen_rect(sprite).has_point(pos)

func _label_hit(label: Label, pos: Vector2) -> bool:
	if label == null or not label.visible: return false
	var vp = get_viewport().get_canvas_transform()
	var gr = label.get_global_rect()
	var tl = vp * gr.position
	var br = vp * (gr.position + gr.size)
	return Rect2(tl, br - tl).has_point(pos)
