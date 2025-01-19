extends Control

@onready var mainMenu = "res://Scenes/mainMenu.tscn"  # This stores the scene path

# Fonction appelée pour revenir à la scène précédente
func _on_retour_button_go_to_mainMenu() -> void:
	# Utilisez le Singleton pour accéder à la pile de scènes et revenir à la scène précédente
	NavigationManager.go_back_to_previous_scene()
