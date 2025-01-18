extends Control

@onready var mainMenu = preload("res://Scenes/mainMenu.tscn")

func _on_retour_button_go_to_mainMenu() -> void:
	get_tree().change_scene_to_packed(mainMenu)
