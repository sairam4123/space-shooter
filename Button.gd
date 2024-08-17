extends TextureButton





#func _process(_delta):
#	if pressed:
#		print("pressed??")
#		var fire = InputEventAction.new()
#		fire.set_action("fire")
#		fire.pressed = pressed
#		Input.parse_input_event(fire)

#	elif get_parent().visible:
#		var fire = InputEventAction.new()
#		fire.set_action("fire")
#		fire.pressed = pressed
#		Input.parse_input_event(fire)


func _on_Fire_button_down():
	var fire = InputEventAction.new()
	fire.set_action("fire")
	fire.pressed = pressed
	Input.parse_input_event(fire)


func _on_Fire_button_up():
	var fire = InputEventAction.new()
	fire.set_action("fire")
	fire.pressed = pressed
	Input.parse_input_event(fire)
