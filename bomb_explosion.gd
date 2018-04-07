extends Area2D

var kill_player = true
func _ready():
	pass



func explode():
	if game.camera != null:
		game.camera.shake( 0.5, 30, 4 )
	# check bodies within the area
	var bodies = self.get_overlapping_bodies()
	#print( "bodies within explosion range" )
	for b in bodies:
		if not kill_player and b == game.player:
			continue
		if b.has_method( "destroy" ):
			b.destroy( position )
	pass