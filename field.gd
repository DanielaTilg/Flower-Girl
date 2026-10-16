extends Node2D

@onready var player = $Player
@onready var flowers_container = $Flowers
var screen_margin = 700  # Abstand vom sichtbaren Bildschirm

@export var red_weight := 17
@export var blue_weight := 12
@export var yellow_weight := 20
@export var narc1_weight := 5
@export var narc2_weight := 2
@export var tul1_weight := 1
@export var tul2_weight := 1
@export var tul3_weight := 1

var red_scene = preload("res://Scenes/Flowers/flower_red.tscn")
var blue_scene = preload("res://Scenes/Flowers/flower_blue.tscn")
var yellow_scene = preload("res://Scenes/Flowers/flower_yellow.tscn")
var narc1_scene = preload("res://Scenes/Flowers/flower_narc1.tscn")
var narc2_scene = preload("res://Scenes/Flowers/flower_narc2.tscn")
var tul1_scene = preload("res://Scenes/Flowers/flower_tul1.tscn")
var tul2_scene = preload("res://Scenes/Flowers/flower_tul2.tscn")
var tul3_scene = preload("res://Scenes/Flowers/flower_tul3.tscn")

func _ready():
	randomize()
	var timer = Timer.new()
	timer.wait_time = 2.0
	timer.autostart = true
	timer.timeout.connect(spawn_flower)
	add_child(timer)

func spawn_flower():
	var scene = get_weighted_flower()
	if scene == null:
		return
	var flower_instance = scene.instantiate()
	flower_instance.connect("flower_clicked", Callable(self, "_on_flower_clicked"))
	# Bestimme Spawn-Seite
	var spawn_x : float
	if player.direction == "right":  # du musst selbst direction tracken
		spawn_x = player.position.x + 600 
	if player.direction == "left":
		spawn_x = player.position.x - 600 - screen_margin
	else:
		spawn_x = player.position.x + 600 
	flower_instance.position.x = spawn_x
	flower_instance.scale = Vector2(0.6, 0.6)
	flowers_container.add_child(flower_instance)

func get_weighted_flower():
	if _flower_pool.is_empty():
		_build_flower_pool()
	return _flower_pool.pop_back()
	
var _flower_pool := []

func _build_flower_pool():
	_flower_pool.clear()
	var entries = [
		{ "scene": red_scene, "weight": red_weight },
		{ "scene": blue_scene, "weight": blue_weight },
		{ "scene": yellow_scene, "weight": yellow_weight },
		{ "scene": narc1_scene, "weight": narc1_weight },
		{ "scene": narc2_scene, "weight": narc2_weight },
		{ "scene": tul1_scene, "weight": tul1_weight },
		{ "scene": tul2_scene, "weight": tul2_weight },
		{ "scene": tul3_scene, "weight": tul3_weight }
	]
	for e in entries:
		if e.weight <= 0:
			continue
		for i in range(e.weight):
			_flower_pool.append(e.scene)
	_flower_pool.shuffle()

func _on_flower_clicked(type, flower_node):
	$Cutting_Flowers.play()
	GameManager.add_flower(type)
	flower_node.queue_free()
