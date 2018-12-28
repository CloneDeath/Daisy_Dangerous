extends KinematicBody2D

export var dir_nxt = -1
var anim_cur = ""
var anim_nxt = "idle"
var restart_anim = false
var energy = 10
const JUMP_VEL = 400
const HVEL = 180

var bullet_scn = preload( "res://boss_bullet.tscn" )
var bullet_blast_scn = preload( "res://boss_bullet_blast.tscn" )

enum STATES { TIME, \
		WAIT_FOR_PLAYER, \
		FIRE, \
		JUMP, \
		FACE_OTHER_SIDE }

var state_cur = STATES.WAIT_FOR_PLAYER
var state_nxt = 0
var state_timer = 0

func _physics_process(delta):
	if boss_dead: return
	if hit_state_cur == HIT_STATES.NONE:
		if state_cur == STATES.TIME:
			state_timer -= delta
			if state_timer <= 0:
				state_cur = state_nxt
		elif state_cur == STATES.WAIT_FOR_PLAYER:
			# todo: check if player has arrived
			if player_arrived():
				# face player
				if game.player != null:
					var auxdir = sign( game.player.global_position.x - global_position.x )
				# wait a bit for next state
				state_timer = 1
				fire_state_cur = FIRE_STATES.RAISE_TURRET
				state_nxt = STATES.FIRE
				state_cur = STATES.TIME
		elif state_cur == STATES.FIRE:
			# todo: shoot at player
			if fire( delta ):
				# finished firing
				state_timer = 1
				state_cur = STATES.TIME
				vel = Vector2( $rotate.scale.x * HVEL, -JUMP_VEL * 60 * delta )
				finished_jump = false
				state_nxt = STATES.JUMP
		elif state_cur == STATES.FACE_OTHER_SIDE:
			dir_nxt = -dir_nxt
			state_timer = 1
			state_cur = STATES.TIME
		elif state_cur == STATES.JUMP:
			if jump( delta ):
				# finished jumping
				state_timer = 1
				state_cur = STATES.FACE_OTHER_SIDE
				fire_state_cur = FIRE_STATES.RAISE_TURRET
				state_nxt = STATES.FIRE
	hit_fsm( delta )

	# animation
	if anim_cur != anim_nxt or restart_anim:
		anim_cur = anim_nxt
		$anim.play( anim_cur )
		restart_anim = false

	# direction
	if $rotate.scale.x != dir_nxt:
		$rotate.scale.x = dir_nxt



func player_arrived():
	return _player_arrived

enum FIRE_STATES { \
		TIME, \
		RAISE_TURRET, \
		FIRE, \
		LOWER_TURRET, \
		FINISH }
var fire_state_cur = FIRE_STATES.RAISE_TURRET
var fire_state_nxt = 0
var fire_timer = 0
var bullet_count = 0
var bullet_angles = [ \
		[ 0, 0.1, 0.2, 0.3, 0.4, 0.3, 0.2, 0.1, 0, -0.1, -0.2, -0.3, -0.4, -0.3, 0.2 ] ]
func fire( delta ):
	if fire_state_cur == FIRE_STATES.TIME:
		fire_timer -= delta
		if fire_timer <= 0:
			fire_state_cur = fire_state_nxt
	elif fire_state_cur == FIRE_STATES.RAISE_TURRET:
		anim_nxt = "prepare fire"
		$damagebox/damageshape.disabled = false
		fire_timer = 0.3
		fire_state_nxt = FIRE_STATES.FIRE
		fire_state_cur = FIRE_STATES.TIME
		bullet_count = 15
	elif fire_state_cur == FIRE_STATES.FIRE:
		var b = bullet_scn.instance()
		b.vel = Vector2( $rotate.scale.x, 0 ).rotated( bullet_angles[0][15-bullet_count] )
		b.position = $rotate/fire_pos.global_position
		get_parent().add_child( b )
		var bb = bullet_blast_scn.instance()
		bb.position = $rotate/fire_pos.position
		$rotate.add_child( bb )
		anim_nxt = "fire"
		#play sound
		$sfx.mplay( preload( "res://boss_bullet.wav" ) )

		restart_anim = true
		bullet_count -= 1
		if bullet_count > 0:
			fire_timer = 0.25
			fire_state_nxt = FIRE_STATES.FIRE
			fire_state_cur = FIRE_STATES.TIME
		else:
			fire_timer = 1
			fire_state_nxt = FIRE_STATES.LOWER_TURRET
			fire_state_cur = FIRE_STATES.TIME
	elif fire_state_cur == FIRE_STATES.LOWER_TURRET:
		anim_nxt = "low turret"
		fire_timer = 1
		fire_state_nxt = FIRE_STATES.FINISH
		fire_state_cur = FIRE_STATES.TIME
	elif fire_state_cur == FIRE_STATES.FINISH:
		$damagebox/damageshape.disabled = true
		anim_nxt = "idle"
		return true
	return false



