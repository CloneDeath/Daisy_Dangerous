extends Node

var camera setget _set_camera, _get_camera

var player setget _set_player, _get_player
var gamestate = { \
		"mode" : "player", \
		"lives": 6, \
		"bullets": 6, \
		"bombs": 6, \
		"events": [], \
		"level": "" } setget _set_gamestate

var stairs = null setget _set_stairs, _get_stairs
var main = null

#===========================
func _set_camera( v ):
	camera = weakref( v )
func _get_camera():
	if camera == null: return null
	return camera.get_ref()
#===========================
func _set_player( v ):
	player = weakref( v )
func _get_player():
	if player == null: return null
	return player.get_ref()
#===========================
func _set_stairs( v ):
	stairs = weakref( v )
func _get_stairs():
	if stairs == null: return null
	return stairs.get_ref()
#===========================
func _set_gamestate( v ):
	gamestate = v
	if main != null: main.update_gamestate( gamestate )


func _ready():
	set_pause_mode( Node.PAUSE_MODE_PROCESS )
	var _root = get_tree().get_root()
	main = _root.get_child( _root.get_child_count() - 1 )
	if main.get_name() != "main":
		main = null
	set_initial_gamestate()

func set_initial_gamestate():
	gamestate[ "mode" ] = "player"#"banana"
	gamestate[ "lives" ] = 6
	gamestate[ "events" ] = []

func set_initial_bullets():
	gamestate[ "bullets" ] = 6
	gamestate[ "bombs" ] = 6

func is_event( evtname ):
	if gamestate[ "events" ].find( evtname ) == -1:
		return false
	return true

func add_event( evtname ):
	if gamestate[ "events" ].find( evtname ) == -1:
		gamestate[ "events" ].append( evtname )
		return true
	return false