extends Area2D

enum STATES { IDLE, FLY }
var state_cur = 0
var state_nxt = STATES.IDLE
var vel = Vector2()
var dir = 1
const FLYVEL = 60

func _ready():
	$anim.seek( rand_range( 0, 3 ) )
	var x = randf()
	if x > 0.5:
		$rotate.scale.x = -1

func _physics_process(delta):
	state_cur = state_nxt
	
	if state_cur == STATES.IDLE:
		_state_idle( delta )
	elif state_cur == STATES.FLY:
		_state_fly( delta )
	


func _state_idle( delta ):
	pass

func _state_fly( delta ):
	if $anim.current_animation != "fly":
		$anim.play( "fly" )
	vel.y = -FLYVEL
	vel.x = dir * 30
	position += delta * vel
	
	$rotate.scale.x = sign( vel.x )
	


func _on_bird_body_entered(body):
	dir = sign( global_position.x - body.global_position.x )
	var x = randf()
	if x > 0.5:
		dir = 1
	else:
		dir = -1
	state_nxt = STATES.FLY


func _on_VisibilityNotifier2D_screen_exited():
	if state_cur == STATES.FLY:
		queue_free()
