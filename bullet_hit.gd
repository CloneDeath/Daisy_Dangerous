extends Sprite

func set_collision_position( coldata ):
	var dx = sign( coldata.normal.x )
	var dy = ( coldata.normal.y )
	if dx < 0 and abs( dy ) < 0.2:
		# do not rotate
		position = coldata.position + Vector2( -16, 0 )
	elif dx > 0 and abs( dy ) < 0.2:
		# flip
		position = coldata.position + Vector2( 16, 0 )
		flip_h = true
	elif abs( dx ) < 0.2 and dy > 0:
		position = coldata.position + Vector2( 0, 16 )
		rotate( -PI / 2 )
	elif abs( dx ) < 0.2 and dy < 0:
		position = coldata.position + Vector2( 0, -16 )
		rotate( PI / 2 )
	var anim_str = "cycle_" + str( ( randi() % 3 ) + 1 )
	$AnimationPlayer.play( anim_str )

