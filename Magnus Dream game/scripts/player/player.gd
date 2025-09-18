extends CharacterBody2D

@export var move_speed: float = 200.0

@export var max_health: float = 100.0
@export var max_hunger: float = 100.0
@export var max_stamina: float = 100.0
@export var max_mana: float = 100.0

var health: float
var hunger: float
var stamina: float
var mana: float

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
	health = max_health
	hunger = max_hunger
	stamina = max_stamina
	mana = max_mana
	_update_hud()

func _update_hud() -> void:
	if hp_bar:
		hp_bar.max_value = max_health
		hp_bar.value = health
	if hunger_bar:
		hunger_bar.max_value = max_hunger
		hunger_bar.value = hunger
	if stamina_bar:
		stamina_bar.max_value = max_stamina
		stamina_bar.value = stamina
	if mana_bar:
		mana_bar.max_value = max_mana
		mana_bar.value = mana

