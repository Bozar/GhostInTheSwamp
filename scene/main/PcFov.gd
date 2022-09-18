extends Node2D


func render() -> void:
	pass


func end_game(win: bool) -> void:
	if not win:
		Palette.set_dark_color(FindObject.pc, MainTag.ACTOR)
