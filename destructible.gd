extends TileMap;

var _offsets = [ \
	Vector2( 0, -1 ), Vector2( 0, 1 ),
	Vector2( 1, -1 ), Vector2( 1, 0 ), Vector2( 1, 1 ), \
	Vector2( -1, 1 ), Vector2( -1, 0 ), Vector2( -1, -1 ) ]

var _maplist = []
var _cur_idx = 0
var _is_destroying = false

var xpl_scn = preload( "res://terrain_explosion.tscn" )

func destroy( pos ):
	if _is_destroying: return

	_is_destroying = true
	# generate a list of all the tiles to destroy
	var mappos = world_to_map( pos )
	mappos = get_closest_used_cell( mappos )
	_add_cell_to_list( mappos )
	# start destroying
	_cur_idx = 0
	if not _maplist.empty():
		_destroy_cell( _maplist[_cur_idx] )
	else:
		_is_destroying = false

func get_closest_used_cell( pos ):
	var used_cells = self.get_used_cells()
	var closest = Vector2()
	var cur_dist = 10000000
	for u in used_cells:
		var d = u.distance_squared_to( pos )
		if d < cur_dist:
			cur_dist = d
			closest = u + Vector2()
	return closest

func _add_cell_to_list( mappos ):
	if get_cell( mappos.x, mappos.y ) == -1 or _maplist.find( mappos ) != -1:
		return
	else:
		_maplist.append( mappos )
		for o in _offsets:
			_add_cell_to_list( mappos + o )

func _destroy_cell( mappos ):
	var x = xpl_scn.instance()
	x.position = map_to_world( mappos )
	x.connect( "finished", self, "_move_to_nxt", [ x ] )
	add_child( x )

func _move_to_nxt( x ):
	x.disconnect( "finished", self, "_move_to_nxt" )
	set_cell( _maplist[_cur_idx].x, _maplist[_cur_idx].y, -1 )
	_cur_idx += 1
	if _cur_idx < _maplist.size():
		_destroy_cell( _maplist[_cur_idx] )
	else:
		_is_destroying = false
		_maplist = []
