extends Control

@onready var mainScene = preload("res://Scenes/mainScene.tscn")  # Préchargement de la scène principale
@onready var creditsScene = preload("res://Scenes/credits.tscn")  # Préchargement de la scène des crédits

# Fonction pour démarrer une nouvelle partie
func _on_nouvelle_partie_button_go_to_game() -> void:
	# Ajouter la scène actuelle à la pile via NavigationManager pour pouvoir revenir en arrière
	NavigationManager.add_scene_to_stack("res://Scenes/mainScene.tscn")
	# Changer la scène pour la scène de jeu
	get_tree().change_scene_to_file("res://Scenes/mainScene.tscn")

# Fonction pour afficher les crédits
func _on_credits_button_credits() -> void:
	# Ajouter la scène actuelle à la pile via NavigationManager
	NavigationManager.add_scene_to_stack("res://Scenes/credits.tscn")
	# Changer la scène pour les crédits
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

# Fonction pour quitter l'application
func _on_quitter_button_down_quit() -> void:
	get_tree().quit()
