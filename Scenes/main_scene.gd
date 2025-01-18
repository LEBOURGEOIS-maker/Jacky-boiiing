extends Node2D

var area2d_instance : Area2D
var staticbody_instance : StaticBody2D
var key_count = 0  

func _ready():
	update_key_count_display()

func update_key_count_display():
	$CanvasLayer/KeyCounterLabel.text = "Bières obtenus : %d" % key_count

func add_key():
	key_count += 1
	update_key_count_display()

# Méthode qui est appelée lorsque l'area_entered est émis
func _on_area_entered(area):
	if area.is_in_group("static_bodies"):
		print("Le StaticBody2D est entré dans la zone de l'Area2D !")
		# Exemple : Déplacer le StaticBody2D lorsqu'il entre dans l'area
		staticbody_instance.position = Vector2(100, 100)  # Déplacer le StaticBody2D


func _on_beer_chest_opened() -> void:
	pass # Replace with function body.
