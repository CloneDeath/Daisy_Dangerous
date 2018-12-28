extends KinematicBody2D

const GRAVITY = 800
const TERMINAL_VEL = 200
const MAX_VEL = 50

enum STATES { IDLE, RUN, DEAD, NONE }

var state_cur = -1
var state_nxt = STATES.NONE
var dir_cur = 1
export var dir_nxt = 1
var anim_cur = "idle"
var anim_nxt = "idle"
var vel = Vector2()

func _ready():
	$anim.seek( rand_range( 0, 0.2 ) )

func _physics_process( delta ):
	vel.y += GRAVITY * delta
	if vel.y > TERMINAL_VEL: vel.y = TERMINAL_VEL

	vel = move_and_slide( vel )

	state_cur = state_nxt
	if state_cur == STATES.IDLE:
		_state_idle( delta )
	elif state_cur == STATES.RUN:
		_state_run( delta )
	elif state_cur == STATES.DEAD:
		_state_dead( delta )

	if anim_nxt != anim_cur:
		anim_cur = anim_nxt
		$anim.play( anim_cur )
		if anim_cur == "idle":
			$anim.seek( rand_range( 0, 0.2 ) )
	if dir_nxt != dir_cur:
		dir_cur = dir_nxt
		$rotate.scale.x = dir_cur

func _player_visible():
	if game.player == null: return null
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray( global_position + Vector2( 0, -8 ), game.player.global_position + Vector2( 0, -8 ), \
		[ self, $rotate/hitbox, $damagebox ], 2 )
	if result.empty() or ( not result.empty() and result.collider.is_in_group( "check_fire" ) ):
		return game.player.global_position - global_position
	return null

func _state_idle( delta ):
	if _is_dead: return
	anim_nxt = "idle"
	vel.x = lerp( vel.x, 0, 15 * delta )
	# check if the player is visible
	var player_dir = _player_visible()
	if player_dir != null:
		state_nxt = STATES.RUN

func _state_run( delta ):
	if _is_dead: return
	dir_nxt = sign( game.player.global_position.x - global_position.x )
	vel.x = lerp( vel.x, dir_nxt * MAX_VEL, 5 * delta )
	anim_nxt = "run"

var _dead_timer = 3

func _state_dead( _delta ):
	anim_nxt = "dead"
	if ( global_position.y - game.camera.global_position.y > 200 ) or _dead_timer <= 0:
		queue_free()

func on_obstacle():
	var coldata = null
	if get_slide_count() > 0:
		coldata = get_slide_collision( 0 )
	if coldata != null:
		return true
	return false

var _is_dead = false
func destroy( _pos = null ):
	_is_dead = true
	state_nxt = STATES.DEAD
	vel = Vector2( -100, -200 ) * 60 * get_physics_process_delta_time()
	# disable everything
	$rotate/hitbox.queue_free()
	$collision.queue_free()
	$damagebox.queue_free()
	$AudioStreamPlayer.play()

func _on_hitbox_area_entered( area ):
	if area.is_in_group( "damagebox" ):
		game.player.destroy( position )

var _visible = false
func _on_VisibilityNotifier2D_screen_entered():
	if _visible: return
	_visible = true
	state_nxt = STATES.IDLE