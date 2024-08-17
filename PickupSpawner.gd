extends Node2D


export(Array, PackedScene) var pickup_effects = []
export(Array, String) var names = []
export(Dictionary) var pickup_effect_spawn_rate_dict = {}
export(NodePath) var pickup_container_np
onready var pickup_container = get_node_or_null(pickup_container_np)
export(float) var speed = 210

func _ready():
	EventBus.connect("spawn_pickup", self, "spawn_pickup_type")

func _on_Timer_timeout():
	spawn_pickup()

func spawn_pickup():
	$Path2D/PathFollow2D.unit_offset = randf()
	var pickup = pickup_effects[randi() % pickup_effects.size()]
	var new_pickup = pickup.instance()
	new_pickup.position = $Path2D/PathFollow2D.position
	new_pickup.rotation = $Path2D/PathFollow2D.rotation
	new_pickup.velocity = Vector2.DOWN.rotated(new_pickup.rotation)
	new_pickup.game = get_parent()
	pickup_container.add_child(new_pickup)
	if randi() % 25 == 0:
		new_pickup.open()

func spawn_pickup_type(type, pos):
	var pickup = pickup_effects[names.find(type)]
	var new_pickup = pickup.instance()
	new_pickup.position = pos
	new_pickup.rotation = 0
	new_pickup.velocity = Vector2.DOWN.rotated(new_pickup.rotation)
	new_pickup.game = get_parent()
	pickup_container.call_deferred("add_child", new_pickup)
	new_pickup.open()
	
