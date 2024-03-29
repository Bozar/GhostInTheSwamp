extends Node2D
# class_name EndGame
# =====Autoload=====


const PATH_TO_ROOT := "res://scene/main/RootScene.tscn"


func quit() -> void:
	StateManager.remove_all()
	get_tree().quit()


func reload() -> void:
	var new_scene: Node2D = load(PATH_TO_ROOT).instance()
	var old_scene: Node2D = get_tree().current_scene

	StateManager.remove_all()
	FindObject.remove_pc()

	get_tree().root.add_child(new_scene)
	get_tree().current_scene = new_scene

	get_tree().root.remove_child(old_scene)
	old_scene.queue_free()
