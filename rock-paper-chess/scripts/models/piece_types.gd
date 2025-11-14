class_name PieceTypes

'''
Stores the enums of the attributes of each piece
Classes: Dictates the pieces' moveset/stats
Types: The piece's matchup type for challenges
Owner: Which player this piece belongs to
'''

enum Classes {PAWN, KNIGHT, BISHOP, ROOK, QUEEN, KING}
enum Types {NONE, ROCK, PAPER, SCISSORS}
enum Owner {WHITE, BLACK}

static func get_possible_moves(piece_class: int, owner: int, location: Vector2, board: ChessBoard) -> Array:

	match piece_class:
		Classes.PAWN:
			return _pawn_moves(owner, location, board)

		Classes.KNIGHT:
			var potential_moves = [
				Vector2(-2, -1), Vector2(-2, 1),
				Vector2(-1, -2), Vector2(-1, 2),
				Vector2(1, -2),  Vector2(1, 2),
				Vector2(2, -1),  Vector2(2, 1)
			]
			var possible_moves = []
			for move in potential_moves:
				var tile = move + location
				
				if (tile.x <= 3 and tile.x >= -4) and (tile.y <= 3 and tile.y >= -4):
					var piece_on_tile = board.grid[tile.x][tile.y]
					
					if piece_on_tile == null:
						possible_moves.append(move)
					elif piece_on_tile.piece_owner != owner:
						possible_moves.append(move)
			return possible_moves

		Classes.BISHOP:
			return _ray_moves(owner, [Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)], location, board)

		Classes.ROOK:
			return _ray_moves(owner, [Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)], location, board)

		Classes.QUEEN:
			return _ray_moves(owner, [
				Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1),
				Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)
			], location, board)

		Classes.KING:
			var potential_moves = [
				Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1),
				Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)
			]
			var possible_moves = []
			for move in potential_moves:
				var tile = move + location
				if (tile.x <= 3 and tile.x >= -4) and (tile.y <= 3 and tile.y >= -4):
					var piece_on_tile = board.grid[tile.x][tile.y]
					
					if piece_on_tile == null:
						possible_moves.append(move)
					elif piece_on_tile.piece_owner != owner:
						possible_moves.append(move)
			return possible_moves

		_:
			return []


static func _pawn_moves(owner: int, location: Vector2, board: ChessBoard) -> Array:
	var dir := -1 if owner == Owner.WHITE else 1
	
	var potential_moves = [
		Vector2(dir, 0), # one step forward
		Vector2(dir * 2, 0), # two steps from start
		Vector2(dir, 1), # capture right
		Vector2(dir, -1) # capture left
	]
	
	var possible_moves = []
	for move in potential_moves:
		var tile = move + location
		if (tile.x <= 3 and tile.x >= -4) and (tile.y <= 3 and tile.y >= -4):
			var piece_on_tile = board.grid[tile.x][tile.y]
			
			if move == Vector2(dir, 0):
				if piece_on_tile == null:
					possible_moves.append(move)
			
			if move == Vector2(dir * 2, 0):
				if piece_on_tile == null and board.grid[location.x + (1 * dir)][tile.y] == null:
					possible_moves.append(move)
			
			if move == Vector2(dir, 1) or move == Vector2(dir, -1):
				if piece_on_tile != null and piece_on_tile.piece_owner != owner:
					possible_moves.append(move)
					
	return possible_moves

static func _ray_moves(owner: int, directions: Array, location: Vector2, board: ChessBoard) -> Array:
	var moves := []
	for dir in directions:
		for step in range(1, 8):
			var tile = (dir * step) + location
			var piece_on_tile = board.grid[tile.x][tile.y]
			
			if piece_on_tile != null:
				if piece_on_tile.piece_owner != owner:
					moves.append(dir * step)
				break
			else:
				moves.append(dir * step)
	return moves
