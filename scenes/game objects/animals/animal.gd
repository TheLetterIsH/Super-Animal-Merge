extends RigidBody2D
class_name Animal

@export var animal_type: Enums.ANIMAL_TYPE
@export var scale_mult: float

var has_collided: bool

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	pass


func enable_physics() -> void:
	collision_shape.disabled = false
	freeze = false


func get_radius() -> float:
	return scale_mult * 256


func get_animal_type() -> Enums.ANIMAL_TYPE:
	return animal_type


func _on_body_entered(other_body: Node) -> void:
	if !other_body.is_in_group("animal"):
		return
	
	if other_body.get_animal_type() != animal_type:
		return
	
	GameEvents.fire_animals_collided(self, other_body)
