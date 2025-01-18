extends Node

# Pile des chemins des scènes précédentes
var previous_scene_paths = []

# Fonction pour ajouter une scène à la pile
func add_scene_to_stack(scene_path: String) -> void:
	previous_scene_paths.append(scene_path)

# Fonction pour revenir à la scène précédente
func go_back_to_previous_scene() -> void:
	if previous_scene_paths.size() > 0:
		var previous_scene_path = previous_scene_paths.pop_back()  # Retirer et récupérer le chemin de la scène précédente
		# Changer de scène en utilisant le chemin
		get_tree().change_scene(previous_scene_path)
	else:
		print("Erreur : Aucune scène précédente à laquelle revenir.")
