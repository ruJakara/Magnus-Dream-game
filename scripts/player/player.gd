extends CharacterBody2D

@export var move_speed: float = 200.0

var skill_manager: SkillManager

@onready var hp_bar: ProgressBar = $HUD/Margin/VBox/Health/Bar
@onready var hunger_bar: ProgressBar = $HUD/Margin/VBox/Hunger/Bar
@onready var stamina_bar: ProgressBar = $HUD/Margin/VBox/Stamina/Bar
@onready var mana_bar: ProgressBar = $HUD/Margin/VBox/Mana/Bar

func _get_input_direction() -> Vector2:
	var input_vector := Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return input_vector.normalized()

func _physics_process(delta: float) -> void:
	var direction := _get_input_direction()
	velocity = direction * move_speed
	move_and_slide()

func _ready() -> void:
    skill_manager = SkillManager.new()
    add_child(skill_manager)
    skill_manager.skill_changed.connect(_on_skill_changed)
    skill_manager.load_from_json()
    _initialize_hud_from_skills()

func _initialize_hud_from_skills() -> void:
    _sync_bar("health", hp_bar)
    _sync_bar("hunger", hunger_bar)
    _sync_bar("stamina", stamina_bar)
    _sync_bar("mana", mana_bar)

func _sync_bar(id: StringName, bar: ProgressBar) -> void:
    if bar == null or skill_manager == null or not skill_manager.has_skill(id):
        return
    bar.max_value = skill_manager.get_max(id)
    bar.value = skill_manager.get_value(id)

func _on_skill_changed(id: StringName, value: float, max_value: float) -> void:
    match String(id):
        "health":
            if hp_bar:
                hp_bar.max_value = max_value
                hp_bar.value = value
        "hunger":
            if hunger_bar:
                hunger_bar.max_value = max_value
                hunger_bar.value = value
        "stamina":
            if stamina_bar:
                stamina_bar.max_value = max_value
                stamina_bar.value = value
        "mana":
            if mana_bar:
                mana_bar.max_value = max_value
                mana_bar.value = value

