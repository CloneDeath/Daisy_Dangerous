extends Area2D

var is_hit = false
func _on_dead_area_body_entered(body):
	if body != game.player: return
	if is_hit: return
	is_hit = true
	body.destroy()
