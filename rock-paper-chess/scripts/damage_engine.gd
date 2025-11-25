extends Node

'''
Class for handling challenges between pieces
Challenges involve a single attacker and defender
Challenge results are calculated strictly on the attacker's damage, and the attacker/defender's types
'''

# Multipliers for strong, normal, and weak type interactions
const STRONG_ATTACK : float = 2.0
const ATTACK : float = 1.0
const WEAK_ATTACK : float = 0.5

# Two-dimensional dictionary for storing piece multipliers
# First entry is attacker's type, second is defender's type
static var type_multipliers := {
	PieceTypes.Types.ROCK: {
		PieceTypes.Types.ROCK: ATTACK,
		PieceTypes.Types.PAPER: WEAK_ATTACK,
		PieceTypes.Types.SCISSORS: STRONG_ATTACK,
	},
	
	PieceTypes.Types.PAPER: {
		PieceTypes.Types.ROCK: STRONG_ATTACK,
		PieceTypes.Types.PAPER: ATTACK,
		PieceTypes.Types.SCISSORS: WEAK_ATTACK,
	},
	
	PieceTypes.Types.SCISSORS: {
		PieceTypes.Types.ROCK: WEAK_ATTACK,
		PieceTypes.Types.PAPER: STRONG_ATTACK,
		PieceTypes.Types.SCISSORS: ATTACK,
	},
}

# Sound effect function for favored matchup
func _play_matchup_sfx(attacker: Piece, defender: Piece, multiplier: float) -> void:
	if multiplier == ATTACK:
		Sfx.play("drum")
		return
	
	var favored_owner
	if multiplier == STRONG_ATTACK:
		favored_owner = attacker.piece_owner
	elif multiplier == WEAK_ATTACK:
		favored_owner = defender.piece_owner
	else:
		Sfx.play("drum")
		return
	
	if favored_owner == PieceTypes.Owner.WHITE:
		Sfx.play("bell")
	elif favored_owner == PieceTypes.Owner.BLACK:
		Sfx.play("whip")
	else:
		Sfx.play("drum")


# Main function for handling a challenge
# Returns true if the defender was killed
func challenge(attacker: Piece, defender: Piece) -> bool:
	#_play_sfx("woosh") at start of challenge
	var attack_damage = damage_dealt(attacker, defender)
	defender.receive_damage(attack_damage)
	
	#_play_sfx("woosh") at end of challenge
	return defender.health <= 0.0

# Returns the damage dealt to the defender
# Can be used for hypothetical damage calculations
func damage_dealt(attacker: Piece, defender: Piece) -> float:
	var multiplier : float = type_multipliers[attacker.piece_type][defender.piece_type]
	
	_play_matchup_sfx(attacker, defender, multiplier)

	var attack_damage = attacker.damage * multiplier
	return min(defender.health, attack_damage)
