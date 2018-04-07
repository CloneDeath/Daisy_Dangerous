extends Sprite

func _ready():
	game.camera.shake( 0.5, 30, 4 )
	var astr = "cycle " + str( ( randi() % 3 ) + 1 )
	$AnimationPlayer.play( astr )


