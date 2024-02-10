extends HBoxContainer

var debug = false
var is_touch = false

func _ready():
	if OS.has_feature("mobile"):
		is_touch = true
	
	if debug:
		is_touch = true
	
	$Fire.visible = is_touch
	$Joystick.visible = is_touch
	visible = is_touch
