extends TextureRect

@export var item_id: String = ""

func _gui_input(_event: InputEvent) -> void:
	pass # drag handled by _get_drag_data

func _get_drag_data(_position: Vector2):
	if texture:
		var data := {
			"type": "item",
			"item_id": item_id,
			"texture": texture
		}
		set_drag_preview(_make_drag_preview())
		return data
	return null

func _make_drag_preview() -> Control:
	var preview := TextureRect.new()
	preview.texture = texture
	preview.modulate = Color(1, 1, 1, 0.8)
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.custom_minimum_size = size
	return preview





