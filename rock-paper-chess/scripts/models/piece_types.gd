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

static func get_possible_moves(piece_class: int, owner: int) -> Array:

	match piece_class:
		Classes.PAWN:
			return _pawn_moves(owner)

		Classes.KNIGHT:
			return [
				Vector2(-2, -1), Vector2(-2, 1),
				Vector2(-1, -2), Vector2(-1, 2),
				Vector2(1, -2),  Vector2(1, 2),
				Vector2(2, -1),  Vector2(2, 1)
			]

		Classes.BISHOP:
			return _ray_moves([Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)])

		Classes.ROOK:
			return _ray_moves([Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)])

		Classes.QUEEN:
			return _ray_moves([
				Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1),
				Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1)
			])

		Classes.KING:
			return [
				Vector2(1, 0), Vector2(-1, 0), Vector2(0, 1), Vector2(0, -1),
				Vector2(1, 1), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1)
			]

		_:
			return []


static func _pawn_moves(owner: int) -> Array:
	var dir := 1 if owner == Owner.WHITE else -1
	return [
		Vector2(dir, 0), # one step forward
		Vector2(dir * 2, 0), # two steps from start (should be validated elsewhere)
		Vector2(dir, 1), # capture right
		Vector2(dir, -1) # capture left
	]

static func _ray_moves(directions: Array) -> Array:
	var moves := []
	for dir in directions:
		for step in range(1, 8):
			moves.append(dir * step)
	return moves
