extends Node

# --- CONSTANTES FIREBASE ---
const API_KEY = "AIzaSyBNt1WyCmqC8RKG1qJb4s1LHrxwDduWF_0"
const PROJECT_ID = "football-cards-manager"
const AUTH_URL = "https://identitytoolkit.googleapis.com/v1/accounts:"
const FIRESTORE_URL = "https://firestore.googleapis.com/v1/projects/" + PROJECT_ID + "/databases/(default)/documents/"

# --- DONNEES MANAGER CONNECTE ---
var id_token: String = ""
var refresh_token: String = ""
var user_id: String = ""
var manager_email: String = ""
var manager_connected: bool = false

# --- SIGNAUX ---
signal auth_success(user_id: String)
signal auth_failed(error: String)
signal firestore_success(data: Dictionary)
signal firestore_failed(error: String)

# --- AUTHENTIFICATION ---
func sign_up(email: String, password: String):
	var url = AUTH_URL + "signUp?key=" + API_KEY
	var body = JSON.stringify({
		"email": email,
		"password": password,
		"returnSecureToken": true
	})
	_send_request(url, body, "_on_auth_response")

func sign_in(email: String, password: String):
	var url = AUTH_URL + "signInWithPassword?key=" + API_KEY
	var body = JSON.stringify({
		"email": email,
		"password": password,
		"returnSecureToken": true
	})
	_send_request(url, body, "_on_auth_response")

func sign_in_anonymous():
	var url = AUTH_URL + "signUp?key=" + API_KEY
	var body = JSON.stringify({"returnSecureToken": true})
	_send_request(url, body, "_on_auth_response")

func sign_out():
	id_token = ""
	refresh_token = ""
	user_id = ""
	manager_email = ""
	manager_connected = false

# --- FIRESTORE ---
func create_document(collection: String, doc_id: String, data: Dictionary):
	var url = FIRESTORE_URL + collection + "/" + doc_id
	var body = JSON.stringify({"fields": _to_firestore(data)})
	_send_request_auth(url, body, "_on_firestore_response", HTTPClient.METHOD_PATCH)

func get_document(collection: String, doc_id: String):
	var url = FIRESTORE_URL + collection + "/" + doc_id
	_send_request_auth(url, "", "_on_firestore_response", HTTPClient.METHOD_GET)

func update_document(collection: String, doc_id: String, data: Dictionary):
	var url = FIRESTORE_URL + collection + "/" + doc_id
	var body = JSON.stringify({"fields": _to_firestore(data)})
	_send_request_auth(url, body, "_on_firestore_response", HTTPClient.METHOD_PATCH)

# --- HTTP ---
func _send_request(url: String, body: String, callback: String):
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(Callable(self, callback).bind(http))
	var headers = ["Content-Type: application/json"]
	http.request(url, headers, HTTPClient.METHOD_POST, body)

func _send_request_auth(url: String, body: String, callback: String, method: int):
	var http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(Callable(self, callback).bind(http))
	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer " + id_token
	]
	http.request(url, headers, method, body)

# --- CALLBACKS ---
func _on_auth_response(_result, response_code, _headers, body, http):
	http.queue_free()
	var response = JSON.parse_string(body.get_string_from_utf8())
	if response_code == 200:
		id_token = response.get("idToken", "")
		refresh_token = response.get("refreshToken", "")
		user_id = response.get("localId", "")
		manager_email = response.get("email", "")
		manager_connected = true
		emit_signal("auth_success", user_id)
	else:
		var error = response.get("error", {}).get("message", "Erreur inconnue")
		emit_signal("auth_failed", error)

func _on_firestore_response(_result, response_code, _headers, body, http):
	http.queue_free()
	var response = JSON.parse_string(body.get_string_from_utf8())
	if response_code in [200, 201]:
		emit_signal("firestore_success", _from_firestore(response))
	else:
		var error = response.get("error", {}).get("message", "Erreur inconnue")
		emit_signal("firestore_failed", error)

# --- CONVERSION FIRESTORE ---
func _to_firestore(data: Dictionary) -> Dictionary:
	var fields = {}
	for key in data:
		var val = data[key]
		if typeof(val) == TYPE_STRING:
			fields[key] = {"stringValue": val}
		elif typeof(val) == TYPE_INT:
			fields[key] = {"integerValue": str(val)}
		elif typeof(val) == TYPE_FLOAT:
			fields[key] = {"doubleValue": val}
		elif typeof(val) == TYPE_BOOL:
			fields[key] = {"booleanValue": val}
		elif typeof(val) == TYPE_DICTIONARY:
			fields[key] = {"mapValue": {"fields": _to_firestore(val)}}
		elif typeof(val) == TYPE_ARRAY:
			var arr = []
			for item in val:
				arr.append({"stringValue": str(item)})
			fields[key] = {"arrayValue": {"values": arr}}
	return fields

func _from_firestore(data: Dictionary) -> Dictionary:
	var result = {}
	var fields = data.get("fields", {})
	for key in fields:
		var field = fields[key]
		if field.has("stringValue"):
			result[key] = field["stringValue"]
		elif field.has("integerValue"):
			result[key] = int(field["integerValue"])
		elif field.has("doubleValue"):
			result[key] = field["doubleValue"]
		elif field.has("booleanValue"):
			result[key] = field["booleanValue"]
		elif field.has("mapValue"):
			result[key] = _from_firestore(field["mapValue"])
		elif field.has("arrayValue"):
			var arr = []
			for item in field["arrayValue"].get("values", []):
				arr.append(item.get("stringValue", ""))
			result[key] = arr
	return result
