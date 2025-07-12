extends StaticBody2D



func action(player):
	player.get_node("Debugmsg").text = "Dead. R to restart"


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		action(body)
