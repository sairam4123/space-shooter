extends Control


func _ready():
	UIEventBus.connect("settings_opened", self, "_settings_shown")

func _save_settings():
	hide()
	UIEventBus.emit_signal("main_menu")

func _settings_shown():
	show()

func _on_SettingsButton_pressed():
	_save_settings()
