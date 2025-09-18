extends TextureRect

@export var item_id: String = ""

func get_drag_data(at_position: Vector2):
	if texture == null:
		return null
	var data := {
		"type": "item",
		"item_id": item_id,
		"texture": texture
	}
	var preview := TextureRect.new()
	preview.texture = texture
	preview.modulate = Color(1, 1, 1, 0.85)
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	set_drag_preview(preview)
	return data


