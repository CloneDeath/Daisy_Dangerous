extends KinematicBody2D

var dir = Vector2()
var vel = 300
var hit = false
var bullet_hit_scn = preload( "res://bullet_hit.tscn" )
var xplosion_scn = preload( "res://explosion.tscn" )

func _ready():
	if dir.x < 0:
		$bullet.flip_h = true

func _physics_process( delta ):
	if hit: return
	var coldata = move_and_collide( vel * dir * delta )
	if coldata != null:
		hit = true
		# check which body we are colliding with
		if coldata.collider.is_in_group( "tilemap" ) or coldata.collider.is_in_group( "destructible" ):
			# standard hit against wall or floor
			var b = bullet_hit_scn.instance()
			b.set_collision_position( coldata )
			get_parent().add_child( b )
		elif coldata.collider.is_in_group( "enemy" ):
			var b = bullet_hit_scn.instance()
			b.set_collision_position( coldata )
			get_parent().add_child( b )
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_hitbox_area_entered( area ):
	if not area.is_in_group( "damagebox" ) or hit: return
	hit = true
	area.get_parent().destroy( position )
	var x = xplosion_scn.instance()
	get_parent().add_child( x )
	x.global_position = area.global_position
	queue_free()
