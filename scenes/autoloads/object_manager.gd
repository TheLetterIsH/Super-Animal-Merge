extends Node


func get_animal_container() -> Node2D:
	return get_tree().get_first_node_in_group("animal_container")
