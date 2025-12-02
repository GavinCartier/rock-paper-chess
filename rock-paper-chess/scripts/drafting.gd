class_name Drafting
extends Node


@onready var white_player : Player = get_parent().get_node("WhitePlayer")
@onready var black_player : Player = get_parent().get_node("BlackPlayer")

var turn_order : Array
var buttons : Array
var selections = []
var pressed_set_all := false

@onready var message : Label = $"Instruction Text"
@onready var cam : Camera2D = get_parent().get_node("Camera2D")

signal finish_drafting

func _ready() -> void:
	cam.enabled = true
	# Go to chessboard when finish drafting
	var board = get_parent().get_node("ChessBoard")
	connect("finish_drafting", Callable(board, "_finished_drafting"))
	
	# Initialize the players
	white_player.color = Player.Player_Color.WHITE
	black_player.color = Player.Player_Color.BLACK
	
	# Pre-defined turn order
	turn_order = [	white_player,
					black_player, black_player,
					white_player, white_player,
					black_player, black_player,
					white_player, white_player,
					black_player, black_player,
					white_player ]
	
	# Make all the drop-down menus for each piece
	var b_pawn := make_button("Pawn", Vector2(cam.position.x - 1400, cam.position.y))
	var b_rook := make_button("Rook", Vector2(cam.position.x - 900, cam.position.y))
	var b_knight := make_button("Knight", Vector2(cam.position.x - 400, cam.position.y))
	var b_bishop := make_button("Bishop", Vector2(cam.position.x + 100, cam.position.y))
	var b_queen := make_button("Queen", Vector2(cam.position.x + 600, cam.position.y))
	var b_king := make_button("King", Vector2(cam.position.x + 1100, cam.position.y))
	
	buttons = [b_pawn, b_rook, b_knight, b_bishop, b_queen, b_king]
	
	var dev_button := make_button("Set All (dev only - delete before release)", Vector2(cam.position.x + 1500, cam.position.y))
	buttons.append(dev_button)
	
# Create a DynamicFont (the correct concrete class)
# Create a new Font
# Create a FontFile for your TTF font
	var font_res := load("res://assets/font/bodoni-72-oldstyle-book.ttf")  # .ttf or .otf in your project
	message.add_theme_font_override("font", font_res)
	message.add_theme_font_size_override("font_size", 2000)  # or whatever size you want
	# Run the drafting function
	draft_controller()


func make_button(text: String, pos: Vector2) -> MenuButton:
	# Create button
	var mb := MenuButton.new()
	mb.text = text
	
	# Add the RPS options to drop-down menu
	var popup := mb.get_popup()
	popup.add_item("Rock")
	popup.add_item("Paper")
	popup.add_item("Scissors")
	
	popup.add_theme_font_size_override("font_size", 28)
	popup.add_theme_constant_override("item_height", 40)
	
	# Position button in scene, add to scene, connect to function
	mb.position = pos
	add_child(mb)
	popup.connect("id_pressed", Callable(self, "_on_item_pressed").bind(mb))
	
	# for the piece click sfx
	mb.connect("pressed", Callable(self, "_on_piece_button_pressed"))

	# Customize text on button
	mb.add_theme_color_override("font_color", Color.BLACK)
	mb.add_theme_font_size_override("font_size", 70)
	mb.set_anchors_preset(Control.PRESET_CENTER)
	
	return mb
	
func _on_piece_button_pressed() -> void:
	Sfx.play("dice") 


func _on_item_pressed(index: int, button: MenuButton) -> void:
	# When an option is selected, it's put into the
	# selections array, which the draft function is listening to.
	var type = button.get_popup().get_item_text(index)
	
	match type:
		"Rock":
			Sfx.play("rock")
		"Paper":
			Sfx.play("paper")
		"Scissors":
			Sfx.play("scissors")
		_:
			pass
	
	if button.text == "Set All (dev only - delete before release)":
		pressed_set_all = true
	else:
		button.visible = false
	
	selections.append([button, button.text, type])


func draft_controller() -> void:
	var current_player : Player
	var next_player : Player
	var player_name : String
	
	# X Position of the first sprite to appear (a bit hacky)
	var sprite_xpos := -200
	
	for i in range(len(turn_order)):
		# Check whose turn it is
		current_player = turn_order[i]
		if (current_player == white_player):
			player_name = "White"
		else:
			player_name = "Black"
		
		# Check who will be going next
		if (i+1 != len(turn_order)):
			next_player = turn_order[i + 1]
		else:
			next_player = null
		
		# Make sure the player object has finished initializing
		while not current_player.initialized:
			await get_tree().process_frame
		
		# Give instructions based on if they get another turn after this
		if (current_player == next_player):
			message.text = player_name + ", make 2 selections."
		else:
			message.text = player_name + ", make 1 selection."
			
		
		# Only have the remaining options on screen.
		# So if a player has already picked a piece, make that button disappear
		for b in buttons:
			if current_player.get_piece_type(b.text) != PieceTypes.Types.NONE:
				b.visible = false
			else:
				b.visible = true
		
		# Wait for player to make a selection
		while (selections.size() == 0):
			await get_tree().process_frame
		
		# Get the selection from the array
		var pname = selections[0][1]
		var ptype = selections[0][2]
		
		if pressed_set_all:
			white_player.set_piece_type("Pawn", ptype)
			white_player.set_piece_type("Rook", ptype)
			white_player.set_piece_type("Bishop", ptype)
			white_player.set_piece_type("Knight", ptype)
			white_player.set_piece_type("Queen", ptype)
			white_player.set_piece_type("King", ptype)
			black_player.set_piece_type("Pawn", ptype)
			black_player.set_piece_type("Rook", ptype)
			black_player.set_piece_type("Bishop", ptype)
			black_player.set_piece_type("Knight", ptype)
			black_player.set_piece_type("Queen", ptype)
			black_player.set_piece_type("King", ptype)
			
			message.text = "Ready for game."
			emit_signal("finish_drafting")
			# turn off the camera for drafting
			cam.enabled=false
			
			return
		
		# Record the choice
		current_player.set_piece_type(pname, ptype)
		selections.pop_front()
		
		# Spawn the sprite in the world
		# These aren't the sprites the actual chess game would use,
		# it's just so they can see what choices have been made
		var sprite := Sprite2D.new()
		add_child(sprite)
		
		# First get the correct asset
		var sprite_filepath = "res://assets/new placeholder/" + ptype + "/" + player_name + "/" + ptype + " " + pname + " " + player_name + ".png"
		sprite.texture = load(sprite_filepath)
	
		# Make it a good looking size
		sprite.scale = Vector2(1.5, 1.5)
		
		
		# Position it in the scene so they don't overlap,
		# and are grouped by owner
		
		# White player in the bottom of the screen, black on top
		var sprite_ypos : int
		if (player_name == "White"):
			sprite_ypos = 450
		else:
			sprite_ypos = -450
		
		sprite.position = Vector2(sprite_xpos, sprite_ypos)
		
		# Shift the xposition of the next sprite so they don't overlap
		if (current_player == next_player):
			sprite_xpos += 300
		
		sprite.visible = true
		
		# go to chessboard after all drafting finished
		if i == len(turn_order) - 1:
			message.text = "Ready for game."
			emit_signal("finish_drafting")
			# turn off the camera for drafting
			cam.enabled=false
