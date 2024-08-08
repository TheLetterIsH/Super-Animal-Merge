extends Node2D

@export_category("Box")
@export var box_bound: float = 458.0
@export var animal_spawn_position_y: float = -512.0

var is_action_pressed: bool 
var can_spawn_animal: bool
var current_animal_instance: Animal
var is_current_animal_in_control: bool

@onready var spawn_buffer_timer: Timer = $SpawnBufferTimer
@onready var drop_line: Line2D = %DropLine


func _ready() -> void:
	GameEvents.animals_merged.connect(on_animals_merged)
	
	can_spawn_animal = true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		is_action_pressed = true
		handle_action_just_pressed()
	elif event is InputEventMouseButton and !event.is_pressed():
		is_action_pressed = false
		if is_current_animal_in_control:
			handle_action_released()


func _process(delta: float) -> void:
	if is_action_pressed:
		if is_current_animal_in_control:
			handle_action_pressed()
		else:
			handle_action_just_pressed()


func handle_action_just_pressed() -> void:
	if !can_spawn_animal or is_current_animal_in_control:
		return
	
	spawn_animal()
	
	is_current_animal_in_control = true


func handle_action_pressed() -> void:
	current_animal_instance.set_position(get_action_position())


func handle_action_released() -> void:
	current_animal_instance.enable_physics()
	
	is_current_animal_in_control = false
	
	can_spawn_animal = false
	spawn_buffer_timer.start()


func spawn_animal() -> void:
	current_animal_instance = AnimalManager.get_random_spawnable_animal_scene().instantiate() as Animal
	current_animal_instance.position = get_action_position()
	ObjectManager.get_animal_container().add_child(current_animal_instance)


func on_animals_merged(merged_animal_type: Enums.ANIMAL_TYPE, merged_animal_spawn_position: Vector2) -> void:
	var merged_animal_scene := AnimalManager.animal_scenes[merged_animal_type]
	spawn_merged_animal(merged_animal_scene, merged_animal_spawn_position)


func spawn_merged_animal(merged_animal_scene: PackedScene, merged_animal_spawn_position: Vector2) -> void:
	var merged_animal_instance := merged_animal_scene.instantiate() as Animal
	merged_animal_instance.position = merged_animal_spawn_position
	ObjectManager.get_animal_container().add_child(merged_animal_instance)
	
	merged_animal_instance.enable_physics()


func get_action_position() -> Vector2:
	var spawn_position := get_global_mouse_position()
	spawn_position.y = animal_spawn_position_y
	
	var updated_box_bound := box_bound - current_animal_instance.get_radius()
	
	if spawn_position.x < -updated_box_bound:
		spawn_position.x = -updated_box_bound
	elif spawn_position.x > updated_box_bound:
		spawn_position.x = updated_box_bound
	
	return spawn_position


func draw_drop_line() -> void:
	var origin_position := get_action_position()
	drop_line.set_point_position(0, origin_position)
	drop_line.set_point_position(1, Vector2(origin_position.x, 720))


func _on_spawn_buffer_timer_timeout() -> void:
	can_spawn_animal = true
