extends KinematicBody2D

enum EnemyType {
	BASIC,
	INTERMEDIATE,
	ADVANCED,
	LEVEL_4,
	LEVEL_5
}
export(EnemyType) var type

export var bullet = preload("res://EnemyBullet.tscn")
var should_shoot = true

var bullet_container
export var health = 100.0
export var max_health = 100.0
export var bullet_time = 0.5
export var speed = 300.0
var velocity = Vector2()

func _ready():
	$Timer.start(bullet_time / (health/max_health))
# warning-ignore:return_value_discarded
	EventBus.connect("back_to_main_menu", self, "_back_to_main_menu")

func _physics_process(delta):
# warning-ignore:return_value_discarded
	move_and_collide(velocity*speed*delta)

func _on_Timer_timeout():
	if should_shoot:
		create_bullet()
	$Timer.stop()
	if should_shoot:
		$Timer.start(bullet_time / (health/max_health))

func create_bullet():
	for position_2d in $Positions.get_children():
		var new_bullet = bullet.instance()
		new_bullet.position = position+position_2d.position
		bullet_container.add_child(new_bullet)
	$AudioStreamPlayer.play()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Area2D_body_entered(body):
	if body.is_in_group("bullet"):
		health -= 10
		body.queue_free()
		modulate.a -= 10/max_health
		EventBus.emit_signal("enemy_damaged", type)

	if health <= 0:
		var eve = EnemyKilledEvent.new(type, position)
		EventBus.emit_signal("enemy_killed", eve)
		queue_free()

func _back_to_main_menu():
	queue_free()
