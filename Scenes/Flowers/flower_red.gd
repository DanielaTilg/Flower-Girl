extends Area2D

signal flower_clicked(flower_type, flower_node)
@export var flower_type : String = "red"
@onready var hover_rect = $red_hover
@onready var select = $red_select
@export var price := 0.50

func _ready():
	input_pickable = true
	hover_rect.visible = false
	select.visible = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("flower_clicked", flower_type, self)
	
func _on_mouse_entered():
	hover_rect.visible = true

func _on_mouse_exited():
	hover_rect.visible = false

func set_selected(state: bool):
	select.visible = state
