extends Area2D

signal slot_clicked(slot_node)
signal slot_flower_removed(slot_node) # neues Signal für UI

var filled = false
var current_flower_type : String = ""
var flower_node : Node = null
@export var flower_scale := 1.0
@export var flip_horizontal := false

@onready var hover = $fill
@onready var line = $line

func _ready():
	hover.visible = false

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if filled and flower_node != null:
			# Signal an UI senden, damit sie Count + UI aktualisiert
			emit_signal("slot_flower_removed", self)
		else:
			emit_signal("slot_clicked", self)

func remove_flower():
	if flower_node != null:
		flower_node.queue_free()
		flower_node = null
		current_flower_type = ""
		filled = false
		hover.visible = true
		line.visible = true

func _on_mouse_entered():
	if not filled:
		hover.visible = true

func _on_mouse_exited():
	hover.visible = false
