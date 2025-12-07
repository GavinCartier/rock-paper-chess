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

# Store health and damage stats
static var health_stats := {
	Classes.PAWN: 20,
	Classes.KNIGHT: 30,
	Classes.BISHOP: 40,
	Classes.ROOK: 40,
	Classes.QUEEN: 50,
	Classes.KING:  15
}

static var damage_stats := {
	Classes.PAWN: 10,
	Classes.KNIGHT: 20,
	Classes.BISHOP: 10,
	Classes.ROOK:   20,
	Classes.QUEEN:  25,
	Classes.KING:   25
}

static func get_possible_moves(piece_class: int, owner: int, location: Vector2i, board: ChessBoard) -> Array:
	match piece_class:
		Classes.PAWN:
			return _pawn_moves(owner, location, board)

		Classes.KNIGHT:
			var potential_moves = [
				Vector2i(-2, -1), Vector2i(-2, 1),
				Vector2i(-1, -2), Vector2i(-1, 2),
				Vector2i(1, -2),  Vector2i(1, 2),
				Vector2i(2, -1),  Vector2i(2, 1)
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
			return _ray_moves(owner, [Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(-1, -1)], location, board)

		Classes.ROOK:
			return _ray_moves(owner, [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)], location, board)

		Classes.QUEEN:
			return _ray_moves(owner, [
				Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(-1, -1),
				Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)
			], location, board)

		Classes.KING:
			var potential_moves = [
				Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1),
				Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(-1, -1)
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
			# Castling
			var king = board.grid[location.x][location.y]
			var castling_moves = _castling(king, board)
			
			for move in castling_moves:
				possible_moves.append(move)
			
			
			return possible_moves

		_:
			return []


static func _pawn_moves(owner: int, location: Vector2i, board: ChessBoard) -> Array:
	var dir := -1 if owner == Owner.WHITE else 1
	
	var potential_moves = [
		Vector2i(dir, 0), # one step forward
		Vector2i(dir * 2, 0), # two steps from start
		Vector2i(dir, 1), # capture right
		Vector2i(dir, -1) # capture left
	]
	
	var possible_moves = []
	for move in potential_moves:
		var tile = move + location
		if (tile.x <= 3 and tile.x >= -4) and (tile.y <= 3 and tile.y >= -4):
			var piece_on_tile = board.grid[tile.x][tile.y]
			
			if move == Vector2i(dir, 0):
				if piece_on_tile == null:
					possible_moves.append(move)
			
			if move == Vector2i(dir * 2, 0):
				var both_spaces_empty = (piece_on_tile == null and board.grid[location.x + (1 * dir)][tile.y] == null)
				var has_moved : bool
				
				if (owner == Owner.WHITE and location.x == 2):
					has_moved = false
				elif (owner == Owner.BLACK and location.x == -3):
					has_moved = false
				else:
					has_moved = true
				
				if both_spaces_empty and not has_moved:
					possible_moves.append(move)
			
			if move == Vector2i(dir, 1) or move == Vector2i(dir, -1):
				if piece_on_tile != null and piece_on_tile.piece_owner != owner:
					possible_moves.append(move)
					
	return possible_moves

static func _ray_moves(owner: int, directions: Array, location: Vector2i, board: ChessBoard) -> Array:
	var moves := []
	for dir in directions:
		for step in range(1, 8):
			var tile = (dir * step) + location
			if (tile.x <= 3 and tile.x >= -4) and (tile.y <= 3 and tile.y >= -4):
				var piece_on_tile = board.grid[tile.x][tile.y]
				
				if piece_on_tile != null:
					if piece_on_tile.piece_owner != owner:
						moves.append(dir * step)
					break
				else:
					moves.append(dir * step)
	return moves

# Determine the possible castling moves that can be made for a king
static func _castling(piece: Piece, board: ChessBoard) -> Array:
	var moves := []
	
	if piece.has_moved: return moves
	
	if piece.piece_owner == Owner.WHITE:
		# Left castle
		var left_rook : Piece = board.grid[3][-4]
		if left_rook != null and left_rook.piece_class == Classes.ROOK and not left_rook.has_moved:
			if board.grid[3][-3] == null and board.grid[3][-2] == null and board.grid[3][-1] == null:
				# Yes, can castle on left
				moves.append(Vector2i(0, -2))
		
		# Right castle
		var right_rook : Piece = board.grid[3][3]
		if right_rook != null and right_rook.piece_class == Classes.ROOK and not right_rook.has_moved:
			if board.grid[3][1] == null and board.grid[3][2] == null:
				# Yes, can castle on right
				moves.append(Vector2i(0, 2))
	
	else:
		var left_rook : Piece = board.grid[-4][-4]
		if left_rook != null and left_rook.piece_class == Classes.ROOK and not left_rook.has_moved:
			if board.grid[-4][-3] == null and board.grid[-4][-2] == null and board.grid[-4][-1] == null:
				# Yes, can castle on left
				moves.append(Vector2i(0, -2))
		
		# Right castle
		var right_rook : Piece = board.grid[-4][3]
		if right_rook != null and right_rook.piece_class == Classes.ROOK and not right_rook.has_moved:
			if board.grid[-4][1] == null and board.grid[-4][2] == null:
				# Yes, can castle on right
				moves.append(Vector2i(0, 2))
	
	return moves
	
