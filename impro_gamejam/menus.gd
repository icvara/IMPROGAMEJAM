extends Control
@onready var level1 = preload("res://World/level1.tscn")
@onready var mainmenu = preload("res://Menus.tscn")

func _on_start_button_down() -> void:
	get_tree().change_scene_to_packed(level1)


func _on_quit_button_down() -> void:
	get_tree().quit()
	
