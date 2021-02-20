extends RigidBody2D

var velocity = Vector2(0,-500) setget set_velocity

func _draw() -> void:
	draw_circle(Vector2.ZERO, 2, Color(255,255,255))

func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
	
func set_velocity(value):
	velocity = value
	apply_central_impulse(velocity)
