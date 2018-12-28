extends Sprite

var explosion_scn = preload( "res://bomb_explosion.tscn" )

func detonate():
	var x = explosion_scn.instance()
	x.position = position
	get_parent().add_child( x )
	queue_free()