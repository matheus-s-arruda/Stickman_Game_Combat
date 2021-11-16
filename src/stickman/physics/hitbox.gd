extends Area2D

var hit = []
var extent := Vector2(32, 32)
var collide := 1

onready var _shape = $CollisionShape2D

func _ready():
	set_collision_mask_bit(collide, true)
	
	_shape.position.x = extent.x
	_shape.shape.extents = extent
	
	yield(get_tree().create_timer(0.1), "timeout")
	queue_free()


func _on_hitbox_body_entered(body):
	body.hit = hit
