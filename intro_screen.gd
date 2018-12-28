extends Node2D

func _ready():
	game.main.play_music( "res://intro.ogg" )
	if game.gamestate["level"].empty():
		$menu_layer/menu.unselectable_items.append( 1 )

func _physics_process(_delta):
	if Input.is_key_pressed( KEY_ESCAPE ):
		get_tree().quit()

func _on_menu_selected_item( pos ):
	if pos == 0:
		game.main._start_game()
	elif pos == 1:
		game.main._finished_level( game.gamestate["level"] )
	elif pos == 2:
		get_tree().quit()
