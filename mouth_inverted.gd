extends Sprite
export var wait_time = 0.1
var timer = 0
var arrow_scn = preload( "res://arrow.tscn" )

var _is_launching_cur = false
var _is_launching_nxt = false

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass



func _physics_process(delta):
	if _is_launching_nxt == true and _is_launching_cur == false:
		_is_launching_cur = true
		timer = wait_time
	elif _is_launching_nxt == false and _is_launching_cur == true:
		_is_launching_cur = false
	if _is_launching_cur:
		timer -= delta
		if timer <= 0:
			timer = 1 # 1 second between arrows
			_launch_arrow()
	


func _launch_arrow():
	var a = arrow_scn.instance()
	a.dir = -scale.x
	a.position = position + Vector2( scale.x * 3, -scale.y * 3 )
	get_parent().add_child( a )
	$AudioStreamPlayer.play()




func _on_find_collider_body_entered(body):
	if body == game.player:
		_is_launching_nxt = true



func _on_find_collider_body_exited(body):
	if body == game.player:
		_is_launching_nxt = false
