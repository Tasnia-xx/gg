extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

signal player_died

const Speed = 100
var Direction = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += Direction * Speed * delta


func _on_timer_timeout() -> void:
	Direction *= -1
	animated_sprite_2d.flip_h = !animated_sprite_2d.flip_h

func _on_body_entered(body: Node2D) -> void:
	if body.name == "PLAYER" and body.alive:
		emit_signal("player_died")
