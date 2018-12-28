extends Node2D

signal text_finished

const FIRST_LEVEL = "res://level_01.tscn"#"test_stairs.tscn"#"end_level.tscn"#

func _ready():
	_load_scene("res://intro_screen.tscn" )#( "res://level_01.tscn" )##( "res://opening_screen.tscn" )#
	$camera.target_nxt = "player"

func set_hearts( value ):
	$gui_layer/gui/hearts/counter.text = "x" + str( value )

var load_state = 0
var cur_scn = ""
func _load_scene( scn ):
	if load_state == 0:
		# set current scene
		cur_scn = scn
		# fade out
		$transition_layer/transanim.play( "fade_out" )
		load_state = 1
		$loadtimer.set_wait_time( 0.3 )
		$loadtimer.start()
	elif load_state == 1:
		# hide hud
		$gui_layer/gui.hide()
		# clear current act
		var children = $levels.get_children()
		if children.size() > 0:
			if children[0].has_method( "is_level" ):
				_disconnect_level( children[0] )
			children[0].queue_free()
		load_state = 2
		$loadtimer.set_wait_time( 0.1 )
		$loadtimer.start()
	elif load_state == 2:
		# load new act
		var act = load( cur_scn ).instance()
		if act.has_method( "is_level" ):
			act.is_level( cur_scn )
			_connect_level( act )
		$levels.add_child( act )
		# act specific settings
		load_state = 3
		$loadtimer.set_wait_time( 0.1 )
		$loadtimer.start()
	elif load_state == 3:
		game.camera.reset_smoothing()
		#show hud
		if $levels.get_child(0).has_method( "is_level" ):
			$gui_layer/gui.show()
		# fade in
		$transition_layer/transanim.play( "fade_in" )
		# play stuff
		load_state = 4
		$loadtimer.set_wait_time( 0.3 )
		$loadtimer.start()
	elif load_state == 4:
		# unpause game
		#pause_game( false )
		#_allowinput = true
		load_state = 0



func update_gamestate( gamestate ):
	for x in range( 1, 7 ):
		if x > gamestate["bullets"]:
			get_node( "gui_layer/gui/bullets/bullet_" + str(x) ).hide()
		else:
			get_node( "gui_layer/gui/bullets/bullet_" + str(x) ).show()
	for x in range( 1, 7 ):
		if x > gamestate["bombs"]:
			get_node( "gui_layer/gui/bombs/bomb_" + str(x) ).hide()
		else:
			get_node( "gui_layer/gui/bombs/bomb_" + str(x) ).show()

func _on_loadtimer_timeout():
	_load_scene( cur_scn )

func _connect_level( v ):
	v.connect( "restart_level", self, "_restart_level" )
	v.connect( "finished_level", self, "_finished_level" )
	v.connect( "game_over", self, "_game_over" )

func _disconnect_level( v ):
	v.disconnect( "restart_level", self, "_restart_level" )
	v.disconnect( "finished_level", self, "_finished_level" )
	v.disconnect( "game_over", self, "_game_over" )

func _start_game():
	game.set_initial_gamestate()
	game.set_initial_bullets()
	_load_scene( FIRST_LEVEL )

func _restart_level(start_state=0):
	game.set_initial_bullets()
	load_state = start_state
	_load_scene( cur_scn )

func _finished_level( nxt_level ):
	load_state = 0
	_load_scene( nxt_level )

func _game_over():
	# start glitch
	$transition_layer/transanim.play( "glitch" )
	# set mode
	if game.gamestate[ "mode" ] == "player":
		game.gamestate[ "mode" ] = "banana"
	else:
		game.gamestate[ "lives" ] = 6
		game.gamestate[ "mode" ] = "player"



func set_character_text( obj, msg, duration = 2, offset = Vector2( 0, -32 ) ):
	$gui_layer/gui/text.set_char_text( obj, msg, duration, offset )
func _on_text_text_finished():
	emit_signal( "text_finished" )




var cur_music = ""
func play_music( nxt_music, restart_music = false ):
	if nxt_music != cur_music or restart_music:
		cur_music = nxt_music
		$music.stream = load( cur_music )
		$music.play()








