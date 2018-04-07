extends CanvasLayer

func _ready():
	# pause the game
	get_tree().paused = true


func _on_menu_selected_item( pos ):
	if pos == 0:
		# continue game
		get_tree().paused = false
	elif pos == 1:
		# quit to main menu
		get_tree().paused = false
		game.main._load_scene("res://intro_screen.tscn" )
	queue_free()
