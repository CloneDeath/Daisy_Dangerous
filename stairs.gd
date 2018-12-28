extends TileMap

func _ready():
	game.stairs = self

func is_stairs( pos ):
	var aux = world_to_map( pos )
	var curtile = get_cell( aux.x, aux.y )
	if curtile == -1:
		return false
	return true