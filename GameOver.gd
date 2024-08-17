extends Control

var score: float = 0

func _ready():
	hide()
	EventBus.connect("game_over", self, "_game_over")

func _game_over(event):
	show()
	set_score(event.score)

func set_score(val):
	create_tween().tween_property(self, "score", val, 1.4).from(0.0)

func _process(delta):
	$"%Score".text = "%.2f" % score
	


func _on_TextureButton_pressed():
	$"%Sound".play()
	EventBus.emit_signal("game_restart")
	hide()

func _on_TextureButton2_pressed():
	$"%Sound2".play()
	EventBus.emit_signal("game_stop")
	hide()
