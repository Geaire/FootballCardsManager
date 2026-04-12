extends Node2D

@onready var lineedit_email            = $LineEdit_Email
@onready var lineedit_password         = $LineEdit_Password
@onready var btn_login                 = $BTN_Login
@onready var btn_signup                = $BTN_SignUp
@onready var txt_title                 = $TXT_Title
@onready var txt_email                 = $TXT_Email
@onready var txt_password              = $TXT_Password
@onready var txt_login                 = $TXT_Login
@onready var txt_signup                = $TXT_SignUp
@onready var txt_incorrect_email       = $TXT_IncorrectEmail
@onready var txt_incorrect_password    = $TXT_IncorrectPassword
@onready var txt_forgot_password       = $TXT_ForgotPassword
@onready var lineedit_forgot_password  = $LineEdit_ForgotPassword
@onready var btn_send_reset            = $BTN_SendReset
@onready var txt_send_reset            = $TXT_SendReset
@onready var txt_reset_confirm         = $TXT_ResetConfirm

const TRANSLATIONS = {
	"fr": {
		"title":              "Football Cards Manager",
		"email":              "Email",
		"password":           "Mot de passe",
		"login":              "Connexion",
		"signup":             "Creer un compte",
		"forgot":             "Mot de passe oublie ?\nEntrez votre Email",
		"send_reset":         "Envoyer",
		"reset_confirm":      "Email envoye ! Consultez vos spams.",
		"incorrect_email":    "Email incorrect",
		"incorrect_password": "Mot de passe incorrect",
		"error_signup":       "Compte deja existant ou email invalide."
	},
	"en": {
		"title":              "Football Cards Manager",
		"email":              "Email",
		"password":           "Password",
		"login":              "Login",
		"signup":             "Create account",
		"forgot":             "Forgot Password?\nEnter your Email",
		"send_reset":         "Send Reset",
		"reset_confirm":      "Email sent ! Check your spam folder.",
		"incorrect_email":    "Incorrect Email",
		"incorrect_password": "Incorrect Password",
		"error_signup":       "Account already exists or invalid email."
	},
	"es": {
		"title":              "Football Cards Manager",
		"email":              "Email",
		"password":           "Contrasena",
		"login":              "Iniciar sesion",
		"signup":             "Crear cuenta",
		"forgot":             "Olvido su contrasena?\nIngrese su Email",
		"send_reset":         "Enviar",
		"reset_confirm":      "Email enviado ! Revise su spam.",
		"incorrect_email":    "Email incorrecto",
		"incorrect_password": "Contrasena incorrecta",
		"error_signup":       "Cuenta existente o email invalido."
	},
	"de": {
		"title":              "Football Cards Manager",
		"email":              "Email",
		"password":           "Passwort",
		"login":              "Anmelden",
		"signup":             "Konto erstellen",
		"forgot":             "Passwort vergessen?\nEmail eingeben",
		"send_reset":         "Senden",
		"reset_confirm":      "E-Mail gesendet ! Spam-Ordner prufen.",
		"incorrect_email":    "Falsche Email",
		"incorrect_password": "Falsches Passwort",
		"error_signup":       "Konto existiert oder Email ungultig."
	},
	"it": {
		"title":              "Football Cards Manager",
		"email":              "Email",
		"password":           "Password",
		"login":              "Accedi",
		"signup":             "Crea account",
		"forgot":             "Password dimenticata?\nInserisci la tua Email",
		"send_reset":         "Invia",
		"reset_confirm":      "Email inviata ! Controlla lo spam.",
		"incorrect_email":    "Email errata",
		"incorrect_password": "Password errata",
		"error_signup":       "Account esistente o email non valida."
	},
	"pt": {
		"title":              "Football Cards Manager",
		"email":              "Email",
		"password":           "Senha",
		"login":              "Entrar",
		"signup":             "Criar conta",
		"forgot":             "Esqueceu a senha?\nDigite seu Email",
		"send_reset":         "Enviar",
		"reset_confirm":      "Email enviado ! Verifique o spam.",
		"incorrect_email":    "Email incorreto",
		"incorrect_password": "Senha incorreta",
		"error_signup":       "Conta existente ou email invalido."
	}
}

const SCENE_CREATE_PROFILE = "res://Scenes/create_profile.tscn"
const SCENE_MAIN_MENU      = "res://Scenes/main_menu.tscn"

var _mode: String = ""  # "login" ou "signup"

