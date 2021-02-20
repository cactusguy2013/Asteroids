extends Node2D

onready var asteroidSpawnTimer = $AsteroidSpawnTimer
onready var game_timer_label = $GameTimerLabel
onready var spaceship = $Spaceship
onready var Asteroid = preload("res://Asteroid.tscn")
var time_played = 0.0

func _ready() -> void:
	asteroidSpawnTimer.start(0.5)

func _draw() -> void:
	draw_rect(Rect2(0,0,OS.window_size.x,OS.window_size.y), Color(0,0,0), true)

func _process(delta: float) -> void:
	if spaceship != null:
		time_played += delta
		game_timer_label.text = str(stepify(time_played, 0.1))

func create_asteroid():
	var asteroid = Asteroid.instance()
	add_child(asteroid)
	
	randomize()
	var side = rand_range(0,4)
	if side < 1:
		asteroid.global_position = Vector2(-75,rand_range(-75,OS.window_size.y + 75))
	elif side < 2:
		asteroid.global_position = Vector2(rand_range(-75,OS.window_size.x + 75),-75)
	elif side < 3:
		asteroid.global_position = Vector2(OS.window_size.x + 75,rand_range(-75,OS.window_size.y + 75))
	elif side < 4:
		asteroid.global_position = Vector2(rand_range(-75,OS.window_size.x + 75),OS.window_size.y + 75)
	
	asteroid.mass = 1000
	asteroid.create()
	
	var velocity = Vector2.UP.rotated(rand_range(0,2*PI))*rand_range(100,200)
	asteroid.apply_central_impulse(velocity)


func _on_Timer_timeout() -> void:
	create_asteroid()
