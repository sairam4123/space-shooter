extends Node2D

var enemy_spawn_time = 1.2
var wave = 0
var enemy_random_chance = 0.0
var background_speed = 110.0

func _on_Timer_timeout():
	if wave % 4 == 0: # every 4th wave, increase the chance of enemy change
		wave += 1
		enemy_random_chance += rand_range(0.05, 0.35)
		if fract(enemy_random_chance) >= 0.95:  # enemy change detected
			enemy_spawn_time = 1.85
	else:
		wave += 1
	enemy_spawn_time -= rand_range(0.01, 0.05)
	background_speed += rand_range(0.5, 5.0)
	enemy_spawn_time = clamp(enemy_spawn_time, 0.2, 2.5)

func start():
	enemy_spawn_time = 1.2
	wave = 0
	enemy_random_chance = 0.0
	background_speed = 110
	$Timer.start()

func stop():
	enemy_spawn_time = 1.2
	wave = 0
	enemy_random_chance = 0.0
	background_speed = 110
	$Timer.stop()

func fract(x):
	return fposmod(x, 1.0)
