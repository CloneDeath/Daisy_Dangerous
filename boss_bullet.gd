extends Area2D
const MAX_VEL = 250
var vel = Vector2()

var explosion_scn = preload( "res://bomb_explosion.tscn" )


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _physics_process(delta):
	position += MAX_VEL * vel * delta


func _on_boss_bullet_body_entered(body):
	#print( "BOSS BULLET: ", body.name )
	if body.name == "boss": return
	if body == game.player:
		body.destroy()
		pass
	var e = explosion_scn.instance()
	e.position = position
	get_parent().add_child( e )
	queue_free()
	pass # replace with function body
