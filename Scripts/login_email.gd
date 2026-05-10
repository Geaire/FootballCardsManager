extends Node2D

# ── NŒUDS ─────────────────────────────────────────────────────────────────────
@onready var inp_email              = $INP_Email
@onready var inp_password           = $INP_Password
@onready var lbl_incorrect_email    = $LBL_IncorrectEmail
@onready var lbl_incorrect_password = $LBL_IncorrectPassword
@onready var btn_login              = $BTN_Login
@onready var btn_signup             = $BTN_SignUp
@onready var btn_forgot             = $BTN_ForgotPassword
@onready var inp_forgot             = $INP_ForgotPassword
@onready var img_send_reset         = $IMG_SendReset
@onready var btn_send_reset         = $BTN_SendReset
@onready var lbl_reset_confirm      = $LBL_ResetConfirm

# ── CONSTANTES ────────────────────────────────────────────────────────────────
const SCENE_CREATE_PROFILE = "res://Scenes/create_profile.tscn"
const SCENE_SCHEDULE       = "res://Scenes/schedule.tscn"
const MAX_EMAIL_LENGTH     = 100
const MAX_PASSWORD_LENGTH  = 50

var _mode: String = ""

# ── READY ──────────────────────────────────────────────────────────────────────
func _ready():
	Taskbar.visible = false
	lbl_incorrect_email.visible    = false
	lbl_incorrect_password.visible = false
	btn_forgot.visible             = false
	inp_forgot.visible             = false
	img_send_reset.visible         = false
	btn_send_reset.visible         = false
	lbl_reset_confirm.visible      = false
	inp_email.max_length    = MAX_EMAIL_LENGTH
	inp_password.max_length = MAX_PASSWORD_LENGTH
	inp_forgot.max_length   = MAX_EMAIL_LENGTH
	btn_login.gui_input.connect(_on_btn_login_input)
	btn_signup.gui_input.connect(_on_btn_signup_input)
	btn_forgot.gui_input.connect(_on_btn_forgot_input)
	btn_send_reset.gui_input.connect(_on_btn_send_reset_input)
	Firebase.auth_success.connect(_on_auth_success)
	Firebase.auth_failed.connect(_on_auth_failed)
	Firebase.password_reset_success.connect(_on_password_reset_success)

# ── LOGIN / SIGNUP ─────────────────────────────────────────────────────────────
func _on_btn_login_input(event: InputEvent):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		_mode = "login"; _try_auth()

func _on_btn_signup_input(event: InputEvent):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		_mode = "signup"; _try_auth()

func _try_auth():
	var email    = inp_email.text.strip_edges()
	var password = inp_password.text.strip_edges()
	lbl_incorrect_email.visible    = false
	lbl_incorrect_password.visible = false
	if not _is_valid_email(email):
		lbl_incorrect_email.visible = true; return
	if password.length() < 6:
		lbl_incorrect_password.visible = true; return
	if _mode == "login": Firebase.sign_in(email, password)
	else:                Firebase.sign_up(email, password)

# ── MOT DE PASSE OUBLIÉ ───────────────────────────────────────────────────────
func _on_btn_forgot_input(event: InputEvent):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		inp_forgot.visible     = true
		img_send_reset.visible = true
		btn_send_reset.visible = true

func _on_btn_send_reset_input(event: InputEvent):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		_send_reset()

func _send_reset():
	var email = inp_forgot.text.strip_edges()
	lbl_incorrect_email.visible = false
	if not _is_valid_email(email):
		lbl_incorrect_email.visible = true; return
	Firebase.send_password_reset(email)

func _on_password_reset_success():
	inp_forgot.visible        = false
	img_send_reset.visible    = false
	btn_send_reset.visible    = false
	lbl_reset_confirm.visible = true

# ── AUTH SUCCESS ──────────────────────────────────────────────────────────────
func _on_auth_success(_user_id: String):
	# Vérifier avant de connecter — évite "signal already connected"
	if not Firebase.firestore_success.is_connected(_on_profile_found):
		Firebase.firestore_success.connect(_on_profile_found)
	if not Firebase.firestore_failed.is_connected(_on_profile_not_found):
		Firebase.firestore_failed.connect(_on_profile_not_found)
	Firebase.get_document("managers", Firebase.user_id)

func _on_profile_found(_data: Dictionary):
	_disconnect_profile_signals()
	get_tree().change_scene_to_file(SCENE_SCHEDULE)

func _on_profile_not_found(_error: String):
	_disconnect_profile_signals()
	get_tree().change_scene_to_file(SCENE_CREATE_PROFILE)

func _disconnect_profile_signals():
	if Firebase.firestore_success.is_connected(_on_profile_found):
		Firebase.firestore_success.disconnect(_on_profile_found)
	if Firebase.firestore_failed.is_connected(_on_profile_not_found):
		Firebase.firestore_failed.disconnect(_on_profile_not_found)

func _on_auth_failed(_error: String):
	if _mode == "signup":
		lbl_incorrect_email.visible = true
	else:
		lbl_incorrect_password.visible = true
		btn_forgot.visible             = true

# ── VALIDATION ────────────────────────────────────────────────────────────────
func _is_valid_email(email: String) -> bool:
	return "@" in email and "." in email and email.length() > 5

# ── NETTOYAGE ─────────────────────────────────────────────────────────────────
func _exit_tree():
	if Firebase.auth_success.is_connected(_on_auth_success):
		Firebase.auth_success.disconnect(_on_auth_success)
	if Firebase.auth_failed.is_connected(_on_auth_failed):
		Firebase.auth_failed.disconnect(_on_auth_failed)
	if Firebase.password_reset_success.is_connected(_on_password_reset_success):
		Firebase.password_reset_success.disconnect(_on_password_reset_success)
	_disconnect_profile_signals()
