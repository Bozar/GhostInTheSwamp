class_name InitWorldData


const PATH_TO_HELP := "res://user/doc/"
const HINT_PREFIX := "hint_"
const HINT_PLACEHOLDER := "[INPUT_HINT]\n"

const HELP_FILES := [
	"cheat_sheet.md",
	"introduction.md",
	"key_bindings.md",
	"game_world.md",
	"player_character_1.md",
	"player_character_2.md",
	"player_character_3.md",
	"non_player_characters.md",
	"game_settings.md",
]


static func get_help() -> Array:
	var parse_help := []
	var parse_hint := []
	var help_text: String
	var hint_text: String
	var result := []

	for i in HELP_FILES:
		help_text = PATH_TO_HELP + i
		hint_text = PATH_TO_HELP + HINT_PREFIX + i
		parse_help.push_back(FileIoHelper.read_as_text(help_text))
		parse_hint.push_back(FileIoHelper.read_as_text(hint_text))

	for i in parse_help.size():
		if parse_help[i].parse_success and parse_hint[i].parse_success:
			hint_text = parse_hint[i].output_text
			help_text = parse_help[i].output_text
			help_text = help_text.replace(HINT_PLACEHOLDER, hint_text)
			result.push_back(help_text)
		else:
			result.push_back("")
	return result
