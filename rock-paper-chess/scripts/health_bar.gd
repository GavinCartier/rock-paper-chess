extends Node
class_name HealthBar


# Given a ratio of health, updates the health bar to that ratio
func update_health(ratio : float) -> void:
	self.value = self.max_value * ratio

func hide_damage_received() -> void:
	self.value = 100.0

# Show the damage that would be dealt
func show_damage_received(ratio : float) -> void:
	# The current ratio of filled health
	var curr_ratio : float = self.value / self.max_value
	var damage_received_pos = self.max_value * (1.0 - curr_ratio - ratio) # Calculate the position at which the damage dealt would show up
	var damage_received_width = self.max_value * ratio
	# Show the damage received
	
# Hide the healthbar
func hide() -> void:
	self.visible = false

# Show the healthbar
func show() -> void:
	self.visible = true
