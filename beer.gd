extends StaticBody2D

var keytaken = false
var in_chest_zone = false
var key_count = 0  # Global key counter

# Called when the key area is entered
func _on_area_2d_body_entered(body: PhysicsBody2D):
	if not keytaken:
		keytaken = true
		# Increment global key count if needed
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
			# Optionally reset keytaken after chest is opened
			keytaken = false
			print("Key taken state reset after chest opening.")

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
