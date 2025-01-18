extends Node

# Références à votre Timer, Panel et Label dans UI
@onready var timer = $Timer
@onready var perduPanel = $UI/PerduPanel
@onready var timerPanel = $UI/TimerPanel
@onready var label_timer = $UI/TimerPanel/Label  # Le label qui affichera le temps restant

# Fonction de démarrage du timer
func _ready():
	# Vérifier si le Timer et le Label sont bien accessibles
	if timer == null:
		print("Erreur : Timer introuvable dans la scène.")
	if label_timer == null:
		print("Erreur : Label Timer introuvable dans la scène.")
	
	perduPanel.visible = false  # Assurez-vous que le panneau "Perdu" est caché au départ
	
	# Positionner le label_timer dans le coin supérieur droit
	var label_size = label_timer.get_minimum_size()  # Taille du label (méthode correcte pour récupérer la taille)
	
	label_timer.text = str(int(timer.time_left))  # Afficher le temps restant initial (arrondi à un entier)
	
	timer.start(5)  # Lancer le timer pour 5 secondes (ajustez selon vos besoins)

# Fonction appelée à chaque frame pour mettre à jour le Label
func _process(delta):
	# Mettre à jour le texte du label avec le temps restant du timer
	if timer and label_timer:
		label_timer.text = str(int(timer.time_left)) 

# Fonction appelée quand le timer arrive à 0
func _on_Timer_timeout():
	# Afficher le panneau "Perdu"
	perduPanel.visible = true
	
	# Débogage : Affiche des informations sur le panneau
	print("Panel found. Making it visible.")
	print("Panel visibility set to: ", perduPanel.visible)
	print("Panel position: ", perduPanel.position)
	
	# Placer le panneau dans le coin supérieur droit
	var screen_size = get_viewport().size  # Taille de l'écran (viewport)
	# Calculer la position pour placer le panneau dans le coin supérieur droit
	perduPanel.position = Vector2(screen_size.x - perduPanel.rect_min_size.x, 0)  # Corner position (top-right)
	perduPanel.z_index = 10  # Mettre le panneau au-dessus des autres éléments
	print("Panel position updated to: ", perduPanel.position)  # Debug : afficher la nouvelle position du panneau
	
	# Désactiver les contrôles après affichage du message
	set_process(false)  # Arrêter les mises à jour après l'affichage du message
