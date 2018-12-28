extends Area2D

var _is_triggered = false
func _on_trigger_area_body_entered(body):
	if _is_triggered: return
	_is_triggered = true
	$anim.play( "cycle" )
	var aux = AudioStreamPlayer.new()
	add_child( aux )
	aux.stream = preload( "res://boulder_roll.wav" )
	aux.play()

func shake():
	game.camera.shake( 0.5, 30, 4 )

func _on_boulder_body_entered(body):
	if body.has_method( "destroy" ):
		body.destroy( position )
