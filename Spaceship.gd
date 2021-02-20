extends KinematicBody2D

onready var Bullet = preload("res://Bullet.tscn")
onready var DeathEffect = preload("res://SpaceshipDeathEffect.tscn")
onready var collision = $CollisionPolygon2D
onready var timer = $Timer

const ACCCELERATION = 10
const FRICTION = 2
var velocity = Vector2.ZERO
var bullet_on_cd = false  # bullet on cooldown

func _ready() -> void:
	timer.one_shot = true

func _draw() -> void:
	draw_polyline(collision.polygon, Color(255,255,255), 1, true)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("thrust"):
		velocity += Vector2.UP.rotated(rotation)*ACCCELERATION
	elif Input.is_action_pressed("reverse"):
		velocity -= Vector2.UP.rotated(rotation)*ACCCELERATION
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION)
	if Input.is_action_pressed("left"):
		rotate(-0.1)
	if Input.is_action_pressed("right"):
		rotate(0.1)
	if Input.is_action_pressed("shoot") and not bullet_on_cd:
		bullet_on_cd = true
		var bullet = Bullet.instance()
		get_parent().add_child(bullet)
		bullet.global_position = global_position + Vector2.UP.rotated(rotation)*20
		bullet.velocity = bullet.velocity.rotated(rotation)
		timer.start(0.15)
	
	if global_position.x > OS.window_size.x:
		global_position.x = 0
	if global_position.x < 0:
		global_position.x = OS.window_size.x
	if global_position.y > OS.window_size.y:
		global_position.y = 0
	if global_position.y < 0:
		global_position.y = OS.window_size.y
	
	move_and_slide(velocity)

func destroy():
	var death_effect = DeathEffect.instance()
	get_parent().add_child(death_effect)
	death_effect.global_position = global_position
	death_effect.emitting = true
	queue_free()

func _on_Timer_timeout() -> void:
	bullet_on_cd = false
