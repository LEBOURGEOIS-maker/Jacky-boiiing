extends Button

func _on_pressed() -> void:
	# Recharge la scène actuelle
	get_tree().reload_current_scene()
