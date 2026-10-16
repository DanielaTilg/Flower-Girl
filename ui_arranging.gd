extends CanvasLayer

# Aktuell ausgewählte Blume
var selected_flower_type : String = ""
var selected_flower_node : Node = null
@onready var money_label = $Money/HBoxContainer/number

# Flower-Szenen vorbereiten
var red_scene = preload("res://Scenes/Flowers/flower_red.tscn")
var blue_scene = preload("res://Scenes/Flowers/flower_blue.tscn")
var yellow_scene = preload("res://Scenes/Flowers/flower_yellow.tscn")
var narc1_scene = preload("res://Scenes/Flowers/flower_narc1.tscn")
var narc2_scene = preload("res://Scenes/Flowers/flower_narc2.tscn")
var tul1_scene = preload("res://Scenes/Flowers/flower_tul1.tscn")
var tul2_scene = preload("res://Scenes/Flowers/flower_tul2.tscn")
var tul3_scene = preload("res://Scenes/Flowers/flower_tul3.tscn")

@onready var flower_scenes = {
	"red": red_scene,
	"blue": blue_scene,
	"yellow": yellow_scene,
	"narc1": narc1_scene,
	"narc2": narc2_scene,
	"tul1": tul1_scene,
	"tul2": tul2_scene,
	"tul3": tul3_scene
}

func _ready():
	# Flower UI Entries updaten
	GameManager.connect("flower_count_changed", Callable(self, "update_ui"))
	update_ui()
	update_money_ui()
	
	if GameManager.vase2unlock == true:
		unlockvase2()
	if GameManager.vase3unlock == true:
		unlockvase3()
	if GameManager.vase4unlock == true:
		unlockvase4()

	# Alle Flower-Instanzen in dieser UI verbinden
	for flower in get_tree().get_nodes_in_group("flowers"):
		flower.connect("flower_clicked", Callable(self, "_on_flower_clicked"))
	for slot in get_tree().get_nodes_in_group("slots"):
		slot.connect("slot_clicked", Callable(self, "on_slot_clicked"))
		slot.connect("slot_flower_removed", Callable(self, "on_slot_flower_removed"))
		
func update_ui():
	for type in GameManager.collected_flowers:
		var count = GameManager.collected_flowers[type]
		var entry_path = "ScrollContainer/VBoxContainer/" + type + "_entry"
		var entry = get_node(entry_path)
		var label = entry.get_node("MarginContainer/Label")
		label.text = str(count)
		entry.visible = count > 0

# Flower wird in UI angeklickt → Selection speichern
func _on_flower_clicked(flower_type, flower_node):
	# alte Auswahl deaktivieren
	if selected_flower_node != null:
		selected_flower_node.set_selected(false)
	# neue Auswahl setzen
	selected_flower_type = flower_type
	selected_flower_node = flower_node
	selected_flower_node.set_selected(true)

func on_slot_clicked(slot):
	if selected_flower_type != "":
		var flower_scene = flower_scenes[selected_flower_type]
		var flower_instance = flower_scene.instantiate()
		var container = slot.get_node("Container")
		container.add_child(flower_instance)
		flower_instance.scale = Vector2(slot.flower_scale, slot.flower_scale)
		if slot.flip_horizontal:
			flower_instance.scale.x *= -1
		slot.hover.visible = false
		slot.line.visible = false
		$in_vase.play()

		# Slot-Variablen aktualisieren
		slot.filled = true
		slot.current_flower_type = selected_flower_type
		slot.flower_node = flower_instance

		# Count reduzieren
		GameManager.collected_flowers[selected_flower_type] -= 1
		update_ui()

# Auswahl visuell zurücksetzen
		if selected_flower_node != null:
			selected_flower_node.set_selected(false)
		# UI Selection zurücksetzen
		selected_flower_type = ""
		selected_flower_node = null
		
func on_slot_flower_removed(slot):
	if slot.current_flower_type != "":
		# Count wieder hoch
		GameManager.collected_flowers[slot.current_flower_type] += 1
		update_ui()
		# Flower Node entfernen und Slot zurücksetzen
		slot.remove_flower()
		slot.line.visible = true
		slot.hover.visible = false
		$backonstack.play()

