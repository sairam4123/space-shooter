extends Control


onready var current_background: TextureRect = $Background
onready var next_background: TextureRect = $Background2
var temp_background
export var speed = 100


func _process(delta):
	if current_background.rect_position.y > get_viewport().size.y*1.5:
		print(current_background, next_background)
		temp_background = current_background
		current_background = next_background
		next_background = temp_background
		print(current_background, next_background)
		set_bg()
	

func set_bg():
	current_background.show()
	current_background.speed = speed
	next_background.speed = 0
	next_background.reset()
	next_background.hide()
