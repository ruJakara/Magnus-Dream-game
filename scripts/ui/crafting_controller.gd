extends Node

@export var slot_paths: Array[NodePath] = []
@export var result_label_path: NodePath

var slots: Array = []
var result_label: Label

func _ready() -> void:
	for p in slot_paths:
		var s: Panel = get_node(p)
		s.connect("slot_changed", Callable(self, "_on_slot_changed"))
		slots.append(s)
	result_label = get_node(result_label_path)
	_update_result()

func _on_slot_changed() -> void:
	_update_result()

func _update_result() -> void:
	var key: Array = []
	for s in slots:
		key.append(s.item_id)
	var recipe_str: String = ", ".join(key)
	if result_label:
		result_label.text = "Результат: %s" % (recipe_str if recipe_str.strip_edges() != ", , " else "—")


