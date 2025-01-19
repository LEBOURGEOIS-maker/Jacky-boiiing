extends StaticBody2D

var keytaken = false
var in_chest_zone = false
var key_count = 0  # Global key counter
var beer_drunk = false  # Variable pour savoir si la bière a été bue
var x_inverted = false  # Flag pour savoir si les déplacements X sont inversés
var y_inverted = false  # Flag pour savoir si les déplacements Y sont inversés

# Called when the key area is entered
func _on_area_2d_body_entered(body: PhysicsBody2D):
	if not keytaken:
		keytaken = true
		key_count += 1  # Incrémenter le compteur de clés global
		if get_tree().get_root().has_node("GameLevel"):
			get_tree().get_root().get_node("GameLevel").add_key()
		else:
			print("Le nœud 'GameLevel' n'existe pas !")
		
		# Free sprite once key is taken
		if $Sprite2D:
			$Sprite2D.queue_free()
			print("Clé récupérée. Nombre total de clés :", key_count)
		else:
			print("Error: Sprite node does not exist or has been freed.")

# Process function, checks if the chest can be opened
func _process(delta):
	if keytaken and in_chest_zone:  # Only open chest if key is taken and in chest zone
		if Input.is_action_just_pressed("ui_accept"):
			print("chest_opened")
			emit_signal("chest_opened")
			keytaken = false  # Optionally reset keytaken after chest is opened
			print("Key taken state reset after chest opening.")

	# Logic to apply movement inversions based on beer consumption
	if beer_drunk:
		if randf() < 0.5:  # 50% chance to invert X or Y movement
			x_inverted = !x_inverted
		if randf() < 0.5:
			y_inverted = !y_inverted
		beer_drunk = false  # Reset the beer drunk state

# Triggered when entering the chest zone
func _on_chest_zone_body_entered(body: PhysicsBody2D):
	if body.name == "Player":
		in_chest_zone = true
		print("Player entered chest zone.")

# Triggered when exiting the chest zone
func _on_chest_zone_body_exited(body: PhysicsBody2D):
	if body.name == "Player":
		in_chest_zone = false
		print("Player exited chest zone.")

# Function to simulate drinking a beer (triggered by input or an event)
func _on_drink_beer():
	beer_drunk = true  # Player drank beer, trigger random inversion of movement
	print("Beer drunk, random movement inversion triggered.")

# Update movement code based on X/Y inversion flags
func _on_player_move(delta):
	var movement_vector = Vector2()  # Initial movement vector (no movement)
	
	# Add movement code here (e.g., using input)
	if Input.is_action_pressed("ui_right"):
		movement_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		movement_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		movement_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		movement_vector.y -= 1

	# Invert movement based on flags
	if x_inverted:
		movement_vector.x = -movement_vector.x
	if y_inverted:
		movement_vector.y = -movement_vector.y

	# Apply movement (e.g., moving the player object)
	position += movement_vector * delta
