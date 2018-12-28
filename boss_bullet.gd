extends Area2D
const MAX_VEL = 250
var vel = Vector2()

var explosion_scn = preload( "res://bomb_explosion.tscn" )

func _physics_process(delta):
	position += MAX_VEL * vel * delta

func _on_boss_bullet_body_entered(body):
	if body.name == "boss": return
	if body == game.player:
		body.destroy()
	var e = explosion_scn.instance()
	e.position = position
	get_parent().add_child( e )
	queue_free()
