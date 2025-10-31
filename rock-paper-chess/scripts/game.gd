extends Node
class_name Game

'''
This is the hub of the main logic related to the game
'''

enum Status {
	MENU,
	DRAFT,
	GAME
}

# Stores the current game status
var game_status : Game.Status = Status.MENU
