extends Node

class_name SkillSystem

signal skill_changed(id: StringName, value: float, max_value: float)

@export var manager: SkillManager

func _ready() -> void:
	if manager == null:
		manager = SkillManager.new()
	# Forward manager's signal
	manager.skill_changed.connect(func(id: StringName, value: float, max_value: float) -> void:
		emit_signal("skill_changed", id, value, max_value)
	)

func load_from_json(path: String) -> void:
	if manager == null:
		manager = SkillManager.new()
	manager.load_from_json(path)

func has_skill(id: StringName) -> bool:
	return manager != null and manager.has_skill(id)

func get_value(id: StringName) -> float:
	return 0.0 if manager == null else manager.get_value(id)

func get_max(id: StringName) -> float:
	return 0.0 if manager == null else manager.get_max(id)

func set_value(id: StringName, value: float) -> void:
	if manager == null:
		return
	manager.set_value(id, value)

func change_by(id: StringName, delta: float) -> void:
	if manager == null:
		return
	manager.set_value(id, manager.get_value(id) + delta)


