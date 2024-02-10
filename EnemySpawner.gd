extends Node2D

export(Array, PackedScene) var enemies = []

export(NodePath) var enemy_container_node
onready var enemy_container = get_node(enemy_container_node)
export(NodePath) var bullet_container_node
onready var bullet_container = get_node(bullet_container_node)

var should_shoot = true
var player_noticed = false

var _player_killed = false
var _time_since_player_found = 0
var _time_since_player_killed = 0

var enemy_time_taken_player_reach = 20
var enemy_time_taken_player_stop = 185
var bullet_spawn_start = 25
var bullet_spawn_stop = 35

func _ready():
	EventBus.connect("player_killed", self, "_on_player_killed")

func _on_player_killed(eve):
	_player_killed = true

func _on_Timer_timeout():
	
	_time_since_player_found += 1
	if _player_killed:
		_time_since_player_killed += 1
	if _time_since_player_found >= bullet_spawn_start and not player_noticed:
		player_noticed = true
	if _time_since_player_killed >= bullet_spawn_stop and player_noticed:
		player_noticed = false
	
	$Timer.start(Waves.enemy_spawn_time+rand_range(0.01, 0.05))
	
	if _time_since_player_killed >= enemy_time_taken_player_stop and _player_killed:
		return
	if _time_since_player_found <= enemy_time_taken_player_reach and !_player_killed:
		return
	
	spawn_enemy()

func spawn_enemy():
	$Path2D/PathFollow2D.unit_offset = randf()
	randomize()
	
	var enemy_selection = min(int(Waves.enemy_random_chance), enemies.size()-1)
	var next_enemy_selection = min(int(Waves.enemy_random_chance)+1, enemies.size()-1)
	var enemy = enemies[enemy_selection]
	var fracted_chance = Waves.fract(Waves.enemy_random_chance)
	if fracted_chance > 0.23 and randf() < fracted_chance:
		enemy = enemies[next_enemy_selection]
	
	var new_enemy = enemy.instance()
	new_enemy.position = $Path2D/PathFollow2D.global_position
	new_enemy.rotation = $Path2D/PathFollow2D.rotation
	new_enemy.velocity = Vector2.DOWN.rotated(new_enemy.rotation)
	new_enemy.bullet_container = bullet_container
	new_enemy.should_shoot = should_shoot and player_noticed
	enemy_container.add_child(new_enemy)
	
