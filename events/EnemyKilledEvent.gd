extends Reference
class_name EnemyKilledEvent

var pos: Vector2
var type: int

func _init(p_type: int, p_pos: Vector2):
	self.pos = p_pos
	self.type = p_type
	
