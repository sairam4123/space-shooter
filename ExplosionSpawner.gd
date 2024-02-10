extends Node2D

const Explosion = preload("res://Explosion.tscn")

export(NodePath) var explosions_np
onready var explosions = get_node_or_null(explosions_np)

func explode_at(pos: Vector2):
	var explosion = Explosion.instance()
	explosion.position = pos
	explosions.add_child(explosion)
	explosion.explode()

func _ready():
	EventBus.connect("enemy_killed", self, "_enemy_killed")
	EventBus.connect("player_killed", self, "_player_killed")
	

func _enemy_killed(event: EnemyKilledEvent):
	explode_at(event.pos)

func _player_killed(event: PlayerKilledEvent):
	explode_at(event.pos)
