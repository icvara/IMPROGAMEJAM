extends CharacterBody2D

	

@export var speed = 400
@export var jump_speed = 500
@export var GRAVITY = 9.8 * 100




func _physics_process(delta: float) -> void:
	var input_direction = Input.get_axis("left", "right")
	velocity.x = input_direction * speed
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_just_pressed("jump"):
		print("jump")
		velocity.y = -jump_speed
	
	
	move_and_slide()
