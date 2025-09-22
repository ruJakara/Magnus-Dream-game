extends StaticBody2D

var player_in_range: bool = false

func _ready() -> void:
	# Connect interaction area signals
	var area = $InteractionArea
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_in_range:
		toggle_cooking_ui()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		$InteractionLabel.visible = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		$InteractionLabel.visible = false

func toggle_cooking_ui() -> void:
	$CookingUI.visible = !$CookingUI.visible

