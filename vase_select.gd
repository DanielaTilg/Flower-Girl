extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_1flower1_pressed() -> void:
	for vase in get_tree().get_nodes_in_group("vases"):
		vase.visible = false
	get_parent().get_node("Vase1_3spots").visible = true

func _on_1flower_pressed() -> void:
	for vase in get_tree().get_nodes_in_group("vases"):
		vase.visible = false
	get_parent().get_node("Vase2_1spot").visible = true

func _on_3flowers_pressed() -> void:
	for vase in get_tree().get_nodes_in_group("vases"):
		vase.visible = false
	get_parent().get_node("Vase3_3spots").visible = true
