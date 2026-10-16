extends Node

signal flower_count_changed(type, new_count)
var money := 0.0

var vase2unlock = true
var vase3unlock = true
var vase4unlock = true

var current_outfit = 1
var current_hair = 1
var current_body = 1
var current_basket = 1

var collected_flowers = {
	"red": 0,
	"blue": 0,
	"yellow": 0,
	"narc1": 0,
	"narc2": 0,
	"tul1": 0,
	"tul2": 0,
	"tul3": 0
}

func add_flower(type: String):
	if collected_flowers.has(type):
		collected_flowers[type] += 1
		emit_signal("flower_count_changed", type, collected_flowers[type])

func remove_flower(type):
	if collected_flowers[type] > 0:
		collected_flowers[type] -= 1
		emit_signal("flower_count_changed", type, collected_flowers[type])
