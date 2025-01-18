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
	get_tree().change_scene("res://Scenes/menu_scene.tscn")  # Update with the correct path to the next scene

func show_win_popup():
	panelGagner.visible = true
	print("Panel found. Making it visible.")
	print("Panel visibility set to: ", panelGagner.visible)

	var screen_size = get_viewport().size  # Get the viewport size
	var panel_size = panelGagner.get_size()  # Get the actual size of the panel

	# Debug: print the size of the panel and screen size
	print("Screen size:", screen_size)
	print("Panel size:", panel_size)

	# Calculate the position to place it in the top-right corner
	var x_position = screen_size.x - panel_size.x  # Align to the right
	var y_position = 0  # Align to the top

	# Debug: print the calculated position
	print("Calculated position: ", Vector2(x_position, y_position))

	# Set the position of the panel
	panelGagner.position = Vector2(x_position, y_position)
	panelGagner.z_index = 10  # Ensure it appears above other elements

	# Disable character controls
	set_process(false)
