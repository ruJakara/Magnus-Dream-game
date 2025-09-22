extends Resource

class_name SkillManager

signal skill_changed(id: StringName, value: float, max_value: float)

@export var skills: Dictionary = {}

var _names: Dictionary = {}

func load_from_json(path: String = "res://data/skills.json") -> void:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("SkillManager: Cannot open JSON %s" % path)
		return
	var text: String = file.get_as_text()
	file.close()
	var parser: JSON = JSON.new()
	var ok: int = parser.parse(text)
	if ok != OK:
		push_error("SkillManager: JSON parse error at line %s: %s" % [parser.get_error_line(), parser.get_error_message()])
		return
	var data: Dictionary = parser.data
	if typeof(data) != TYPE_DICTIONARY:
		push_error("SkillManager: root must be a dictionary of id -> object")
		return
	skills.clear()
	_names.clear()
	for id in data.keys():
		var entry: Dictionary = data[id]
		if typeof(entry) != TYPE_DICTIONARY:
			continue
		var start_val: float = float(entry.get("start", 0.0))
		var max_val: float = float(entry.get("max", 0.0))
		skills[id] = {"value": clamp(start_val, 0.0, max_val), "max": max_val}
		if entry.has("name"):
			_names[id] = String(entry.name)
		emit_signal("skill_changed", StringName(id), float(skills[id].get("value", 0.0)), float(skills[id].get("max", 0.0)))

func to_json_string(pretty: bool = true) -> String:
	var out: Dictionary = {}
	for id in skills.keys():
		var v: Dictionary = skills[id]
		var obj: Dictionary = {"start": float(v.get("value", 0.0)), "max": float(v.get("max", 0.0))}
		if _names.has(id):
			obj["name"] = _names[id]
		out[id] = obj
	return JSON.stringify(out, "\t" if pretty else "")

func save_to_json(path: String, pretty: bool = true) -> void:
	var text: String = to_json_string(pretty)
	var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		push_error("SkillManager: Cannot write JSON %s" % path)
		return
	file.store_string(text)
	file.close()

func has_skill(id: StringName) -> bool:
	return skills.has(String(id))

func get_value(id: StringName) -> float:
	var rec: Dictionary = skills.get(String(id), {})
	return float(rec.get("value", 0.0))

func get_max(id: StringName) -> float:
	var rec: Dictionary = skills.get(String(id), {})
	return float(rec.get("max", 0.0))

func set_value(id: StringName, value: float) -> void:
	var key: String = String(id)
	if not skills.has(key):
		push_warning("SkillManager: Unknown skill '%s'" % key)
		return
	var rec: Dictionary = skills[key]
	var clamped: float = clamp(value, 0.0, float(rec.get("max", 0.0)))
	rec["value"] = clamped
	skills[key] = rec
	emit_signal("skill_changed", id, clamped, float(rec.get("max", 0.0)))


