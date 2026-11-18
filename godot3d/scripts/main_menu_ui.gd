@tool
extends Control

signal play_requested
signal tutorial_requested
signal settings_requested

@onready var play_button: TextureButton = $HomeScreen/HomePanel/MenuContent/PlayButton
@onready var tutorial_button: TextureButton = $HomeScreen/HomePanel/MenuContent/TutorialButton
@onready var settings_button: TextureButton = $HomeScreen/HomePanel/MenuContent/SettingsButton

func _ready() -> void:
	_setup_button(play_button, 0)
	_setup_button(tutorial_button, 1)
	_setup_button(settings_button, 2)
	if Engine.is_editor_hint():
		return
	play_button.pressed.connect(func(): play_requested.emit())
	tutorial_button.pressed.connect(func(): tutorial_requested.emit())
	settings_button.pressed.connect(func(): settings_requested.emit())

func _setup_button(button: TextureButton, atlas_index: int) -> void:
	button.focus_mode = Control.FOCUS_ALL
	button.mouse_filter = Control.MOUSE_FILTER_IGNORE if Engine.is_editor_hint() else Control.MOUSE_FILTER_STOP
	button.pivot_offset = button.custom_minimum_size / 2.0
	_add_raised_lettering(button)
	if not Engine.is_editor_hint():
		button.mouse_entered.connect(func(): _animate_button(button, Color(1.1, 1.06, 0.94), Vector2(1.025, 1.025)))
		button.mouse_exited.connect(func(): _animate_button(button, Color.WHITE, Vector2.ONE))
		button.resized.connect(func(): button.pivot_offset = button.size / 2.0)
		button.gui_input.connect(func(event: InputEvent):
			if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
				_animate_button(button, Color(0.9, 0.82, 0.66) if event.pressed else Color(1.1, 1.06, 0.94), Vector2(0.97, 0.97) if event.pressed else Vector2.ONE)
		)


func _add_raised_lettering(button: TextureButton) -> void:
	var face := button.get_node_or_null("Text") as Label
	if face == null or button.has_node("RaisedGold"):
		return
	face.z_index = 2
	var gold := face.duplicate() as Label
	gold.name = "RaisedGold"
	gold.z_index = 1
	gold.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gold.offset_top += 4.0
	gold.offset_bottom += 4.0
	gold.add_theme_color_override("font_color", Color("d47819"))
	gold.add_theme_color_override("font_outline_color", Color("71320e"))
	gold.add_theme_constant_override("outline_size", 5)
	button.add_child(gold)
	var shadow := face.duplicate() as Label
	shadow.name = "RaisedShadow"
	shadow.z_index = 0
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shadow.offset_top += 8.0
	shadow.offset_bottom += 8.0
	shadow.add_theme_color_override("font_color", Color("54200c"))
	shadow.add_theme_color_override("font_outline_color", Color("54200c"))
	shadow.add_theme_constant_override("outline_size", 6)
	button.add_child(shadow)


func _animate_button(button: TextureButton, tint: Color, target_scale: Vector2) -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(button, "modulate", tint, 0.12)
	tween.parallel().tween_property(button, "scale", target_scale, 0.12)
