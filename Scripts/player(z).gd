extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

const SPEED = 300.0
const JUMP_VELOCITY = -600.0
var alive = true
var can_move = true


func _physics_process(delta: float) -> void:
	if not alive:
		return
		
	#ADD ANIMATION
	
	if velocity.x > 1 or velocity.x < -1:
		animated_sprite_2d.play("Run")
	else:
		animated_sprite_2d.play("Idle")


	if not is_on_floor():
		velocity += get_gravity() * delta
		animated_sprite_2d.play("Jump")

	if can_move:
	# Handle jump
	
		if Input.is_action_just_pressed("JUMP") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			$JumpSound.play()

		# Get the input direction and handle the movement/deceleration.
		var direction := Input.get_axis("LEFT", "RIGHT")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		
		if velocity.x > 0:
			animated_sprite_2d.flip_h = false
		elif velocity.x < 0:
			animated_sprite_2d.flip_h = true

func die() -> void: 
	if alive == false:
		return

	alive = false
	print("died")
	animated_sprite_2d.play("Die")
