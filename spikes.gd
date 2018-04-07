extends Area2D

export var spiketype = 0

func _ready():
	if spiketype == 0:
		$Sprite.region_rect = Rect2( Vector2( 56, 32 ), Vector2( 8, 8 ) )
	elif spiketype == 1:
		$Sprite.region_rect = Rect2( Vector2( 40, 80 ), Vector2( 8, 8 ) )


var is_hit = false
func _on_spikes_body_entered(body):
	if body != game.player: return
	if is_hit: return
	is_hit = true
	body.destroy()
