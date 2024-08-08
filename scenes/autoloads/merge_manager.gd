extends Node

var last_emitter_animal: Animal


func _ready() -> void:
	GameEvents.animals_collided.connect(on_animal_collision)


func on_animal_collision(emitter_animal: Animal, other_animal: Animal) -> void:
	if last_emitter_animal != null:
		return
	
	last_emitter_animal = emitter_animal
	
	handle_merge(emitter_animal, other_animal)


func handle_merge(emitter_animal: Animal, other_animal: Animal) -> void:
	var merged_animal_type := emitter_animal.get_animal_type() + 1
	
	var merged_animal_spawn_position := (emitter_animal.global_position + other_animal.position) / 2
	
	emitter_animal.queue_free()
	other_animal.queue_free()
	
	await get_tree().process_frame
	last_emitter_animal = null
	
	GameEvents.fire_animals_merged(merged_animal_type, merged_animal_spawn_position)
