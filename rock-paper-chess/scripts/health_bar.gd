extends Node
class_name HealthBar

# Defines the colors that the damage taken indicator flashes between
const damage_received_start_color : Color = Color(0.0, 1.0, 0.0, 1.0)
const damage_received_end_color : Color = Color(1.0, 0.0, 0.0, 1.0)
const damage_received_animation_time : float = 0.5 # Amount of time for flashing animation

# This variable serves as a "lock" on whether to show the health bar or not.
# If true, then calling hide() will not hide the health bar.
var select_show : bool = false 
var damage_received_animation_timer : float = 0.0 # Timer for the flashing animation

@onready var health_bar_fill : ColorRect = $HealthBarFill
@onready var damage_received : ColorRect = $DamageReceived

# Handles animation for flashing of received damage indicator
func _process(delta: float) -> void:
	if damage_received.visible:
		# Find point between damage indicator's start and end colors to display
		var ratio_at_end : float = (abs(damage_received_animation_time - damage_received_animation_timer) ** 1.5) / damage_received_animation_time
		var damage_received_color : Color = damage_received_start_color * (1.0 - ratio_at_end) + damage_received_end_color * ratio_at_end
		damage_received.color = damage_received_color
		damage_received_animation_timer += delta
		
		if damage_received_animation_timer > 2 * damage_received_animation_time:
			damage_received_animation_timer = 0.0

# Given a ratio of health, updates the health bar to that ratio
func update_health(ratio : float) -> void:
	health_bar_fill.size.x = self.size.x * ratio

func hide_damage_received() -> void:
	damage_received.size.x = 0.0

# Show the damage that would be dealt
func show_damage_received(ratio : float) -> void:
	damage_received_animation_timer = 0.0 # Reset animation timer
	
	# The current ratio of filled health
	var curr_ratio : float = health_bar_fill.size.x / self.size.x  
	var damage_received_pos = self.size.x * (curr_ratio - ratio) # Calculate the position at which the damage dealt would show up
	var damage_received_width = self.size.x * ratio
	
	# Show the damage received
	damage_received.position.x = damage_received_pos
	damage_received.size.x = damage_received_width

# Hide the healthbar
func hide() -> void:
	if not select_show:
		self.visible = false

# Show the healthbar
func show() -> void:
	self.visible = true
