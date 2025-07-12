extends CharacterBody2D


func _ready() -> void:
	$AnimationPlayer.play("new_animation")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.get_hurt()
