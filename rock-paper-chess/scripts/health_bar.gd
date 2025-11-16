extends Node
class_name HealthBar

@onready var health_bar_fill : ColorRect = $HealthBarFill
@onready var damage_received : ColorRect = $DamageReceived

# Given a ratio of health, updates the health bar to that ratio
func update_health(ratio : float) -> void:
	health_bar_fill.size.x = self.size.x * ratio

func hide_damage_received() -> void:
	damage_received.size.x = 0.0

# Show the damage that would be dealt
func show_damage_received(ratio : float) -> void:
	# The current ratio of filled health
	var curr_ratio : float = health_bar_fill.size.x / self.size.x  
	var damage_received_pos = self.size.x * (1.0 - curr_ratio - ratio) # Calculate the position at which the damage dealt would show up
	var damage_received_width = self.size.x * ratio
	
	# Show the damage received
	damage_received.size.x = damage_received_width

# Hide the healthbar
func hide() -> void:
	self.visible = false

# Show the healthbar
func show() -> void:
	self.visible = true
