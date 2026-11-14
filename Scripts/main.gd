extends Node2D
@onready var fade = $CanvasLayer/Fade
	
var level: int = 1
var current_level_root: Node = null
var player: Node = null

func _ready() -> void:
# setup level
	fade.modulate.a = 1.0
	current_level_root = get_node_or_null("LevelRoot")
	_load_level(level)

# level management
func _load_level(level_number: int) -> void:
	if current_level_root:
		current_level_root.queue_free()

# change level
	var level_path = "res://Lvls/level%s.tscn" % level_number
	current_level_root = load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)

func _setup_level(level_root: Node) -> void:
	player = level_root.get_node_or_null("PLAYER(z)")
	_fade(0.0)

# 1. Connect the exit properly here inside _setup_level
	var exit = level_root.get_node_or_null("Exit")	
	if exit:
		if not exit.body_entered.is_connected(_on_exit_body_entered):
			exit.body_entered.connect(_on_exit_body_entered)

# 2. Skulls setup
	var skulls = level_root.get_node_or_null("Skulls")
			

# 3. Enemies setup
	var enemies = level_root.get_node_or_null("Enemies")
	if enemies:
			for enemy in enemies.get_children():
				if not enemy.player_died.is_connected(_on_player_died):
					enemy.player_died.connect(_on_player_died)

# This function sits safely OUTSIDE of _setup_level
func _on_exit_body_entered(body: Node2D) -> void:
	if body == player:
		level += 1 # Increases your level counter (1 -> 2 -> 3)
	body.can_move = false # Stops the player during transition
	call_deferred ("_load_level", level) # Safely loads the next level

func _on_player_died() -> void:
# FIXED: Uses the 'player' variable already found in _setup_level
	if player and not player.alive:
		return
	if player:
		player.die()
	print("Player Killed")

# scores


# fade
func _fade(to_alpha: float) -> void:
	var tween := create_tween()
	tween.tween_property(fade, "modulate:a", to_alpha, 1.5)
	await tween.finished
