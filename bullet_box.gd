extends Area2D

var _is_caught = false

func _on_heart_body_entered( body ):
	if _is_caught: return
	if body != game.player: return
	_is_caught = true
	game.player.get_node( "sfx" ).mplay( preload( "player_pick.wav" ) )
	game.gamestate[ "bullets" ] = 6
	queue_free()
