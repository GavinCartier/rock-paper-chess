extends Sprite2D

@onready var white_stats = $"White Stats Label"
@onready var black_stats = $"Black Stats Label"
@onready var total_turns =  $"Total Turns"

@onready var white_player : Player = get_parent().get_node("WhitePlayer")
@onready var black_player : Player = get_parent().get_node("BlackPlayer")

func _finished_game(white_total : float, black_total :float, white_lost : int, black_lost :int,
	turns : int):
	black_stats.text = "Pieces Taken: " + str(black_lost) \
	+ "\n" + "Damage Dealt: "+ str(black_total)
	white_stats.text = "Pieces Taken: "+ str(white_lost) \
	+ "\n" + "Damage Dealt: "+ str(white_total)
	total_turns.text = "Total turns: " + str(turns)
	
