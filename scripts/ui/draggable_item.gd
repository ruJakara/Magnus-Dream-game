extends TextureRect

@export var item_id: String = ""

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if texture:
			set_drag_preview(_make_drag_preview())
			var data := {
				"type": "item",
				"item_id": item_id,
				"texture": texture
			}
			do_drag(data, self)

func _make_drag_preview() -> Control:
	var preview := TextureRect.new()
	preview.texture = texture
	preview.modulate = Color(1, 1, 1, 0.8)
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.custom_minimum_size = size
	return preview





