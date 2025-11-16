extends Node
class_name HealthBar

@onready var health_bar_fill : ColorRect = $HealthBarFill

# Given a ratio of health, updates the health bar to that ratio
func update_health(ratio : float) -> void:
	health_bar_fill.size.x = self.size.x * ratio

# Hide the healthbar
func hide() -> void:
	self.visible = false

# Show the healthbar
func show() -> void:
	self.visible = true
