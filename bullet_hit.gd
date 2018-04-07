extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_collision_position( coldata ):
	#print( "Collision data: ", coldata.normal )
	var dx = sign( coldata.normal.x )
	var dy = ( coldata.normal.y )
	if dx < 0 and abs( dy ) < 0.2:
		# do not rotate
		position = coldata.position + Vector2( -16, 0 )
	elif dx > 0 and abs( dy ) < 0.2:
		# flip
		#print( "Flipping blast" )
		position = coldata.position + Vector2( 16, 0 )
		flip_h = true
	elif abs( dx ) < 0.2 and dy > 0:
		position = coldata.position + Vector2( 0, 16 )
		rotate( -PI / 2 )
	elif abs( dx ) < 0.2 and dy < 0:
		position = coldata.position + Vector2( 0, -16 )
		rotate( PI / 2 )
	#print( "Blast position: ", position, " ", dx, " ", abs( dy ) )
	var anim_str = "cycle_" + str( ( randi() % 3 ) + 1 )
	$AnimationPlayer.play( anim_str )

