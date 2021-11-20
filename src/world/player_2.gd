extends Node2D


func _init():
	add_child(Gameplay.player_2)
	yield(Gameplay.player_2, "ready")
	Gameplay.player_2.hurtbox.set_collision_layer_bit(2, true)
	Gameplay.player_2.origin.scale.x = -1


func _physics_process(delta):
	Gameplay.player_2.move()


