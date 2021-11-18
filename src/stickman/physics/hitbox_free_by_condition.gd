extends Area2D

var hit = []
var extent := Vector2(32, 32)
var collide := 1

onready var _shape = $CollisionShape2D

func _ready():
	set_collision_mask_bit(collide, true)
	
	_shape.position.x = extent.x
	_shape.shape.extents = extent


func _on_hitbox_body_entered(body):
	body.hit = hit
	
	var _fx_c = Gameplay.FX_HIT_CIRCE.instance()
	add_child(_fx_c)
	_fx_c.position.x = extent.x * 2
	
	if body.atk_state != body.ATK_STATES.IN_BLOQ:
		var _fx_p = Gameplay.FX_HIT_PARTICLE.instance()
		add_child(_fx_p)
		_fx_p.position.x = extent.x * 2
