extends Node2D

const SCENE_COLLECTION_COUNTRY = "res://Scenes/collection_country.tscn"
const SLIDE_DURATION            = 0.35
const MAX_CONDITIONS            = 17

const PAGE1_COUNTRIES = [
	"AE","AO","AR","AT","AU","BA","BE","BG","BO","BR",
	"CA","CD","CH","CI","CL","CM","CN","CO","CR","CU",
	"CZ","DE","DK","DZ","EC","EG","ES","FR","GB","GH",
	"GR","HN","HR","HT","HU","ID","IE","IL","IQ","IR"
]
const PAGE2_COUNTRIES = [
	"IT","JM","JP","KP","KR","KW","MA","MX","NG","NI",
	"NL","NO","NZ","PA","PE","PL","PT","PY","QA","RO",
	"RS","RU","SA","SC","SE","SI","SK","SN","SV","TG",
	"TN","TR","TT","UA","US","UY","WA","ZA"
]

var current_page: int = 1
var is_animating: bool = false
var country_progress: Dictionary = {}

@onready var page1         = $Page1
@onready var page2         = $Page2
@onready var btn_next_page = $Page1/BTN_NextPage
@onready var btn_prev_page = $Page2/BTN_PrevPage

func _ready():
	Taskbar.visible = true   # ← manquait : la taskbar n'apparaissait pas sur cette scène
	page2.position.y = 1080.0
	_load_progress()

func _load_progress():
	Firebase.firestore_success.connect(_on_progress_loaded)
	Firebase.firestore_failed.connect(_on_progress_failed)
	Firebase.get_document("managers/" + Firebase.user_id + "/collection", "progress")

func _on_progress_loaded(data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_progress_loaded):
		Firebase.firestore_success.disconnect(_on_progress_loaded)
	if Firebase.firestore_failed.is_connected(_on_progress_failed):
		Firebase.firestore_failed.disconnect(_on_progress_failed)
	for code in PAGE1_COUNTRIES + PAGE2_COUNTRIES:
		country_progress[code] = int(data.get(code, 0))
	_update_counters()

func _on_progress_failed(_error: String):
	if Firebase.firestore_success.is_connected(_on_progress_loaded):
		Firebase.firestore_success.disconnect(_on_progress_loaded)
	if Firebase.firestore_failed.is_connected(_on_progress_failed):
		Firebase.firestore_failed.disconnect(_on_progress_failed)
	_update_counters()

func _update_counters():
	for code in PAGE1_COUNTRIES:
		var node = page1.get_node_or_null(code)
		if node:
			var txt = node.get_node_or_null("TXT_" + code)
			if txt: txt.text = str(country_progress.get(code, 0)) + "/" + str(MAX_CONDITIONS)
	for code in PAGE2_COUNTRIES:
		var node = page2.get_node_or_null(code)
		if node:
			var txt = node.get_node_or_null("TXT_" + code)
			if txt: txt.text = str(country_progress.get(code, 0)) + "/" + str(MAX_CONDITIONS)

func _animate_to_page(page: int):
	if is_animating: return
	is_animating  = true
	current_page  = page
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	if page == 2:
		tween.tween_property(page1, "position:y", -1080.0, SLIDE_DURATION)
		tween.tween_property(page2, "position:y",     0.0, SLIDE_DURATION)
	else:
		tween.tween_property(page1, "position:y",    0.0, SLIDE_DURATION)
		tween.tween_property(page2, "position:y", 1080.0, SLIDE_DURATION)
	tween.chain().tween_callback(func(): is_animating = false)

func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	var pos = event.position

	if _sprite_hit(btn_next_page, pos) and current_page == 1:
		_animate_to_page(2); return
	if _sprite_hit(btn_prev_page, pos) and current_page == 2:
		_animate_to_page(1); return

	var countries = PAGE1_COUNTRIES if current_page == 1 else PAGE2_COUNTRIES
	var page_node = page1          if current_page == 1 else page2
	for code in countries:
		var flag = page_node.get_node_or_null(code + "/Flag_" + code)
		if flag and _sprite_hit(flag, pos):
			GameState.selected_country = code
			GameState.previous_scene   = "res://Scenes/collection_flags.tscn"
			get_tree().change_scene_to_file(SCENE_COLLECTION_COUNTRY)
			return

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
