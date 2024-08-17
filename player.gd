extends KinematicBody2D

signal health_changed(value)
signal regen_changed(value)
signal ammo_changed(value)

enum MoveMode {
	KEYBOARD,
	JOYSTICK,
	GYROSCOPE,
	TOUCH
}


export var max_health_regen_storage = 10

var direction = Vector2()
var new_dir = Vector2()
var velocity = Vector2()

const MAX_SPEED = 7
var speed = 5
var speed_multiplier = 100

export(MoveMode) var move_type = MoveMode.KEYBOARD

export var health = 300.0
export var max_health = 300.0
export var bullet_time = 0.1
var health_regen_left = 5
var multiplier = 1
var health_ratio setget ,get_health_ratio

var ammo = 1500


func get_health_ratio():
	return health/max_health

var bullet = preload("res://Bullet.tscn")

export(NodePath) var joystick_node_path
var joystick_node = null

var disable_player = false

func _input(event):
	if event is InputEventMouseMotion and move_type == MoveMode.TOUCH: 
		new_dir = event.relative.limit_length(2.5) * 0.75
	if event is InputEventMouseButton and move_type == MoveMode.TOUCH:
		new_dir = (event.position - position).limit_length(1.5)

func _ready():
	if OS.has_touchscreen_ui_hint() and OS.has_feature("mobile"):
		move_type = MoveMode.GYROSCOPE
	
	if joystick_node_path:
		joystick_node = get_node(joystick_node_path)
#		move_type = MoveMode.JOYSTICK

func _physics_process(delta):
	if disable_player:
		if not $CollisionShape2D.disabled:
			$CollisionShape2D.set_deferred("disabled", true)
		return
	
	if move_type == MoveMode.KEYBOARD:
		speed = 5
		new_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	elif move_type == MoveMode.TOUCH:
		speed = 4.2
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and $Timer.is_stopped():
			create_bullet()
			$Timer.start(bullet_time / multiplier)
		
	elif move_type == MoveMode.JOYSTICK:
		speed = 3.5
		new_dir = joystick_node.output
	elif move_type == MoveMode.GYROSCOPE:
		speed = 4.2
		if Input.is_mouse_button_pressed(BUTTON_LEFT) and $Timer.is_stopped():
			create_bullet()
			$Timer.start(bullet_time / multiplier)
		var orientation = Input.get_accelerometer().y
		print("Accelerometer Y: %.2f" % orientation)
		var oriented_x = Input.get_gyroscope().z if abs(orientation) >= 9 and abs(orientation) <= 11 else -Input.get_gyroscope().y
		var acc_x = clamp(abs(oriented_x), 0.25, 2.5) * sign(oriented_x) * int(abs(oriented_x) > 0.25) * 1.65
		var gyro_x = clamp(abs(Input.get_gyroscope().x), 0.25, 2.5) * sign(Input.get_gyroscope().x) * int(abs(Input.get_gyroscope().x) > 0.25)
		print("Gyro X X: %.2f Gyro X: %.2f New Gyro X: %.2f New Gyro X: %.2f" % [Input.get_gyroscope().z, Input.get_gyroscope().x, acc_x, gyro_x])
		new_dir = Vector2(-acc_x, gyro_x)
	direction = lerp(direction, new_dir, delta * 16)
#	velocity *= speed * speed_multiplier
	velocity = move_and_slide(direction * speed * speed_multiplier, Vector2.UP)
	wrap_sprite()
	direction = lerp(direction, Vector2.ZERO, delta * 4)
	new_dir = direction
	
	if Input.is_action_pressed("fire") and $Timer.is_stopped():
		create_bullet()
		$Timer.start(bullet_time / multiplier)

func create_bullet():
	if ammo < 1:
		return
	ammo -= 2
	emit_signal("ammo_changed", ammo)
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
		
	if body.is_in_group("enemy_bullet"):
		health -= body.damage
		emit_signal("health_changed", self.health_ratio)
		body.queue_free()
	
	if body.is_in_group("pickup") and body.opened:
		_handle_pickup(body)
		body.queue_free()
	
	if body.is_in_group("enemy"):
		var event = EnemyKilledEvent.new(body.type, body.position)
		EventBus.emit_signal("enemy_killed", event)
		body.queue_free()
		health -= 0.25 * max_health
		emit_signal("health_changed", self.health_ratio)
		
	
	if health <= 0 and health_regen_left:
		EventBus.emit_signal("player_resurrected")
		$HealthRegenTimer.stop()
		health_regen_left -= 1
		health = max_health
		emit_signal("health_changed", self.health_ratio)
		emit_signal("regen_changed", health_regen_left)
	
	_handle_damage()
	if health <= 0 and not health_regen_left:
		var event = PlayerKilledEvent.new(position)
		EventBus.emit_signal("player_killed", event)
		queue_free()
	
	
	if health > 0:
		$Timer.wait_time = bullet_time / (self.health_ratio)

func _handle_pickup(body):
	if body.type == "regen":
		health_regen_left += 1
		health_regen_left = clamp(health_regen_left, 0, max_health_regen_storage)
		emit_signal("regen_changed", health_regen_left)
	if body.type == "health":
		if self.health_ratio <= 0.50 and health_regen_left:
			$HealthRegenTimer.start()
			emit_signal("health_changed", self.health_ratio)
	if body.type == "ammo":
		ammo += 100
		emit_signal("ammo_changed", ammo)
	if body.type == "gun":
		multiplier *= 1.5
		$BulletMultiplier.start()


func _on_HealthRegenTimer_timeout():
	health += 0.05 * max_health
	emit_signal("health_changed", self.health_ratio)
	_handle_damage()
#	modulate.a = health/100.0
	if self.health_ratio >= 0.90:
		$HealthRegenTimer.stop()
	
func _handle_damage():
	$PlayerShip1Damage1.hide()
	$PlayerShip1Damage2.hide()
	$PlayerShip1Damage3.hide()
	if self.health_ratio <= 0.90:
		$PlayerShip1Damage1.show()
	if self.health_ratio <= 0.70:
		$PlayerShip1Damage2.show()
	if self.health_ratio <= 0.30:
		$PlayerShip1Damage3.show()


func _on_BulletMultiplier_timeout():
	multiplier /= 1.5
	multiplier = clamp(multiplier, 1, INF)
