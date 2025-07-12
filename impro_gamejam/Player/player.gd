extends CharacterBody2D

	

@export var speed = 400
@export var jump_speed = 500
@export var GRAVITY = 9.8 * 100
@export var platform: PackedScene
@export var oreille: PackedScene
@export var plume: PackedScene

var oreille_platform = -1
var alive = true
var part = []
var invuframe = false

var max_jump = 1
var n_jump = 0

var input_direction
var last_dir = 1

func _input(event):
	if event.is_action_pressed("restart"):
		alive =true
		get_tree().reload_current_scene()
	if event.is_action_pressed("absorb"):
		action()
		
func _physics_process(delta: float) -> void:
	if alive:
		input_direction = Input.get_axis("left", "right")
		if Input.is_action_pressed("left"):
			$AnimatedSprite2D.flip_h = true
			last_dir = -1
		elif Input.is_action_pressed("right"):
			$AnimatedSprite2D.flip_h = false
			last_dir = 1
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


func get_hurt():
	if invuframe == false:
		if part.size()> 0:
			var lost_part
			var random_id = randi_range(0,part.size()-1)
			var select_part = part[random_id]
			
			if part.size() == 2:
				part.erase(select_part)
				if select_part == "oreille":
					oreille_platform = -1
					lost_part = oreille.instantiate()
					
				elif select_part == "plume":
					max_jump = 1
					lost_part = plume.instantiate()

				$AnimatedSprite2D.play(part[0])
			else:
				part.erase(select_part)
				if select_part == "oreille":
					oreille_platform = -1
					lost_part = oreille.instantiate()
					$AnimatedSprite2D.play("default")
				elif select_part == "plume":
					max_jump = 1
					$AnimatedSprite2D.play("default")
					lost_part = plume.instantiate()
			get_parent().add_child(lost_part)
			lost_part.global_position = position -Vector2(0,100)
			lost_part.apply_force(Vector2(-last_dir*20000,-1*2000),position)
			print(lost_part.global_position)
		
		
			invuframe = true 
			modulate = Color(1,0,0)
			await get_tree().create_timer(.5).timeout
			invuframe = false 
			modulate = Color(1,1,1)



		else:
			get_node("Debugmsg").text = "Dead. R to restart"
			alive = false


func action():
	if part.has("oreille"):
		print(oreille_platform)
		if oreille_platform == 1 :
			oreille_platform = 0
			var plt = platform.instantiate()
			get_parent().add_child(plt)
			plt.global_position = get_global_mouse_position()
			await get_tree().create_timer(3.0).timeout
			print("timer waited")
			oreille_platform =1
				
	
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
			oreille_platform = 1

	if part.has("oreille") and part.has("plume"):
		$AnimatedSprite2D.play("oreille_plume")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("blop"):
		if invuframe == false:
			power_up(body)
			body.queue_free()
