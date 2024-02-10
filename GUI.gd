extends Control

onready var health_bar_progress = $"%HealthBarProgress"
onready var label_bar = $"%LabelBar"
onready var health_bar_label = $"%HealthBarLabel"

var score = 0.0 setget set_score

func _set_score_label(score):
	label_bar.text = "%07.2f" % score

func set_score(val):
	var _prev = score
	if !is_inside_tree():
		return
	score = val
	create_tween().tween_method(self, "_set_score_label", _prev, score, 0.1)
	
func _ready():
	open_animation()
	# warning-ignore:return_value_discarded
	EventBus.connect("enemy_killed", self, "_enemy_killed")
	# warning-ignore:return_value_discarded
	EventBus.connect("enemy_damaged", self, "_enemy_damaged")
# warning-ignore:return_value_discarded
	EventBus.connect("player_killed", self, "_player_killed")
	

func _on_Player_health_changed(value):
	health_bar_progress.value = value

func _enemy_killed(event):
	self.score += GlobalEnums.kill_score[event.type]

func _enemy_damaged(enemy):
	self.score += GlobalEnums.damage_score[enemy]

func _player_killed(_kill_event):
	hide()
	var over_event = GameOverEvent.new(score)
	EventBus.emit_signal("game_over", over_event)

func _on_TextureButton_pressed():
	close_animation()
	yield(get_tree().create_timer(0.25 * 5), "timeout")
	EventBus.emit_signal("back_to_main_menu")

func _on_Player_regen_changed(value):
	health_bar_label.text = str(value)

func open_animation():
	var anim = create_tween()
	anim.tween_interval(0.25)
	anim.tween_property($"%HomeButton", "modulate:a", 1.0, 0.25).from(0.0)
	anim.tween_property($"%HealthBarProgress", "modulate:a", 1.0, 0.25).from(0.0)
	anim.parallel().tween_property($"%HealthBarLabel", "modulate:a", 1.0, 0.25).from(0.0)
	anim.tween_property($"%LabelBar", "modulate:a", 1.0, 0.25).from(0.0)

func close_animation():
	var anim = create_tween()
	anim.tween_interval(0.25)
	anim.tween_property($"%LabelBar", "modulate:a", 0.0, 0.25).from(1.0)
	anim.tween_property($"%HealthBarProgress", "modulate:a", 0.0, 0.25).from(1.0)
	anim.parallel().tween_property($"%HealthBarLabel", "modulate:a", 0.0, 0.25).from(1.0)
	anim.tween_property($"%HomeButton", "modulate:a", 0.0, 0.25).from(1.0)
