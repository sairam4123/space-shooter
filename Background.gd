extends TextureRect

export var speed = 10

func _process(delta):
	rect_position.y = wrapf(rect_position.y+speed*delta, get_init_position(), get_final_position())

func reset():
	rect_position.y = get_init_position()

func get_init_position():
	return -(rect_size.y+get_viewport_rect().size.y+get_viewport_rect().size.y*1.5)

func get_final_position():
	return get_viewport_rect().size.y
