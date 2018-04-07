tool
extends Node2D

export( int, 7 ) var tree_no = 0 setget _set_tree

func _ready():
#	$Sprite.frame = tree_no
	print( get_name(), ": setting tree: ", tree_no )
	if $Sprite == null or tree_no == null: return
	$Sprite.frame = tree_no
	set_tree_by_number( tree_no )

func _set_tree( v ):
	tree_no = v
	if Engine.editor_hint:
		print( "tree_frame: ", $Sprite )
		if $Sprite == null: return
		$Sprite.frame = tree_no
		set_tree_by_number( tree_no )




func set_tree_by_number( t ):
	if Engine.editor_hint: return
	for n in range( 4 ):
		if ( t < 4 and n == t ) or ( t >= 4 and n == ( t - 4 ) ):
			continue
		var trstr = "area_" + str( n )
		print( "Cleaning tree: ", trstr ) 
		get_node( "area_" + str( n + 1 ) ).queue_free()
#	for sho in get_shape_owners():
#		if ( t < 4 and sho == t ) or ( t >= 4 and sho == ( t - 4 ) ):
#			continue
#		shape_owner_remove_shape( sho, 0 )
#		remove_shape_owner( sho )
	return
