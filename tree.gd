tool
extends Node2D

export( int, 7 ) var tree_no = 0 setget _set_tree

func _ready():
	if $Sprite == null or tree_no == null: return
	$Sprite.frame = tree_no
	set_tree_by_number( tree_no )

func _set_tree( v ):
	tree_no = v
	if Engine.editor_hint:
		if $Sprite == null: return
		$Sprite.frame = tree_no
		set_tree_by_number( tree_no )

func set_tree_by_number( t ):
	if Engine.editor_hint: return
	for n in range( 4 ):
		if ( t < 4 and n == t ) or ( t >= 4 and n == ( t - 4 ) ):
			continue
		get_node( "area_" + str( n + 1 ) ).queue_free()
	return