func update_money_ui():
	money_label.text = str("%.2f" % GameManager.money)

func _on_collect_pressed():
	for slot in get_tree().get_nodes_in_group("slots"):
		on_slot_flower_removed(slot)
	$buttonclick.play()
	await $buttonclick.finished
	get_tree().change_scene_to_file("res://Scenes/field.tscn")

func _on_sell_pressed():
	var total := 0.0
	for slot in get_tree().get_nodes_in_group("slots"):
		if slot.flower_node != null:
			total += slot.flower_node.price
			slot.remove_flower()  # Blume entfernen
			slot.filled = false
			slot.current_flower_type = ""
			slot.hover.visible = false
			slot.line.visible = true
	update_ui()
	GameManager.money += total
	if total > 0:
		$money.play()
	update_money_ui()

func _on_1flower1_pressed():
	$buttonclick.play()
	for vase in get_tree().get_nodes_in_group("vases"):
		vase.visible = false
	for slot in get_tree().get_nodes_in_group("slots"):
		on_slot_flower_removed(slot)
	get_parent().get_node("Vase1_3spots").visible = true

func _on_1flower_pressed():
	$buttonclick.play()
	if GameManager.vase2unlock == false:
		if GameManager.money >= 1.50:
			unlockvase2()
			chargevase2()
		else: return
	for vase in get_tree().get_nodes_in_group("vases"):
		vase.visible = false
	for slot in get_tree().get_nodes_in_group("slots"):
		on_slot_flower_removed(slot)
	get_parent().get_node("Vase2_1spot").visible = true

func _on_3flowers_pressed():
	$buttonclick.play()
	if GameManager.vase3unlock == false:
		if GameManager.money >= 4.00:
			unlockvase3()
			chargevase3()
		else: return
	for vase in get_tree().get_nodes_in_group("vases"):
		vase.visible = false
	for slot in get_tree().get_nodes_in_group("slots"):
		on_slot_flower_removed(slot)
	get_parent().get_node("Vase3_3spots").visible = true

func _on_5flowers_pressed():
	$buttonclick.play()
	if GameManager.vase4unlock == false:
		if GameManager.money >= 10.00:
			unlockvase4()
			chargevase4()
		else: return
	for vase in get_tree().get_nodes_in_group("vases"):
		vase.visible = false
	for slot in get_tree().get_nodes_in_group("slots"):
		on_slot_flower_removed(slot)
	get_parent().get_node("Vase4_5spots").visible = true

func unlockvase2():
	get_node("ScrollContainer2/HBoxContainer/1flower/ColorRect").visible = false
	get_node("ScrollContainer2/HBoxContainer/1flower/HBoxContainer").visible = false
	get_node("ScrollContainer2/HBoxContainer/1flower/Sprite2D").texture = preload("res://images/vases/vase2_complete.png")

func chargevase2():
	GameManager.vase2unlock = true
	GameManager.money -= 1.50
	update_money_ui()

func unlockvase3():
	get_node("ScrollContainer2/HBoxContainer/3flowers/ColorRect").visible = false
	get_node("ScrollContainer2/HBoxContainer/3flowers/HBoxContainer").visible = false
	get_node("ScrollContainer2/HBoxContainer/3flowers/Sprite2D").texture = preload("res://images/vases/vase3_complete.png")

func chargevase3():
	GameManager.vase3unlock = true
	GameManager.money -= 4.00
	update_money_ui()

func unlockvase4():
	get_node("ScrollContainer2/HBoxContainer/5flowers/ColorRect").visible = false
	get_node("ScrollContainer2/HBoxContainer/5flowers/HBoxContainer").visible = false
	get_node("ScrollContainer2/HBoxContainer/5flowers/Sprite2D").texture = preload("res://images/vases/vase4_complete.png")

func chargevase4():
	GameManager.vase4unlock = true
	GameManager.money -= 10.00
	update_money_ui()
