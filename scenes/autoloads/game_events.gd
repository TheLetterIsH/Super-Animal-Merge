extends Node

signal animals_collided(this_animal: Animal, other_animal: Animal)
signal animals_merged(merged_animal_type: Enums.ANIMAL_TYPE, merged_animal_spawn_position: Vector2)


func fire_animals_collided(this_animal: Animal, other_animal: Animal) -> void:
	animals_collided.emit(this_animal, other_animal)


func fire_animals_merged(merged_animal_type: Enums.ANIMAL_TYPE, merged_animal_spawn_position: Vector2) -> void:
	animals_merged.emit(merged_animal_type, merged_animal_spawn_position)
