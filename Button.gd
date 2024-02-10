extends TextureButton

func _process(_delta):
	if pressed:
		var fire = InputEventAction.new()
		fire.set_action("fire")
		fire.pressed = pressed
		Input.parse_input_event(fire)
	elif get_parent().visible:
		var fire = InputEventAction.new()
		fire.set_action("fire")
		fire.pressed = pressed
		Input.parse_input_event(fire)
