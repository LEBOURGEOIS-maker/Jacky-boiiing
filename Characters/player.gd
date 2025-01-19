extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0,1)
@export var timer_duration : float = 70  # Set the timer duration in seconds

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")

@export var tilemap_path: NodePath  # Chemin vers le TileMap
var tilemap: TileMapLayer
var is_game_over : bool = false  # Variable pour gérer l'état du jeu (perdu ou non)
var timer : float = timer_duration  # Timer initialized with duration
var elapsed_time : float = 0  # Track elapsed time

@onready var lose_panel = get_parent().get_node("UI/PanelPerdu")
@onready var timer_panel = get_parent().get_node("UI/TimerPanel")  # Panel where the timer will be shown
@onready var timer_label = timer_panel.get_node("Label")  

# Optional initial movement for testing
var initial_velocity = Vector2.ZERO
# Variables pour l'inversion des déplacements
var x_inverted = false
var y_inverted = false
var beer_drunk = false 

func _ready():
	
	if timer_panel:
		print("timer_panel found. Making it visible.")  # Debug : le panneau est trouvé
		lose_panel.visible = true
		print("Panel visibility set to: ", timer_panel.visible)

		# Créer un Label et définir son texte
		var label = timer_panel.get_node_or_null("TimerLabel")  # Assurez-vous que le Label s'appelle "TimerLabel" dans l'éditeur
		if label == null:
			# Si le Label n'existe pas encore, créez-le.
			label = Label.new()
			label.name = "TimerLabel"  # Donne un nom au Label pour le retrouver plus facilement
			timer_panel.add_child(label)  # Ajoute le Label au panneau
			#label.text = "Timer : "

			# Positionner le panneau à un endroit spécifique
			timer_panel.position = Vector2(300, 0)  # Position dans la fenêtre

			# Assurez-vous que le panneau soit au-dessus des autres éléments
			timer_panel.z_index = 10
			print("Panel Z-Index: ", timer_panel.z_index)

			# Debug : Afficher la position du panneau
			print("Panel position: ", timer_panel.position)

			# Trouver le TileMap
			tilemap = get_node_or_null("../TileMap")
			if tilemap == null:
				push_error("TileMap not found! Check the node path.")
				return
			else:
				print("TileMap found successfully!")

# Fonction pour boire la bière
func drink_beer():
	beer_drunk = true
	print("Beer drunk, random movement inversion triggered.")

# Fonction pour gérer l'effet de la bière et l'inversion des déplacements
func process_beer_effect():
	if beer_drunk:
		# Randomly decide to invert X and Y directions with 50% chance
		if randf() < 0.5:
			x_inverted = !x_inverted
		if randf() < 0.5:
			y_inverted = !y_inverted
		beer_drunk = false  # Reset after effect
		print("Inversion applied - X: ", x_inverted, ", Y: ", y_inverted)

func _process(_delta):
	if is_game_over:
		return  # Si le jeu est perdu, empêcher tout mouvement

	# Decrement timer and check if it's time to lose
	timer -= _delta
	if timer <= 0:
		show_lose_message()
	
	# Update the timer label
	timer_label.text = str(int(timer))

	if is_in_empty_zone():
		show_lose_message()

	# Appliquer les effets de la bière si elle a été bue
	process_beer_effect()

func is_in_empty_zone() -> bool:
	if tilemap == null:
		return false  # Si le TileMap est absent, on considère qu'on n'est pas dans une zone vide

	# Convertir la position globale du joueur en position de grille
	var grid_position = tilemap.local_to_map(global_position)
	# Vérifier si la cellule est vide (-1 signifie qu'il n'y a pas de tile)
	return tilemap.get_cell_source_id(grid_position) == -1

func show_lose_message():
	print("Executing method show_lose_message")  # Message de débogage principal

	if lose_panel:
		print("Panel found. Making it visible.")  # Debug : le panneau est trouvé
		lose_panel.visible = true
		print("Panel visibility set to: ", lose_panel.visible)
		
		# Ajout de tests pour la position et la taille du Panel
		print("Panel position: ", lose_panel.position)  # Utiliser `position` au lieu de `rect_position`
		
		# Forcer la visibilité et ajuster la position si nécessaire
		lose_panel.position = Vector2(100, 100)  # Position dans la fenêtre

		# Assurez-vous que le panneau soit au-dessus des autres éléments
		lose_panel.z_index = 10
		print("Panel Z-Index: ", lose_panel.z_index)
		
		# Optionnel : changer la couleur du panel pour le rendre plus visible
		lose_panel.modulate = Color(1, 0, 0)  # Colore le panneau en rouge pour le tester
		
		# Marquer l'état du jeu comme perdu
		is_game_over = true
	else:
		print("Error: Panel not found! Check your scene structure.")  # Debug : le panneau est introuvable

	# Désactiver les contrôles après affichage du message
	set_process(false)


var propulsion_duration = 0.20  # Durée de la propulsion en secondes
var propulsion_timer = 0.0  # Compteur pour la durée de propulsion
var propulsion_velocity = Vector2.ZERO  # Vitesse de propulsion

func _physics_process(_delta):
	if is_game_over:
		return  # Empêche le mouvement du joueur quand le jeu est perdu

	# Calculer la direction d'entrée
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	# Appliquer les inversions sur les déplacements X et Y
	if x_inverted:
		input_direction.x = -input_direction.x
	if y_inverted:
		input_direction.y = -input_direction.y

	# Si la propulsion est active, appliquer la vitesse de propulsion
	if propulsion_timer > 0:
		# Réduire le temps restant pour la propulsion
		propulsion_timer -= _delta
		velocity = propulsion_velocity
		print("Propulsion active. Time remaining: ", propulsion_timer)
	else:
		# Si la propulsion est terminée, revenir au mouvement normal
		if input_direction != Vector2.ZERO:
			velocity = input_direction * move_speed
		else:
			velocity = initial_velocity  # Continuer la vitesse précédente si aucune entrée

	# Déplacer le joueur
	move_and_slide()

	# Gestion des collisions pour activer la propulsion
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision:
			var normal = collision.get_normal()  # Récupérer la normale de la collision
			print("Collision détectée!")
			print("Normale de collision:", normal)
			print("Vitesse avant propulsion:", velocity)
			
			# Appliquer une impulsion dans une direction aléatoire (par exemple, un vecteur aléatoire)
			if propulsion_timer <= 0:  # Appliquer la propulsion seulement si elle n'est pas déjà active
				propulsion_velocity = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized() * move_speed
				propulsion_timer = propulsion_duration  # Réinitialiser le timer de propulsion
				print("Vitesse de propulsion:", propulsion_velocity)

	# Mettre à jour les animations
	update_animation_parameters(input_direction)
	pick_new_state()

func update_animation_parameters(move_input: Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")


func _on_beer_2_mouse_entered() -> void:
	print("ça drink")
	drink_beer()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	print("ça drink ici")
	drink_beer()
