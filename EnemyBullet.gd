extends KinematicBody2D


signal collided(collider)

export var speed = 600
export var damage = 2

var velocity = Vector2.DOWN
var yielded = true

func _ready():
# warning-ignore:return_value_discarded
	EventBus.connect("game_stop", self, "_game_stop")

func _physics_process(delta):
	var collision = move_and_collide(velocity*speed*delta)
	if collision and collision.collider and !collision.collider.is_in_group("enemies") and !collision.collider.is_in_group("enemy_bullet"):
		emit_signal("collided", collision.collider)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _game_stop():
	queue_free()
