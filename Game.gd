extends Node2D

var disable_player = false
var enemy_player_time = 10

export var background_speed = 210 setget set_speed

func _ready():
	set("background_speed", background_speed)
# warning-ignore:return_value_discarded
	EventBus.connect("game_stop", self, "_game_stop")
	EventBus.connect("player_resurrected", self, "move_player_to_y", [545.0])
	$Player.visible = not disable_player
	$CanvasLayer.visible = not disable_player
	$EnemySpawner.should_shoot = not disable_player
	$EnemySpawner.enemy_time_taken_player_reach = enemy_player_time
	$AudioStreamPlayer.playing = not disable_player
	
	$Player.disable_player = disable_player
	if not disable_player:
		move_player_to_y(545)

func _process(delta):
	self.background_speed += (Waves.background_speed-background_speed) * delta

func _game_stop():
	$AudioStreamPlayer.stop()

func move_player_to_y(new_y):
	create_tween().tween_property($Player, "position:y", new_y, 0.75).from(655.0)

func set_speed(val):
	background_speed = val
	if is_inside_tree():
		$BackgroundHandler/Background.speed = background_speed
		$BackgroundHandler/Background2.speed = background_speed
