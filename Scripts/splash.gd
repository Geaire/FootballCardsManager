extends Node2D


@onready var bar_loading = $BAR_Loading


const SCENE_NOTIFICATIONS = "res://Scenes/notifications.tscn"

const SCENE_MAIN_MENU     = "res://Scenes/main_menu.tscn"

const LOAD_DURATION       = 3.0


func _ready():

	bar_loading.value = 0

	_animate_bar()


func _animate_bar():

	var tween = create_tween()

	tween.tween_property(bar_loading, "value", 100, LOAD_DURATION)

	tween.tween_callback(_on_loading_complete)


func _on_loading_complete():

	if Firebase.manager_connected:

		get_tree().change_scene_to_file(SCENE_MAIN_MENU)

	else:

		get_tree().change_scene_to_file(SCENE_NOTIFICATIONS)
