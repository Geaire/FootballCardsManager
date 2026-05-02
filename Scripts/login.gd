extends Node2D

# ── NŒUDS ─────────────────────────────────────────────────────────────────────
@onready var btn_google = $BTN_Google   # Sprite2D — asset officiel Google
@onready var btn_email  = $BTN_Email    # Label — fond noir arrondi cliquable
@onready var btn_guest  = $BTN_Guest    # Label — fond noir arrondi cliquable

# ── CONSTANTES ────────────────────────────────────────────────────────────────
const SCENE_CREATE_PROFILE = "res://Scenes/create_profile.tscn"
const SCENE_SCHEDULE       = "res://Scenes/schedule.tscn"
const SCENE_LOGIN_EMAIL    = "res://Scenes/login_email.tscn"

# ── READY ──────────────────────────────────────────────────────────────────────
func _ready():
	Taskbar.visible = false
	btn_email.gui_input.connect(_on_btn_email_input)
	btn_guest.gui_input.connect(_on_btn_guest_input)
	Firebase.auth_success.connect(_on_auth_success)
	Firebase.auth_failed.connect(_on_auth_failed)

# ── INPUT BTN_GOOGLE (Sprite2D) ───────────────────────────────────────────────
func _input(event):
	if not (event is InputEventMouseButton): return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed): return
	if _sprite_hit(btn_google, event.position):
		pass  # Google Sign-In — Phase 2

# ── INPUT EMAIL ───────────────────────────────────────────────────────────────
func _on_btn_email_input(event: InputEvent):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		get_tree().change_scene_to_file(SCENE_LOGIN_EMAIL)

# ── INPUT GUEST ───────────────────────────────────────────────────────────────
func _on_btn_guest_input(event: InputEvent):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		Firebase.sign_in_anonymous()

# ── AUTH SUCCESS ──────────────────────────────────────────────────────────────
func _on_auth_success(_user_id: String):
	Firebase.firestore_success.connect(_on_profile_found)
	Firebase.firestore_failed.connect(_on_profile_not_found)
	Firebase.get_document("managers", Firebase.user_id)

func _on_profile_found(_data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_profile_found):
		Firebase.firestore_success.disconnect(_on_profile_found)
	if Firebase.firestore_failed.is_connected(_on_profile_not_found):
		Firebase.firestore_failed.disconnect(_on_profile_not_found)
	get_tree().change_scene_to_file(SCENE_SCHEDULE)

func _on_profile_not_found(_error: String):
	if Firebase.firestore_success.is_connected(_on_profile_found):
		Firebase.firestore_success.disconnect(_on_profile_found)
	if Firebase.firestore_failed.is_connected(_on_profile_not_found):
		Firebase.firestore_failed.disconnect(_on_profile_not_found)
	get_tree().change_scene_to_file(SCENE_CREATE_PROFILE)

func _on_auth_failed(_error: String):
	pass

# ── HIT DETECTION ─────────────────────────────────────────────────────────────
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if sprite == null or not sprite.visible: return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
