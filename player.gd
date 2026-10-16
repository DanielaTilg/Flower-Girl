extends CharacterBody2D

@export var speed := 200.0
var bob_time := 0.0

# Richtung merken: "right" oder "left"
var direction := "right"
var walkable = true
var walking = false

func _ready():
	set_outfit("default")
	
func _physics_process(_delta):
	if not walkable:
		return
		
	var input_dir = 0
	
	if Input.is_action_pressed("ui_right"):
		input_dir += 1
	if Input.is_action_pressed("ui_left"):
		input_dir -= 1
		
	
	# Bewegung
	velocity.x = input_dir * speed
	move_and_slide()
	if input_dir != 0:
		bob_time += _delta * 8.0  # Geschwindigkeit des Wippens
		var offset = sin(bob_time) * 7  # Stärke des Wippens
		$body.position.y = offset
		$dress.position.y = offset
		$head.position.y = offset
		$basket.position.y = offset
	else:
		bob_time = 0.0
		$body.position.y = 0
		$dress.position.y = 0
		$head.position.y = 0
		$basket.position.y = 0
	
	# Richtung merken
	if input_dir > 0:
		direction = "right"
		set_outfit("side1")
		walking = true
	elif input_dir < 0:
		direction = "left"
		set_outfit("side2")
		walking = true
	else:
		set_outfit("default")
		walking = false
	
	if walking == true:
		if $AudioStreamPlayer.is_playing() == false:
			$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()
		
func set_outfit(state):
	var body = bodies[GameManager.current_body][state]
	$body.texture = body
	var outfit = outfits[GameManager.current_outfit][state]
	$dress.texture = outfit
	var hair = hairs[GameManager.current_hair][state]
	$head.texture = hair
	var basket = basket[GameManager.current_basket][state]
	$basket.texture = basket
	
var outfits = {
	1: {
		"default": preload("res://images/player/outfit1.png"),
		"side1": preload("res://images/player/outfit1_side1.png"),
		"side2": preload("res://images/player/outfit1_side2.png")
	},
	2: {
		"default": preload("res://images/player/outfit2.png"),
		"side1": preload("res://images/player/outfit2_side1.png"),
		"side2": preload("res://images/player/outfit2_side2.png")
	},
	3: {
		"default": preload("res://images/player/outfit3.png"),
		"side1": preload("res://images/player/outfit3_side1.png"),
		"side2": preload("res://images/player/outfit3_side2.png")
	}}
var hairs = {
	1: {
		"default": preload("res://images/player/hair1.png"),
		"side1": preload("res://images/player/hair1_side1.png"),
		"side2": preload("res://images/player/hair1_side2.png")
	},
	2: {
		"default": preload("res://images/player/hair2.png"),
		"side1": preload("res://images/player/hair2_side1.png"),
		"side2": preload("res://images/player/hair2_side2.png")
	}}
var bodies = {
	1: {
		"default": preload("res://images/player/body.png"),
		"side1": preload("res://images/player/body_side1.png"),
		"side2": preload("res://images/player/body_side2.png")
	}}
var basket = {
	1: {
		"default": preload("res://images/player/basket.png"),
		"side1": preload("res://images/player/basket_side1.png"),
		"side2": preload("res://images/player/basket_side2.png")
	}}
