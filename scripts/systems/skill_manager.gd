extends Node

class_name SkillManager

signal skill_changed(id: StringName, value: float, max_value: float)

var _skill_definitions: Dictionary = {}
var _skill_values: Dictionary = {}

const DEFAULT_JSON_PATH := "res://data/skills/skills.json"

func load_from_json(json_path: String = DEFAULT_JSON_PATH) -> void:
	var file := FileAccess.open(json_path, FileAccess.READ)
	if file == null:
		push_error("SkillManager: Cannot open skills JSON at %s" % json_path)
		return
	var text := file.get_as_text()
	file.close()
	var parser := JSON.new()
	var parse_result := parser.parse(text)
	if parse_result != OK:
		push_error("SkillManager: JSON parse error at line %s: %s" % [parser.get_error_line(), parser.get_error_message()])
		return
	var data = parser.data
	if typeof(data) != TYPE_DICTIONARY or not data.has("skills"):
		push_error("SkillManager: JSON must contain a 'skills' array")
		return
	for skill_dict in data.skills:
		if typeof(skill_dict) != TYPE_DICTIONARY:
			continue
		if not skill_dict.has("id"):
			continue
		var id: StringName = StringName(skill_dict.id)
		_skill_definitions[id] = skill_dict
		var initial_value := float(skill_dict.get("initial", 0.0))
		var max_value := float(skill_dict.get("max", 0.0))
		_skill_values[id] = clamp(initial_value, 0.0, max_value)
		emit_signal("skill_changed", id, _skill_values[id], max_value)

func get_ids() -> Array:
	return _skill_definitions.keys()

func get_value(id: StringName) -> float:
	return float(_skill_values.get(id, 0.0))

func get_max(id: StringName) -> float:
	var def := _skill_definitions.get(id, null)
	if def == null:
		return 0.0
	return float(def.get("max", 0.0))

func set_value(id: StringName, value: float, emit: bool = true) -> void:
	if not _skill_definitions.has(id):
		push_warning("SkillManager: Trying to set unknown skill '%s'" % String(id))
		return
	var max_value := get_max(id)
	var clamped := clamp(value, 0.0, max_value)
	_skill_values[id] = clamped
	if emit:
		emit_signal("skill_changed", id, clamped, max_value)

func change_by(id: StringName, delta: float) -> void:
	set_value(id, get_value(id) + delta)

func has_skill(id: StringName) -> bool:
	return _skill_definitions.has(id)

func get_definition(id: StringName) -> Dictionary:
	return _skill_definitions.get(id, {})


