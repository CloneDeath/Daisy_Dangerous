extends Area2D

const VEL = 180
var dir = 1

func _physics_process(delta):
	position += Vector2( delta * VEL * dir, 0 )

var hit = false

func _on_lifetimer_timeout():
	hit = true
	queue_free()

func _on_arrow_area_entered(area):
	if not area.is_in_group( "damagebox" ): return
	var body = area.get_parent()
	if not body.is_in_group( "enemy" ):
		body = body.get_parent()
		if body != game.player: return
	if hit: return
	hit = true
	body.destroy()
