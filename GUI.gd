extends Control

var _elapsed = 0
onready var health_bar_progress = $"%HealthBarProgress"
onready var label_bar = $"%LabelBar"
onready var health_bar_label = $"%HealthBarLabel"
onready var ammo_label = $"%AmmoLabel"

var score = 0.0 setget set_score
var ammo_count = 0 setget set_ammo_count

func _set_score_label(score):
	label_bar.text = "%07.2f" % score

func _set_ammo_label(ammo):
	ammo_label.text = "%d" % ammo
func set_score(val):
	var _prev = score
	if !is_inside_tree():
		return
	score = val
	create_tween().tween_method(self, "_set_score_label", _prev, score, 0.05)

func set_ammo_count(val):
	var _prev = ammo_count
	if !is_inside_tree():
		return
	ammo_count = val
	create_tween().tween_method(self, "_set_ammo_label", _prev, ammo_count, 0.1)
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

func _process(delta):
	_elapsed += delta
	print(fmod(_elapsed, 5))
	if fmod(_elapsed, 0.5) < 0.05:
		self.score += 0.01

func _on_TextureButton_pressed():
	close_animation()
	yield(get_tree().create_timer(0.2 * 6), "timeout")
	EventBus.emit_signal("game_stop")

func _on_Player_regen_changed(value):
	health_bar_label.text = str(value)


func _on_Player_ammo_changed(value):
	self.ammo_count = value

func open_animation():
	var anim = create_tween()
	anim.tween_interval(0.25)
	anim.tween_property($"%HomeButton", "modulate:a", 1.0, 0.25).from(0.0)
	anim.tween_property($"%HealthBarProgress", "modulate:a", 1.0, 0.25).from(0.0)
	anim.parallel().tween_property($"%HealthBarLabel", "modulate:a", 1.0, 0.25).from(0.0)
	anim.tween_property($"%AmmoIcon", "modulate:a", 1.0, 0.25).from(0.0)
	anim.parallel().tween_property($"%AmmoLabel", "modulate:a", 1.0, 0.25).from(0.0)
	anim.tween_property($"%LabelBar", "modulate:a", 1.0, 0.25).from(0.0)

func close_animation():
	var anim = create_tween()
	anim.tween_property($"%LabelBar", "modulate:a", 0.0, 0.2).from(1.0)
	anim.tween_property($"%HealthBarProgress", "modulate:a", 0.0, 0.2).from(1.0)
	anim.parallel().tween_property($"%HealthBarLabel", "modulate:a", 0.0, 0.2).from(1.0)
	anim.tween_property($"%AmmoIcon", "modulate:a", 0.0, 0.2).from(1.0)
	anim.parallel().tween_property($"%AmmoLabel", "modulate:a", 0.0, 0.2).from(1.0)
	anim.tween_property($"%HomeButton", "modulate:a", 0.0, 0.2).from(1.0)