func _ready():
	_apply_translations()
	txt_incorrect_email.visible      = false
	txt_incorrect_password.visible   = false
	txt_forgot_password.visible      = false
	lineedit_forgot_password.visible = false
	btn_send_reset.visible           = false
	txt_send_reset.visible           = false
	txt_reset_confirm.visible        = false
	Firebase.auth_success.connect(_on_auth_success)
	Firebase.auth_failed.connect(_on_auth_failed)
	Firebase.password_reset_success.connect(_on_password_reset_success)

func _exit_tree():
	if Firebase.auth_success.is_connected(_on_auth_success):
		Firebase.auth_success.disconnect(_on_auth_success)
	if Firebase.auth_failed.is_connected(_on_auth_failed):
		Firebase.auth_failed.disconnect(_on_auth_failed)
	if Firebase.password_reset_success.is_connected(_on_password_reset_success):
		Firebase.password_reset_success.disconnect(_on_password_reset_success)

func _apply_translations():
	var t = TRANSLATIONS[GameState.language]
	txt_title.text              = t["title"]
	txt_email.text              = t["email"]
	txt_password.text           = t["password"]
	txt_login.text              = t["login"]
	txt_signup.text             = t["signup"]
	txt_forgot_password.text    = t["forgot"]
	txt_send_reset.text         = t["send_reset"]
	txt_incorrect_email.text    = t["incorrect_email"]
	txt_incorrect_password.text = t["incorrect_password"]

func _input(event):
	if not (event is InputEventMouseButton):
		return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	var pos = event.position
	if _sprite_hit(btn_login, pos):
		_mode = "login"
		_try_auth()
		return
	if _sprite_hit(btn_signup, pos):
		_mode = "signup"
		_try_auth()
		return
	if _label_hit(txt_forgot_password, pos):
		lineedit_forgot_password.visible = true
		btn_send_reset.visible           = true
		txt_send_reset.visible           = true
		return
	if _sprite_hit(btn_send_reset, pos):
		_send_reset()
		return

func _try_auth():
	var email    = lineedit_email.text.strip_edges()
	var password = lineedit_password.text.strip_edges()
	txt_incorrect_email.visible    = false
	txt_incorrect_password.visible = false
	if not _is_valid_email(email):
		txt_incorrect_email.visible = true
		return
	if password.length() < 6:
		txt_incorrect_password.visible = true
		return
	if _mode == "login":
		Firebase.sign_in(email, password)
	else:
		Firebase.sign_up(email, password)

func _send_reset():
	var email = lineedit_forgot_password.text.strip_edges()
	if not _is_valid_email(email):
		txt_incorrect_email.visible = true
		return
	Firebase.send_password_reset(email)

func _on_password_reset_success():
	var t = TRANSLATIONS[GameState.language]
	txt_reset_confirm.text           = t["reset_confirm"]
	txt_reset_confirm.visible        = true
	btn_send_reset.visible           = false
	lineedit_forgot_password.visible = false
	txt_send_reset.visible           = false

func _on_auth_success(_user_id: String):
	Firebase.firestore_success.connect(_on_profile_found)
	Firebase.firestore_failed.connect(_on_profile_not_found)
	Firebase.get_document("managers", Firebase.user_id)

func _on_profile_found(_data: Dictionary):
	if Firebase.firestore_success.is_connected(_on_profile_found):
		Firebase.firestore_success.disconnect(_on_profile_found)
	if Firebase.firestore_failed.is_connected(_on_profile_not_found):
		Firebase.firestore_failed.disconnect(_on_profile_not_found)
	get_tree().change_scene_to_file(SCENE_MAIN_MENU)

func _on_profile_not_found(_error: String):
	if Firebase.firestore_success.is_connected(_on_profile_found):
		Firebase.firestore_success.disconnect(_on_profile_found)
	if Firebase.firestore_failed.is_connected(_on_profile_not_found):
		Firebase.firestore_failed.disconnect(_on_profile_not_found)
	get_tree().change_scene_to_file(SCENE_CREATE_PROFILE)

func _on_auth_failed(_error: String):
	print("AUTH FAILED: " + _error)
	var t = TRANSLATIONS[GameState.language]
	if _mode == "signup":
		txt_incorrect_email.text    = t["error_signup"]
		txt_incorrect_email.visible = true
	else:
		txt_incorrect_password.visible = true
		txt_forgot_password.visible    = true

func _is_valid_email(email: String) -> bool:
	return "@" in email and "." in email

func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if not sprite.visible:
		return false
	return sprite.get_rect().has_point(sprite.to_local(pos))

func _label_hit(label: Label, pos: Vector2) -> bool:
	if not label.visible:
		return false
	return label.get_global_rect().has_point(pos)
