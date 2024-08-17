extends KinematicBody2D

export var type = "regen"
export var base_speed = 210
var velocity = Vector2.DOWN
var rot_speed = 50
export var health = 50
var opened = false
var game

func _ready():
	$Sprite.show()
	$ExposedSprite.hide()
	
func _physics_process(delta):
	if game:
		base_speed = game.background_speed
		rot_speed = game.background_speed / 4.5
	if opened:
		position += velocity * rot_speed * delta
		rotation_degrees += rot_speed * delta
	else:
		position += velocity * base_speed * delta



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group("bullet"):
		health -= 10
		body.queue_free()
	if health <= 0:
		open()

func open():
	$Sprite.hide()
	$ExposedSprite.show()
	opened = true
	collision_layer = (1 << 6)
	$Area2D.collision_layer = 1 << 6
	$Area2D.collision_mask = 0
