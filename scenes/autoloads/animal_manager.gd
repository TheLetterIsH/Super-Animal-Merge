extends Node

@export var spawnable_animal_scenes: Array[PackedScene]
@export var animal_scenes: Array[PackedScene]


func _ready() -> void:
	pass


func get_random_spawnable_animal_scene() -> PackedScene:
	return spawnable_animal_scenes.pick_random()
