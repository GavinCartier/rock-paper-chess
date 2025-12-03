class_name Cutscene
extends Node2D

@onready var drafting = get_node("../Drafting")

@onready var aristocrat = get_node("Aristocrat")
@onready var cowboy = get_node("Cowboy")
@onready var text_box = get_node("Text")

var aristocrat_name : String = "Aris T. O'Cratt"
var cowboy_name : String = "C. W. Boye"

@onready var tb_box = get_node("Text/Box")
@onready var tb_name = get_node("Text/Name")
@onready var tb_text = get_node("Text/Speech")
@onready var screenshot = get_node("Screenshots")

var aristocrat_position
var cowboy_position

signal clicked

var current_speaker : Node2D = null

func _ready() -> void:
	tb_box.modulate.a = 0.0
	tb_name.modulate.a = 0.0
	tb_text.modulate.a = 0.0
	
	aristocrat.visible = false
	cowboy.visible = false
	text_box.visible = false
	
	aristocrat_position = aristocrat.position
	aristocrat.position.x = -1500
	cowboy_position = cowboy.position
	cowboy.position.x = -1500
	cowboy.scale.x *= -1


func play():
	aristocrat.visible = true
	cowboy.visible = true
	
	var tween_aristocrat = get_tree().create_tween()
	tween_aristocrat.tween_property(aristocrat, "position", aristocrat_position, 0.5)
	await tween_aristocrat.finished
	
	await say(aristocrat, "Ahhh! It's so good to have a break at last.")
	
	var tween_cowboy = get_tree().create_tween()
	tween_cowboy.tween_property(cowboy, "position", cowboy_position, 1)
	tween_cowboy.tween_property(cowboy, "scale:x", cowboy.scale.x * -1.0, 0.25)
	await tween_cowboy.finished
	
	await say(cowboy, "It sure is, partner.")
	await say(cowboy, "Whaddya say we play a good ol' round of Rock, Paper, Scissors?")
	await say(aristocrat, "I say, what is it with you and that silly little game?")
	await say(aristocrat, "For the life of me, I simply cannot understand why you are so rarely inclined to play a real game.")
	await say(cowboy, "Oh yeah? And what would a 'real game' be? Chess?")
	await say(cowboy, "Hell, I reckon you even brought your chess set again.")
	await say(aristocrat, "But of course! I could never be caught without it.")
	await say(cowboy, "(sigh)")
	await say(cowboy, "Chess ain't got no suspense! No drama! Where's the fun?")
	await say(aristocrat, "Hah! Surely you jest; Chess is positively full of suspense.")
	await say(cowboy, "Guess we're at an impasse then. I ain't playin' your game and you ain't playin' mine.")
	await say(aristocrat, "A compromise, then! Let us combine our favorite games into one.")
	await say(cowboy, "How would that work, then?")


	show_screenshot(screenshot.get_node("Drafting 1"))
	await say(aristocrat, "We'll start by taking turns setting each kind of chess piece to either Rock, Paper, or Scissors.")
	await say(cowboy, "Won't the person goin' second be at a disadvantage, then?")
	await say(aristocrat, "We'll do it like we're drafting teammates!")
	hide_screenshot(screenshot.get_node("Drafting 1"))
	show_screenshot(screenshot.get_node("Drafting 2"))
	await say(aristocrat, "First, I'll only make one selection.")
	hide_screenshot(screenshot.get_node("Drafting 2"))
	show_screenshot(screenshot.get_node("Drafting 3"))
	await say(aristocrat, "Then, you'll make two.")
	hide_screenshot(screenshot.get_node("Drafting 3"))
	show_screenshot(screenshot.get_node("Drafting 4"))
	await say(aristocrat, "Then we'll both make two selections at a time until every piece has a type.")
	hide_screenshot(screenshot.get_node("Drafting 4"))
	await say(cowboy, "I see, so we'll both have to respond to the other's choices. Then what happens?")
	
	
	show_screenshot(screenshot.get_node("Board 1"))
	await say(aristocrat, "Then we go to the chess board and begin the game!")
	await say(aristocrat, "We'll completely change how capturing pieces works.")
	hide_screenshot(screenshot.get_node("Board 1"))
	show_screenshot(screenshot.get_node("Board 2"))
	await say(aristocrat, "Each piece will have Health and Damage stats in addition to their type.")
	await say(aristocrat, "For example, Pawns will have relatively low values, and the Queen will have pretty high values.")
	hide_screenshot(screenshot.get_node("Board 2"))
	show_screenshot(screenshot.get_node("Board 6"))
	await say(aristocrat, "Instead of immediately capturing, pieces will Challenge each other!")
	await say(aristocrat, "In a Challenge, the attacking piece will deal damage based on its stats and type.")
	hide_screenshot(screenshot.get_node("Board 6"))
	show_screenshot(screenshot.get_node("Board 3"))
	await say(aristocrat, "Challenging with type advantage, like a Rock piece attacking a Scissors piece, will deal double damage.")
	hide_screenshot(screenshot.get_node("Board 3"))
	show_screenshot(screenshot.get_node("Board 4"))
	await say(aristocrat, "Conversely, challenging with type disadvantage will only deal half as much damage as normal.")
	await say(aristocrat, "If your challenge brings the other piece's health to zero, move to it's spot!")
	await say(aristocrat, "Otherwise, both pieces remain where they are.")
	hide_screenshot(screenshot.get_node("Board 4"))
	await say(cowboy, "Okay... so how will Checks and Checkmates work then?")
	show_screenshot(screenshot.get_node("Board 5"))
	await say(aristocrat, "I guess we won't have those! These new rules mean you can have the King be attacked but survive.")
	await say(aristocrat, "So instead, the game will end when you simply defeat the King like any other piece.")
	
	hide_screenshot(screenshot.get_node("Board 5"))
	await say(cowboy, "Okay, I think I get it.")
	await say(cowboy, "Let's get drafting then!")
	
	self.visible = false


