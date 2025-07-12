extends Node2D
@onready var mainmenu = preload("res://Menus.tscn")


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("test2d")
	$Label.show()
	$"return to menu".show()
	#get_tree().paused = true


func _on_return_to_menu_button_down() -> void:
	get_tree().change_scene_to_packed(mainmenu)
