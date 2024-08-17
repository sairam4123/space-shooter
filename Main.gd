extends Node

var game = preload("res://Game.tscn")
var main_menu_game
var current_game

func _ready():
	_start_menu_game()
# warning-ignore:return_value_discarded
	EventBus.connect("game_stop", self, "end_game")
	EventBus.connect("game_restart", self, "restart_game")

func restart_game():
	end_game(true)
	start_game()

func start_game():
	if main_menu_game:
		_end_menu_game()
	
	current_game = game.instance()
	add_child(current_game)
	move_child(current_game, 0)
	Waves.start()

func end_game(restart=false):
	Waves.stop()
	current_game.queue_free()
	current_game = null
	
	if not restart:
		_start_menu_game()

func _end_menu_game():
	Waves.stop()
	main_menu_game.queue_free()
	main_menu_game = null
	
func quit_game():
	get_tree().quit(0)

func _start_menu_game():
	main_menu_game = game.instance()
	main_menu_game.disable_player = true
	main_menu_game.enemy_player_time = 2
	add_child(main_menu_game)
	move_child(main_menu_game, 0)
	Waves.enemy_random_chance = rand_range(0, 3)
	Waves.start()
	
