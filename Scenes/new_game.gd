extends Control

@onready var niveau1 = preload("res://Scenes/niveau1.tscn")  # Préchargement de la scène principale
@onready var niveau2 = preload("res://Scenes/niveau2.tscn")  # Préchargement de la scène des crédits
@onready var mainMenu = "res://Scenes/mainMenu.tscn"


func _on_niveau_1_pressed_level1() -> void:
	NavigationManager.add_scene_to_stack("res://Scenes/mainMenu.tscn")
	get_tree().change_scene_to_file("res://Scenes/niveau1.tscn")

func _on_niveau_2_pressed_level2() -> void:
	NavigationManager.add_scene_to_stack("res://Scenes/mainMenu.tscn")
	get_tree().change_scene_to_file("res://Scenes/niveau2.tscn")

func _on_retour_pressed_back_to_menu() -> void: 
	NavigationManager.go_back_to_previous_scene()
