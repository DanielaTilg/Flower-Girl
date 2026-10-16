extends Node2D

func _ready():
	for vase in get_tree().get_nodes_in_group("vases"):
		vase.visible = false
		
	$Vase1_3spots.visible = true
