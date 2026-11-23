@tool
extends Control

signal back_requested

@onready var editor_preview: Control = $EditorPreview
@onready var back_button: TextureButton = $Content/BackButton
@onready var tutorial_art: TextureRect = $Content/TutorialArt
var interaction_key_cap: PanelContainer

func _ready() -> void:
	if is_instance_valid(editor_preview):
		editor_preview.visible = Engine.is_editor_hint()
	if Engine.is_editor_hint():
		return
	_add_interaction_key_cap()
	back_button.mouse_filter = Control.MOUSE_FILTER_STOP
	back_button.pivot_offset = back_button.custom_minimum_size / 2.0
	back_button.pressed.connect(func(): back_requested.emit())
	back_button.mouse_entered.connect(func(): _animate_back_button(Color(1.1, 1.06, 0.94), Vector2(1.025, 1.025)))
	back_button.mouse_exited.connect(func(): _animate_back_button(Color.WHITE, Vector2.ONE))
	back_button.gui_input.connect(_on_back_button_input)

func _add_interaction_key_cap() -> void:
	interaction_key_cap = PanelContainer.new()
	interaction_key_cap.name = "InteractionKeyE"
	interaction_key_cap.mouse_filter = Control.MOUSE_FILTER_IGNORE
	interaction_key_cap.custom_minimum_size = Vector2(82, 74)
	var plaque := StyleBoxFlat.new()
	plaque.bg_color = Color("fff7e9")
	plaque.border_color = Color("54331f")
	plaque.set_border_width_all(4)
	plaque.set_corner_radius_all(16)
	plaque.shadow_color = Color(0.16, 0.08, 0.03, 0.55)
	plaque.shadow_size = 5
	plaque.shadow_offset = Vector2(0, 3)
	interaction_key_cap.add_theme_stylebox_override("panel", plaque)
	var key_label := Label.new()
	key_label.text = "E"
	key_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	key_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	key_label.add_theme_font_override("font", preload("res://assets/ui/fonts/LilitaOne-Regular.ttf"))
	key_label.add_theme_font_size_override("font_size", 42)
	key_label.add_theme_color_override("font_color", Color("39251c"))
	key_label.add_theme_color_override("font_outline_color", Color("21150f"))
	key_label.add_theme_constant_override("outline_size", 3)
	interaction_key_cap.add_child(key_label)
	tutorial_art.add_child(interaction_key_cap)
	tutorial_art.resized.connect(_layout_interaction_key_cap)
	_layout_interaction_key_cap()

func _layout_interaction_key_cap() -> void:
	if not is_instance_valid(interaction_key_cap) or not is_instance_valid(tutorial_art):
		return
	# Emphasize the printed E interaction key while retaining its frame.
	interaction_key_cap.position = Vector2(tutorial_art.size.x * 0.696 - 41.0, tutorial_art.size.y * 0.307 - 37.0)

func _on_back_button_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var tint := Color(0.9, 0.82, 0.66) if event.pressed else Color(1.1, 1.06, 0.94)
		var scale := Vector2(0.97, 0.97) if event.pressed else Vector2(1.025, 1.025)
		_animate_back_button(tint, scale)

func _animate_back_button(tint: Color, target_scale: Vector2) -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(back_button, "modulate", tint, 0.12)
	tween.parallel().tween_property(back_button, "scale", target_scale, 0.12)
