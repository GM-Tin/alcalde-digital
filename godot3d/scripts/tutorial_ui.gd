@tool
extends Control

signal back_requested

@onready var editor_preview: Control = $EditorPreview
@onready var back_button: TextureButton = $Content/BackButton

func _ready() -> void:
	if is_instance_valid(editor_preview):
		editor_preview.visible = Engine.is_editor_hint()
	if Engine.is_editor_hint():
		return
	back_button.mouse_filter = Control.MOUSE_FILTER_STOP
	back_button.pivot_offset = back_button.custom_minimum_size / 2.0
	back_button.pressed.connect(func(): back_requested.emit())
	back_button.mouse_entered.connect(func(): _animate_back_button(Color(1.1, 1.06, 0.94), Vector2(1.025, 1.025)))
	back_button.mouse_exited.connect(func(): _animate_back_button(Color.WHITE, Vector2.ONE))
	back_button.gui_input.connect(_on_back_button_input)

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
