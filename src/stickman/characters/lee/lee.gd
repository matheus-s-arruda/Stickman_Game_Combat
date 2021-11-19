extends Stickman


var cooldown_3

var rival_layer := 1

func _ready():
	_hit_data_slide = [
			[15, Vector2(400, -200), null],
			Vector2(0, -24), Vector2(40, 24), rival_layer]
	
	_hit_data_jump = [
			[15, Vector2(100, -50), null],
			Vector2(0, -24), Vector2(40, 24), rival_layer]


func hitbox(_atk : int):
	match _atk:
		0: #normal punch
			spawn_hitbox([5, Vector2(origin.scale.x * 70, 0)], Vector2(0, -96), Vector2(48, 16), rival_layer)
		1: #hook
			spawn_hitbox([10, Vector2(origin.scale.x * 150, -120)], Vector2(0, -106), Vector2(32, 60), rival_layer)
		2: #normal kick
			spawn_hitbox([7, Vector2(origin.scale.x * 250, -170)], Vector2(0, -96), Vector2(29, 32), rival_layer)
		3: #down kick
			spawn_hitbox([10, Vector2(origin.scale.x * 200, -100)], Vector2(0, -46), Vector2(48, 30), rival_layer)
		4: #knock out
			spawn_hitbox([20, Vector2(origin.scale.x * 500, -400), null], Vector2(0, -96), Vector2(48, 32), rival_layer)
		5: #especial_1, anim sincronia
			spawn_hitbox([30, Vector2(origin.scale.x * -800, -400), true], Vector2(55, -124), Vector2(20, 8), rival_layer)


