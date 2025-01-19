extends Node

# Pile des chemins des scènes précédentes
var previous_scene_paths = []

# Fonction pour ajouter une scène à la pile
func add_scene_to_stack(scene_path: String) -> void:
	print("Nouvelle scene ajouté au stack")
	previous_scene_paths.append(scene_path)

# Fonction pour revenir à la scène précédente
func go_back_to_previous_scene() -> void:
	# Debug print to show the current state of the stack
	print("Stack of previous scenes: ", previous_scene_paths)
	
	if previous_scene_paths.size() > 0:
		var previous_scene_path = previous_scene_paths.pop_back()  # Retirer et récupérer le chemin de la scène précédente
		# Debug print to show the scene that is being popped
		print("Popped previous scene path: ", previous_scene_path)
		
		# Changer de scène en utilisant le chemin
		get_tree().change_scene_to_file(previous_scene_path)
		
		# Debug print after changing scene
		print("Changed to previous scene.")
	else:
		print("Erreur : Aucune scène précédente à laquelle revenir.")
