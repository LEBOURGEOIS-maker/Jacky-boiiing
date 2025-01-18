extends StaticBody2D

var keytaken = false
var in_chest_zone = false
var key_count = 0  # Nouveau compteur global

func _on_area_2d_body_entered(body: PhysicsBody2D):
	if not keytaken:
		keytaken = true
		#key_count += 1  # Incrémenter le compteur
		if get_tree().get_root().has_node("GameLevel"):
			get_tree().get_root().get_node("GameLevel").add_key()
		else:
			print("Le nœud 'Game' n'existe pas !")
		if $Sprite:
			$Sprite.queue_free()
			print("Clé récupérée. Nombre total de clés :", key_count)
		else:
			print("Error: Sprite node does not exist or has been freed.")

func _process(delta):
	if keytaken and in_chest_zone:  # Simplified condition
		if Input.is_action_just_pressed("ui_accept"):
			print("chest_opened")
			emit_signal("chest_opened")

func _on_chest_zone_body_entered(body: PhysicsBody2D):
	if body.name == "Player":
		in_chest_zone = true
		print("Entered chest zone:", in_chest_zone)

func _on_chest_zone_body_exited(body: PhysicsBody2D):
	if body.name == "Player":  # Ensure it's the player exiting
		in_chest_zone = false
		print("Exited chest zone:", in_chest_zone)