func say(speaker: Node2D, line: String):
	var appearance_time = 0.25
	
	current_speaker = speaker
	
	speaking_animation(speaker)
	
	text_box.visible = true
	await get_tree().create_timer(appearance_time).timeout
	
	if (speaker == aristocrat):
		tb_name.text = aristocrat_name
		undim_character(aristocrat)
		dim_character(cowboy)
	else:
		tb_name.text = cowboy_name
		undim_character(cowboy)
		dim_character(aristocrat)
	
	tb_text.text = line
	
	get_tree().create_tween().tween_property(tb_box, "modulate:a", 1.0, appearance_time)
	get_tree().create_tween().tween_property(tb_name, "modulate:a", 1.0, appearance_time)
	get_tree().create_tween().tween_property(tb_text, "modulate:a", 1.0, appearance_time)
	
	await clicked
	
	current_speaker = null
	
	get_tree().create_tween().tween_property(tb_box, "modulate:a", 0.0, appearance_time)
	get_tree().create_tween().tween_property(tb_name, "modulate:a", 0.0, appearance_time)
	get_tree().create_tween().tween_property(tb_text, "modulate:a", 0.0, appearance_time)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		clicked.emit()


func speaking_animation(speaker: Node2D):
	var neutral = speaker.get_node("Neutral")
	var speaking = speaker.get_node("Speaking")
	
	var animation_speed = 0.25
	
	while (current_speaker == speaker):
		neutral.visible = false
		speaking.visible = true
		
		await get_tree().create_timer(animation_speed).timeout
		
		neutral.visible = true
		speaking.visible = false
		
		await get_tree().create_timer(animation_speed).timeout


func dim_character(nonspeaker : Node2D):
	var dim = Color(0.7, 0.7, 0.7)	
	get_tree().create_tween().tween_property(nonspeaker, "modulate", dim, 0.1)


func undim_character(nonspeaker : Node2D):
	var dim = Color(1, 1, 1)	
	get_tree().create_tween().tween_property(nonspeaker, "modulate", dim, 0.1)


func _on_button_pressed() -> void:
	drafting.set_visible(true)
	self.visible = false


func show_screenshot(ss: Sprite2D):
	ss.modulate.a = 0.0
	ss.visible = true
	get_tree().create_tween().tween_property(ss, "modulate:a", 1.0, 0.3)


func hide_screenshot(ss: Sprite2D):
	get_tree().create_tween().tween_property(ss, "modulate:a", 0.0, 0.3)
