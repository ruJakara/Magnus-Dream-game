extends Panel

signal slot_changed

@onready var icon: TextureRect = $Icon
var item_id: String = ""

func can_drop_data(at_position: Vector2, data) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.get("type", "") == "item"

func drop_data(at_position: Vector2, data) -> void:
	item_id = String(data.get("item_id", ""))
	var tex: Texture2D = data.get("texture")
	icon.texture = tex
	emit_signal("slot_changed")

func clear_slot() -> void:
	item_id = ""
	icon.texture = null
	emit_signal("slot_changed")


