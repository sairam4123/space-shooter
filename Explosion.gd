extends Node2D

func explode():
	$Sprite.frame = randi() % $Sprite.frames.get_frame_count("default")
	var audio = get_random_apn()
	audio.play()
	$AnimationPlayer.play("explode")
	yield($AnimationPlayer, "animation_finished")
	$AnimationPlayer.play("fade")
	yield($AnimationPlayer, "animation_finished")
	queue_free()

func get_random_apn() -> AudioStreamPlayer2D:
	var children = $"%Audios".get_children()
	return children[randi() % children.size()]
