extends CanvasLayer

func _ready():
	GameManager.connect("flower_count_changed", Callable(self, "_on_flower_collected"))
	#_on_flower_collected("red", GameManager.collected_flowers["red"])
	#_on_flower_collected("blue", GameManager.collected_flowers["blue"])
	#_on_flower_collected("yellow", GameManager.collected_flowers["yellow"])
	update_ui()

func _on_flower_collected(type, count):
	update_ui()
			
#TEST FÜR NEUEN CONTAINER
func update_ui():
	for type in GameManager.collected_flowers:
		var count = GameManager.collected_flowers[type]
		var entry_path = "ScrollContainer/VBoxContainer/" + type + "_entry"
		var entry = get_node(entry_path)
		var label = entry.get_node("MarginContainer/Label")
		label.text = str(count)
		entry.visible = count > 0

func _on_button_pressed():
	$buttonclick.play()
	await $buttonclick.finished
	get_tree().change_scene_to_file("res://arranging_table.tscn")

func _on_dress_pressed():
	$buttonclick.play()
	await $buttonclick.finished
	get_tree().change_scene_to_file("res://dressup.tscn")
