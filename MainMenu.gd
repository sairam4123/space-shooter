extends Control

func _ready():
	open_animation()
# warning-ignore:return_value_discarded
	EventBus.connect("game_stop", self, "on_game_stop")
	UIEventBus.connect("main_menu", self, "_main_menu")

func _on_TextureButton_pressed():
	hide()
	$MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/StartButton/AudioStreamPlayer.play()
	get_parent().start_game()
	$MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/StartButton.release_focus()
	set_process_input(false)
	$AudioStreamPlayer.stop()


func _on_SettingsButton_pressed():
	hide()
	set_process_input(false)
	UIEventBus.emit_signal("settings_opened")


func on_game_stop():
	show()
	set_process_input(true)
	$AudioStreamPlayer.play()

func _main_menu():
	show()
	set_process_input(true)
#	$AudioStreamPlayer.play()


func _on_ExitButton_pressed():
	$MarginContainer/VBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/ExitButton/AudioStreamPlayer.play()
	get_parent().quit_game()

func open_animation():
	var anim = create_tween()
	anim.tween_interval(0.25)
	anim.tween_property($"%Title", "modulate:a", 1.0, 0.45).from(0.0)
	anim.parallel().tween_property($"%Title", "percent_visible", 1.0, 0.45).from(0.0)
	anim.tween_property($"%StartButton", "modulate:a", 1.0, 0.25).from(0.0)
	for child in $"%HBoxContainer".get_children():
		anim.tween_property(child, "modulate:a", 1.0, 0.25).from(0.0)
	anim.tween_property($"%Credits", "modulate:a", 0.35, 0.15).from(0.0)
	anim.tween_property($"%Sign", "modulate:a", 1.0, 0.25).from(0.0)
	

