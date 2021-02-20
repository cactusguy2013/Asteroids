extends RigidBody2D

var num_points = 12
var point_rotation = 360 / num_points  # The angle between two points
var size = 50
var size_offset = 0.5

onready var Asteroid = load("res://Asteroid.tscn")
onready var DeathEffect = preload("res://AsteroidDeathEffect.tscn")
onready var timer = $Timer
onready var collision = $CollisionPolygon2D
onready var visibilty_notifier = $VisibilityNotifier2D

func _ready() -> void:
	timer.one_shot = true

func create():
	contact_monitor = true
	contacts_reported = 3
	
	randomize()
	var polygon = []
	for i in range(0, 360, point_rotation):
		var point = Vector2(0, -size + rand_range(-size*size_offset, size*size_offset))
		point = point.rotated(deg2rad(i))
		polygon.append(point)
	polygon.append(polygon[0])
	
	collision.polygon = PoolVector2Array(polygon)

func _draw() -> void:
	draw_polyline(collision.polygon, Color(255,255,255), 1, true)

func _on_Asteroid_body_entered(body: Node) -> void:
	if body.has_method("set_velocity"):  # is the colliding body a 'bullet'
		randomize()
		var rand_direction = rand_range(0, 2*PI)
		if size > 6.25:
			for i in range(-1,2,2):
				var asteroid = Asteroid.instance()
				get_parent().add_child(asteroid)
				
				asteroid.size = size/2
				asteroid.mass = mass/2
				asteroid.global_position = global_position + Vector2.UP.rotated(rand_direction)*i*(size*size_offset)
				asteroid.create()
				asteroid.apply_central_impulse(linear_velocity)  # Gives the child the parent's velocity
				asteroid.apply_central_impulse(Vector2.UP.rotated(rand_direction)*i*100)  # Then add the explosion force
		
		var death_effect = DeathEffect.instance()
		get_parent().add_child(death_effect)
		death_effect.global_position = global_position
		death_effect.emitting = true
		
		body.queue_free()
		queue_free()
	
	if body is KinematicBody2D:  # body is Spaceship
		body.destroy()

func _on_VisibilityNotifier2D_screen_exited() -> void:
	timer.start(5)

func _on_Timer_timeout() -> void:
	if not visibilty_notifier.is_on_screen():
		queue_free()
