extends Node2D

export(String) var nxt_level = "res://level_01.tscn"
export(String) var music = "res://level_02.ogg"
signal finished_level
signal restart_level
signal game_over

var finished = false

func _ready():
	# place player at initial position
	$player.global_position = $start_position.global_position
	#print( "player: ", game.player )
	game.player.connect( "player_dead", self, "_on_player_dead" )
	# set camera limits
	game.gamestate["level"] = ""
	game.camera.limit_right = $finish_area.global_position.x
	game.camera_target = ""
	game.camera.position = Vector2( 320 / 2, -180 / 2 )
	game.main.play_music( music )

#func is_level( n ):
#	return
#	#game.gamestate[ "level" ] = n

func _physics_process(delta):
	if Input.is_key_pressed( KEY_ESCAPE ):
		game.main._finished_level( "res://intro_screen.tscn" )

func _on_finish_area_body_entered(body):
	pass

func _on_player_dead():
	var p = preload( "res://player.tscn" ).instance()
	p.position = Vector2( 160, -180 )
	$walls.add_child( p )
	#game.main._finished_level( "res://intro_screen.tscn" )