var vel = Vector2()
var finished_jump = false
var started_jump = true
func jump( delta ):
	if started_jump:
		# jump sound
		$sfx.mplay( preload( "res://boss_jump.wav" ) )
		started_jump = false
	if not finished_jump:
		anim_nxt = "jump"
		vel = move_and_slide( vel )
		vel.y += 800 * delta # GRAVITY
		if vel.y > 200: vel.y = 200
		var coldata = null
		if get_slide_count() > 0:
			coldata = get_slide_collision( 0 )
		if coldata != null:
			anim_nxt = "land"
			finished_jump = true
			# play sound
			$sfx.mplay( preload( "res://bullet_hit_wall.wav" ) )
			# shake screen
			game.camera.shake( 0.5, 30, 4 )
	else:
		if not $anim.is_playing():
			anim_nxt = "idle"
			started_jump = true
			return true
	return false


func _on_hitbox_area_entered(area):
	if area.is_in_group( "damagebox" ):
		game.player.destroy( position )

var boss_dead = false
func destroy( pos ):
	if boss_dead: return
	if hit_state_cur == HIT_STATES.NONE:
		energy -= 1
		if energy > 0:
			hit_state_cur = HIT_STATES.THROWBACK
		else:
			hit_state_cur = HIT_STATES.THROWBACK
			boss_dead = true
			_on_death_timer_timeout()
			$death_timer.start()

var death_explosion_count = 20
signal start_final_cutscene
func _on_death_timer_timeout():
	death_explosion_count -= 1
	if death_explosion_count == 0:
		$death_timer.stop()
		if game.player != null:
			emit_signal( "start_final_cutscene" )
			queue_free()
	else:
		var x = preload( "res://bomb_explosion.tscn" ).instance()
		x.kill_player = false
		x.position = position+Vector2( rand_range( -20, 20 ), rand_range( -40, 0 ) )
		get_parent().add_child( x )

enum HIT_STATES { NONE, TIME, THROWBACK, LOW_TURRENT, FINISH }
var hit_state_cur = HIT_STATES.NONE
var hit_state_nxt = HIT_STATES.NONE
var hit_timer = 0
func hit_fsm( delta ):
	if hit_state_cur == HIT_STATES.NONE:
		return
	elif hit_state_cur == HIT_STATES.TIME:
		hit_timer -= delta
		if hit_timer <= 0:
			hit_state_cur = hit_state_nxt
	elif hit_state_cur == HIT_STATES.THROWBACK:
		anim_nxt = "hit"
		hit_timer = 0.5
		hit_state_cur = HIT_STATES.TIME
		hit_state_nxt = HIT_STATES.LOW_TURRENT
	elif hit_state_cur == HIT_STATES.LOW_TURRENT:
		anim_nxt = "low turret"
		hit_timer = 0.5
		hit_state_cur = HIT_STATES.TIME
		hit_state_nxt = HIT_STATES.FINISH
	elif hit_state_cur == HIT_STATES.FINISH:
		anim_nxt = "idle"
		hit_state_cur = HIT_STATES.NONE
		# prepare return to normal fsm
		if not boss_dead:
			state_timer = 1
			state_cur = STATES.TIME
			vel = Vector2( $rotate.scale.x * HVEL, -JUMP_VEL * 60 * delta )
			finished_jump = false
			state_nxt = STATES.JUMP
		else:
			state_cur = -1 # TODO TO END STATE!

var _player_arrived = false
func _on_cutscene_01_activate_boss():
	_player_arrived = true

signal text_finished
func text( msg, duration = 2 ):
	if game.main == null: return
	game.main.connect( "text_finished", self, "_on_text_finished" )
	game.main.set_character_text( self, msg, duration, Vector2( 0, -64 ) )
func _on_text_finished():
	game.main.disconnect( "text_finished", self, "_on_text_finished" )
	emit_signal( "text_finished" )
