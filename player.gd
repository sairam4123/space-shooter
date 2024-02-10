extends KinematicBody2D

signal health_changed(value)
signal regen_changed(value)

export var max_health_regen_storage = 10

var velocity = Vector2()

var speed = 5
var speed_multiplier = 100

export var health = 300.0
export var max_health = 300.0
export var bullet_time = 0.1
var health_regen_left = 5
var multiplier = 1

var bullet = preload("res://Bullet.tscn")

export(NodePath) var joystick_node_path
var joystick_node = null

var disable_player = false


func _ready():
	if joystick_node_path:
		joystick_node = get_node(joystick_node_path)

func _physics_process(_delta):
	if disable_player:
		if not $CollisionShape2D.disabled:
			$CollisionShape2D.set_deferred("disabled", true)
		return
	if OS.has_feature("mobile") or joystick_node.get_parent().visible:
		velocity = joystick_node.output
		speed = 6
	else:
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		speed = 5
	
	velocity = move_and_slide(velocity * speed * speed_multiplier, Vector2.UP)
	
	wrap_sprite()
	
	if Input.is_action_pressed("fire") and $Timer.is_stopped():
		create_bullet()
		$Timer.start(bullet_time / multiplier)

func create_bullet():
	for position_2d in $Positions.get_children():
		var bullet_1 = bullet.instance()
		bullet_1.position = position+position_2d.position
		get_tree().get_root().add_child(bullet_1)
	$AudioStreamPlayer.play()


func wrap_sprite():
	position.x = wrapf(position.x, 0, get_viewport_rect().size.x)
	position.y = wrapf(position.y, 0, get_viewport_rect().size.y)


func _on_Area2D_body_entered(body):
	if disable_player:
		return
	if Input.is_key_pressed(KEY_K):
		health = 0
		emit_signal("health_changed", 0)
		
	if body.is_in_group("enemy_bullet"):
		health -= body.damage
		emit_signal("health_changed", health/max_health)
		body.queue_free()
	
	if body.is_in_group("pickup") and body.opened:
		_handle_pickup(body)
			
		body.queue_free()
	
	if body.is_in_group("enemy"):
		var event = EnemyKilledEvent.new(body.type, position)
		EventBus.emit_signal("enemy_killed", event)
		body.queue_free()
		health -= 0.25 * max_health
		emit_signal("health_changed", health/max_health)
		
	
	if health <= 0 and health_regen_left:
		EventBus.emit_signal("player_resurrected")
		health_regen_left -= 1
		health = max_health
		emit_signal("health_changed", health/max_health)
		emit_signal("regen_changed", health_regen_left)
	
	_handle_damage()
	if health <= 0 and not health_regen_left:
		var event = PlayerKilledEvent.new(position)
		EventBus.emit_signal("player_killed", event)
		queue_free()
	
	
	if health > 0:
		$Timer.wait_time = bullet_time / (health/max_health)

# Todo replace auto-regen with manual-regen	
#	if health <= 0.35 * max_health and health >= 0.10 * max_health and $HealthRegenTimer.is_stopped() and health_regen_left:
#		$HealthRegenTimer.start()
#		health_regen_left -= 1
#		emit_signal("regen_changed", health_regen_left)

func _handle_pickup(body):
	if body.type == "regen":
		health_regen_left += 1
		health_regen_left = clamp(health_regen_left, 0, max_health_regen_storage)
		emit_signal("regen_changed", health_regen_left)
	if body.type == "health":
		if health <= 0.75 * max_health and health_regen_left:
			health_regen_left -= 1
			health = max_health
			emit_signal("health_changed", health/max_health)
			emit_signal("regen_changed", health_regen_left)
	if body.type == "gun":
		multiplier *= 1.5
		$BulletMultiplier.start()


func _on_HealthRegenTimer_timeout():
	health += 0.05 * max_health
	emit_signal("health_changed", health/max_health)
	_handle_damage()
#	modulate.a = health/100.0
	if health >= 0.95 * max_health:
		$HealthRegenTimer.stop()
	
func _handle_damage():
	$PlayerShip1Damage1.hide()
	$PlayerShip1Damage2.hide()
	$PlayerShip1Damage3.hide()
	if health <= 0.70 * max_health:
		$PlayerShip1Damage1.show()
	if health <= 0.50 * max_health:
		$PlayerShip1Damage2.show()
	if health <= 0.30 * max_health:
		$PlayerShip1Damage3.show()


func _on_BulletMultiplier_timeout():
	multiplier /= 1.5
	multiplier = clamp(multiplier, 1, INF)
