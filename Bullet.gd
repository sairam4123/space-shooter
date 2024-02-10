extends KinematicBody2D

signal collided(collider)

var speed = 600

var velocity = Vector2.UP

func _physics_process(delta):
	var collision = move_and_collide(velocity*speed*delta)
	if collision and collision.collider and !collision.collider.is_in_group("player") and !collision.collider.is_in_group("bullet"):
		emit_signal("collided", collision.collider)


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
