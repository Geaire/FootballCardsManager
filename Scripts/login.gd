extends Node2D

# --- NOEUDS ---
@onready var card_google = $CardbackgroundGoogle
@onready var card_email = $CardbackgroundEmail
@onready var card_guest = $CardbackgroundGuest
@onready var txt_sign_google = $TXT_SignInWithGoogle
@onready var txt_sign_email = $TXT_SignInWithEmail
@onready var txt_play_guest = $TXT_PlayAsGuest

# --- TRADUCTIONS ---
const TRANSLATIONS = {
	"fr": {
		"google": "Sign in with Google",
		"email": "Sign in with Email",
		"guest": "Play as Guest"
	},
	"en": {
		"google": "Sign in with Google",
		"email": "Sign in with Email",
		"guest": "Play as Guest"
	},
	"es": {
		"google": "Sign in with Google",
		"email": "Sign in with Email",
		"guest": "Jugar como invitado"
	},
	"de": {
		"google": "Sign in with Google",
		"email": "Sign in with Email",
		"guest": "Als Gast spielen"
	},
	"it": {
		"google": "Sign in with Google",
		"email": "Sign in with Email",
		"guest": "Gioca come ospite"
	},
	"pt": {
		"google": "Sign in with Google",
		"email": "Sign in with Email",
		"guest": "Jogar como convidado"
	}
}

const SCENE_CREATE_PROFILE = "res://Scenes/create_profile.tscn"
const SCENE_LOGIN_EMAIL = "res://Scenes/login_email.tscn"

# --- READY ---
func _ready():
	_apply_translations()
	Firebase.auth_success.connect(_on_auth_success)
	Firebase.auth_failed.connect(_on_auth_failed)

func _apply_translations():
	var t = TRANSLATIONS[GameState.language]
	txt_sign_google.text = t["google"]
	txt_sign_email.text = t["email"]
	txt_play_guest.text = t["guest"]

# --- INPUT ---
func _input(event):
	if not (event is InputEventMouseButton):
		return
	if not (event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		return
	var pos = event.position

	if _sprite_hit(card_google, pos):
		# Google Sign In - Phase 2 Firebase
		pass
		return

	if _sprite_hit(card_email, pos):
		get_tree().change_scene_to_file(SCENE_LOGIN_EMAIL)
		return

	if _sprite_hit(card_guest, pos):
		Firebase.sign_in_anonymous()
		return

# --- CALLBACKS ---
func _on_auth_success(_user_id: String):
	get_tree().change_scene_to_file(SCENE_CREATE_PROFILE)

func _on_auth_failed(error: String):
	print("Erreur connexion : " + error)

# --- UTILITAIRES ---
func _sprite_hit(sprite: Sprite2D, pos: Vector2) -> bool:
	if not sprite.visible:
		return false
	return sprite.get_rect().has_point(sprite.to_local(pos))
