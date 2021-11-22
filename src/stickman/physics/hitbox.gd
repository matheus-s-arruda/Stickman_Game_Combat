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


func _on_hitbox_area_entered(area):
	area.stickman.hit = hit

	if area.stickman.atk_state != area.stickman.ATK_STATES.IN_BLOQ:
		var _fx_p = Gameplay.FX_HIT_PARTICLE.instance()
		add_child(_fx_p)
		_fx_p.position.x = extent.x * 2

	if hit.size() == 3 and hit[2]:
		var _fx_s = Gameplay.FX_SONIC_IMPACT.instance()
		add_child(_fx_s)
		_fx_s.position.x = extent.x * 2
		
	else:
		var _fx_c = Gameplay.FX_HIT_CIRCE.instance()
		add_child(_fx_c)
		_fx_c.position.x = extent.x * 2
	
	


