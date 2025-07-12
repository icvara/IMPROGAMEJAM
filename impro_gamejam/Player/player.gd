extends CharacterBody2D

	

@export var speed = 400
@export var jump_speed = 500
@export var GRAVITY = 9.8 * 100
@export var platform: PackedScene
var oreille_platform = -1
var alive = true
var part = []

var max_jump = 1
var n_jump = 0

func _input(event):
	if event.is_action_pressed("restart"):
		alive =true
		get_tree().reload_current_scene()
	if event.is_action_pressed("absorb"):
		action()
		
func _physics_process(delta: float) -> void:
	if alive:
		var input_direction = Input.get_axis("left", "right")
		if Input.is_action_pressed("left"):
			$AnimatedSprite2D.flip_h = true
		elif Input.is_action_pressed("right"):
			$AnimatedSprite2D.flip_h = false
		velocity.x = input_direction * speed
		if not is_on_floor() :
			velocity.y += GRAVITY * delta
		else:
			n_jump = 0
		
		if Input.is_action_just_pressed("jump") and n_jump < max_jump:
			$Sound/Bloop.play()
			velocity.y = -jump_speed
			n_jump += 1
		
		
	move_and_slide() 


func action():
	if part.has("oreille"):
		print(oreille_platform)
		if oreille_platform == 1 :
			oreille_platform = 0
			var plt = platform.instantiate()
			get_parent().add_child(plt)
			plt.global_position = get_global_mouse_position()
			await get_tree().create_timer(300000.0).timeout
			print("timer waited")
			oreille_platform =1
				
		else :
			await get_tree().create_timer(3.0)
			print("connard")
			oreille_platform =1
			pass
	pass

func power_up(blop):
	if blop.object_id == "plume":
		$AnimatedSprite2D.play("plume")
		if part.has("plume") == false:
			part.append("plume")
			max_jump = 2
	elif blop.object_id == "oreille":
		$AnimatedSprite2D.play("oreille")
		if part.has("oreille") == false:
			part.append("oreille")

	if part.has("oreille") and part.has("plume"):
		$AnimatedSprite2D.play("oreille_plume")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("blop"):
		power_up(body)
		body.queue_free()
