extends Node2D

var area2d_instance : Area2D
var staticbody_instance : StaticBody2D
var key_count = 0
@onready var panelGagner = $UI/PanelGagner
var next_level_button : Button
var movement_enabled = true  

func _ready():
	update_key_count_display()
	panelGagner.visible = false
	
func update_key_count_display():
	$CanvasLayer/KeyCounterLabel.text = " Score: %d / 5" % key_count

func add_key():
	key_count += 1
	update_key_count_display()
	print("Key count:", key_count)
	
	if key_count == 5:
		print("Show win panel.")
		show_win_popup()

func handle_character_movement(delta):
	if movement_enabled:
		if Input.is_action_pressed("ui_right"):
			position.x += 100 * delta
		elif Input.is_action_pressed("ui_left"):
			position.x -= 100 * delta

func _process(delta):
	handle_character_movement(delta)

func _on_next_level_button_pressed():
	print("Moving to the next level...")
	get_tree().change_scene_to_file("res://Scenes/niveau2.tscn")
	
func show_win_popup():
	# Assurez-vous que le panneau est visible
	panelGagner.visible = true
	print("Panel found. Making it visible.")  # Debug : le panneau est trouvé
	print("Panel visibility set to: ", panelGagner.visible)
	
	# Afficher le texte "C'est gagné"
	var label = panelGagner.get_node("BoxContainer/Label")  # Assurez-vous d'avoir un label dans le panneau
	label.text = "C'est gagné. Passe au niveau suivant !"

	# Assurez-vous d'avoir une référence au bouton dans le panneau
	next_level_button = panelGagner.get_node("BoxContainer/NextLevelButton")  # Assurez-vous que le bouton s'appelle "NextLevelButton"
	
	# Connecte correctement l'événement "pressed" à la méthode
	next_level_button.connect("pressed", Callable(self, "_on_next_level_button_pressed"))

	# Débogage de la position initiale du panneau
	print("Initial Panel position: ", panelGagner.position)  # Affiche la position actuelle du panneau
	
	# Calculer la taille de l'écran du joueur (taille de la fenêtre du jeu)
	var screen_size = get_viewport().size  # Cela donne la taille de la fenêtre du jeu
	print("Screen size: ", screen_size)  # Déboguer la taille de l'écran

	# Ajuster la taille du panneau pour qu'il remplisse l'écran
	panelGagner.rect_min_size = screen_size  # Assure que le panneau prend toute la place

	# Placer le panneau dans la position (0,0) pour qu'il commence en haut à gauche
	panelGagner.position = Vector2(0, 0)
	
	# Assurez-vous que le panneau soit au-dessus des autres éléments
	panelGagner.z_index = 10  # On place le panneau en haut des autres éléments UI
	print("Panel Z-Index: ", panelGagner.z_index)  # Déboguer le Z-Index pour vérifier

	# Optionnel : changer la couleur du panneau pour le rendre plus visible
	panelGagner.modulate = Color(0, 1, 0)  # Colore le panneau en vert pour le tester

	# Désactiver les contrôles du personnage
	set_process(false)



func _on_next_level_button_pressed_mainMenu() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
