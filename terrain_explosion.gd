extends Sprite

signal finished
func _ready():
	var astr = "cycle " + str( ( randi() % 3 ) + 1 )
	$AnimationPlayer.play( astr )
	game.camera.shake( 0.5, 30, 4 )

func delete_tile():
	emit_signal( "finished" )
