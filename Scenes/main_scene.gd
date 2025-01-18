extends Node2D

var area2d_instance : Area2D
var staticbody_instance : StaticBody2D
var key_count = 0
@onready var panelGagner = $UI/PanelGagner
var next_level_button : Button
var movement_enabled = true  # Variable to control character movement

func _ready():
	update_key_count_display()
	panelGagner.visible = false  # Assurez-vous que le panneau "Perdu" est caché au départ
	
	
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
		if Input.is_action_pressed("move_right"):
			position.x += 100 * delta
		elif Input.is_action_pressed("move_left"):
			position.x -= 100 * delta

func _process(delta):
	handle_character_movement(delta)

func _on_next_level_button_pressed():
	print("Moving to the next level...")
	get_tree().change_scene("res://Scenes/menu_scene.tscn")  # Update with the correct path to the next scene


func show_win_popup():
	# Afficher le panneau "Perdu"
	panelGagner.visible = true
	
	# Débogage : Affiche des informations sur le panneau
	print("Panel found. Making it visible.")
	print("Panel visibility set to: ", panelGagner.visible)
	print("Panel position: ", panelGagner.position)
	
	# Placer le panneau dans le coin supérieur droit
	var screen_size = get_viewport().size  # Taille de l'écran (viewport)
	# Calculer la position pour placer le panneau dans le coin supérieur droit
	panelGagner.position = Vector2(screen_size.x - panelGagner.rect_min_size.x, 0)  # Corner position (top-right)
	panelGagner.z_index = 10  # Mettre le panneau au-dessus des autres éléments
	print("Panel position updated to: ", panelGagner.position)  # Debug : afficher la nouvelle position du panneau
	
	# Désactiver les contrôles après affichage du message
	set_process(false)  # Arrêter les mises à jour après l'affichage du message
