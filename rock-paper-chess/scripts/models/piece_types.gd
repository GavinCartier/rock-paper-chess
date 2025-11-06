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
