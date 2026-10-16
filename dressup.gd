extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.walkable = false
	$Player/Camera2D.enabled = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_hair_pressed():
	$buttonclick.play()
	var player = get_node("Player")
	GameManager.current_hair += 1
	if GameManager.current_hair > player.hairs.size():
		GameManager.current_hair = 1
	player.set_outfit("default")


func _on_dress_pressed():
	$buttonclick.play()
	var player = get_node("Player")
	GameManager.current_outfit += 1
	if GameManager.current_outfit > player.outfits.size():
		GameManager.current_outfit = 1
	player.set_outfit("default")


func _on_start_pressed():
	$buttonclick.play()
	await $buttonclick.finished
	get_tree().change_scene_to_file("res://Scenes/field.tscn")


func _on_credits_pressed():
	$buttonclick.play()
	await $buttonclick.finished
	get_tree().change_scene_to_file("res://credits.tscn")


func _on_tutorial_pressed():
	$buttonclick.play()
	await $buttonclick.finished
	get_tree().change_scene_to_file("res://tutorial.tscn")
