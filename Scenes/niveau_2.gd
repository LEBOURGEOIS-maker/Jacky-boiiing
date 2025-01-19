extends Node2D

var area2d_instance : Area2D
var staticbody_instance : StaticBody2D
var key_count = 0
@onready var panelGagner = $UI/PanelGagner
var next_level_button : Button
var movement_enabled = true  

@onready var mainMenu = preload("res://Scenes/mainMenu.tscn")  # Préchargement de la scène des crédits
#@onready var mainMenu = "res://Scenes/mainMenu.tscn"


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
	var tree = get_tree()
	if tree == null:
		print("Scene tree is null!")
	else:
		tree.change_scene("res://Scenes/mainMenu.tscn")

	
func show_win_popup():
	panelGagner.visible = true
	print("Panel found. Making it visible.")  # Debug : le panneau est trouvé
	print("Panel visibility set to: ", panelGagner.visible)
	
	# Afficher le texte "C'est gagné"
	var label = panelGagner.get_node("BoxContainer/Label")  # Assurez-vous d'avoir un label dans le panneau
	label.text = "C'est gagné. Retour au menu amigo!"

	# Assurez-vous d'avoir une référence au bouton dans le panneau
	next_level_button = panelGagner.get_node("BoxContainer/NextLevelButton")  # Assurez-vous que le bouton s'appelle "NextLevelButton"
	
	# Connecte correctement l'événement "pressed" à la méthode
	next_level_button.connect("pressed", Callable(self, "_on_next_level_button_pressed"))

	# Débogage de la position initiale du panneau
	print("Initial Panel position: ", panelGagner.position)  # Affiche la position actuelle du panneau
	
	# Obtenez la position du joueur (assurez-vous que `Player` est un autre Node2D que vous référencez ici)
	var player_position = $Player.position  # Remplace "Player" par le nom de ton nœud personnage si nécessaire
	print("Player position: ", player_position)  # Déboguer la position du joueur

	# Taille du panneau
	var panel_size = panelGagner.get_size()  # Obtenez la taille réelle du panneau
	print("Panel size: ", panel_size)  # Déboguer la taille du panneau

	# Calculer la position du panneau pour le centrer sur le joueur
	var x_position = player_position.x - (panel_size.x / 2)  # Centrer sur l'axe X
	var y_position = player_position.y - (panel_size.y / 2)  # Centrer sur l'axe Y

	# Afficher la position calculée du panneau
	print("Calculated Panel position: ", Vector2(x_position, y_position))  # Debug de la position calculée

	# Positionner le panneau
	panelGagner.position = Vector2(x_position + 200, y_position + 150)

	# Assurez-vous que le panneau soit au-dessus des autres éléments
	panelGagner.z_index = 10  # On place le panneau en haut des autres éléments UI
	print("Panel Z-Index: ", panelGagner.z_index)  # Déboguer le Z-Index pour vérifier

	# Optionnel : changer la couleur du panneau pour le rendre plus visible
	panelGagner.modulate = Color(0, 1, 0)  # Colore le panneau en vert pour le tester

	# Désactiver les contrôles du personnage
	set_process(false)


func _on_next_level_button_pressed_mainMenu() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainMenu.tscn")
