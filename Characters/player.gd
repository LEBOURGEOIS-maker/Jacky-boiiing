extends CharacterBody2D

@export var move_speed : float = 100
@export var starting_direction : Vector2 = Vector2(0, 1)

@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@export var tilemap_path: NodePath  # Path to the TileMap node
var tilemap: TileMap  # Reference to the TileMap
var is_game_over : bool = false  # Variable to manage game state (lost or not)

func _ready():
	# Print the current node path for debugging
	print("TileMap path: ", tilemap_path)

	# Use the exported path variable to find the TileMap node
	tilemap = get_node_or_null(tilemap_path)
	
	if tilemap == null:
		push_error("TileMap not found! Check the node path.")
		return
	else:
		print("TileMap found successfully!")


func _process(delta):
	if is_game_over:
		return  # Prevent movement if game is over
	if is_in_empty_zone():
		show_lose_message()

func is_in_empty_zone() -> bool:
	if tilemap == null:
		return false  # If TileMap is absent, assume we are not in an empty zone

	# Convert the player’s global position to grid coordinates
	var grid_position = tilemap.world_to_map(global_position)

	# Check if the cell at the grid position is empty (no tile)
	return tilemap.get_cell(grid_position.x, grid_position.y) == -1

func show_lose_message():
	print("Executing method show_lose_message")  # Debug message

	# Find the lose panel
	var lose_panel = get_parent().get_node("UI/PerduPanel")

	if lose_panel:
		print("Panel found. Making it visible.")  # Debug: panel found
		lose_panel.visible = true
		print("Panel visibility set to: ", lose_panel.visible)

		# Adjust position and visibility of the panel
		lose_panel.position = Vector2(100, 100)  # Adjust the position if necessary

		# Ensure panel is on top of other UI elements
		lose_panel.z_index = 10
		print("Panel Z-Index: ", lose_panel.z_index)

		# Mark game as over
		is_game_over = true
	else:
		print("Error: Panel not found! Check your scene structure.")  # Debug: panel not found

	# Disable player controls after game over
	set_process(false)

func _physics_process(_delta):
	if is_game_over:
		return  # Prevent player movement if game is over
	
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	
	# Update animations and movement
	update_animation_parameters(input_direction)
	velocity = input_direction * move_speed
	move_and_slide()
	pick_new_state()

func update_animation_parameters(move_input : Vector2):
	if move_input != Vector2.ZERO:
		animation_tree.set("parameters/Walk/blend_position", move_input)
		animation_tree.set("parameters/Idle/blend_position", move_input)

func pick_new_state():
	if velocity != Vector2.ZERO:
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")
