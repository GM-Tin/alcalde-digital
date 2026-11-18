@tool
extends Control

signal back_requested
signal volume_changed(value: float)
signal lights_toggled(enabled: bool)
signal scale_selected(index: int)

@onready var editor_preview: Control = $EditorPreview
@onready var volume_slider: HSlider = $Content/VolumeSlider
@onready var lights_toggle: CheckButton = $Content/LightsToggle
@onready var scale_picker: OptionButton = $Content/ScalePicker
@onready var back_button: TextureButton = $Content/BackButton

func _ready() -> void:
	editor_preview.visible = Engine.is_editor_hint()
	if scale_picker.item_count == 0:
		scale_picker.add_item("Pequeña · 85%", 0)
		scale_picker.add_item("Normal · 100%", 1)
		scale_picker.add_item("Grande · 115%", 2)
	_apply_cartoon_style()
	if Engine.is_editor_hint():
		return
	back_button.mouse_filter = Control.MOUSE_FILTER_STOP
	back_button.pivot_offset = back_button.custom_minimum_size / 2.0
	back_button.pressed.connect(func(): back_requested.emit())
	volume_slider.value_changed.connect(_on_volume_slider_changed)
	lights_toggle.toggled.connect(func(enabled: bool): lights_toggled.emit(enabled))
	scale_picker.item_selected.connect(func(index: int): scale_selected.emit(index))
	back_button.mouse_entered.connect(func(): _animate_back_button(Color(1.1, 1.06, 0.94), Vector2(1.025, 1.025)))
	back_button.mouse_exited.connect(func(): _animate_back_button(Color.WHITE, Vector2.ONE))
	back_button.gui_input.connect(_on_back_button_input)

func set_values(volume: float, lights_enabled: bool, scale_index: int) -> void:
	volume_slider.set_value_no_signal(clampf(volume, 0.0, 1.0))
	_update_volume_label(volume_slider.value)
	lights_toggle.set_pressed_no_signal(lights_enabled)
	scale_picker.select(clampi(scale_index, 0, 2))

func _apply_cartoon_style() -> void:
	var font := load("res://assets/ui/fonts/LilitaOne-Regular.ttf") as FontFile
	for label_path in ["Content/TitleShadow", "Content/TitleGoldDepth", "Content/Title", "Content/VolumeLabel", "Content/LightsLabel", "Content/ScaleLabel"]:
		var label := get_node(label_path) as Label
		if font != null:
			label.add_theme_font_override("font", font)
		if label_path.begins_with("Content/Title"):
			label.add_theme_font_size_override("font_size", 46)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		else:
			label.add_theme_font_size_override("font_size", 22)
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var description := $Content/LightsDescription as Label
	if font != null:
		description.add_theme_font_override("font", font)
	description.add_theme_color_override("font_color", Color("d8cfbd"))
	description.add_theme_font_size_override("font_size", 17)
	var card := $Content/OptionsCard as Panel
	var card_style := StyleBoxFlat.new()
	card_style.bg_color = Color(0.075, 0.085, 0.12, 0.94)
	card_style.border_color = Color("d4a84f")
	card_style.set_border_width_all(2)
	card_style.set_corner_radius_all(18)
	card_style.shadow_color = Color(0.015, 0.02, 0.035, 0.55)
	card_style.shadow_size = 12
	card_style.shadow_offset = Vector2(0, 5)
	card.add_theme_stylebox_override("panel", card_style)
	var label_specs := [
		["Content/TitleShadow", Color("3f1607"), 5],
		["Content/TitleGoldDepth", Color("d46412"), 4],
		["Content/Title", Color("fff0bd"), 3],
	]
	for spec in label_specs:
		var label := get_node(spec[0]) as Label
		label.add_theme_color_override("font_color", spec[1])
		label.add_theme_color_override("font_outline_color", Color("39200c"))
		label.add_theme_constant_override("outline_size", spec[2])
	if font != null:
		lights_toggle.add_theme_font_override("font", font)
		volume_label_font(font)
		var back_text := $Content/BackButton/Text as Label
		back_text.add_theme_font_override("font", font)
	_style_controls()

func _add_raised_label(face: Label) -> void:
	var gold := face.duplicate() as Label
	gold.name = face.name + "GoldDepth"
	gold.z_index = 1
	gold.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gold.position.y += 3.0
	gold.add_theme_color_override("font_color", Color("d47819"))
	gold.add_theme_color_override("font_outline_color", Color("71320e"))
	gold.add_theme_constant_override("outline_size", 5)
	face.add_sibling(gold)
	face.z_index = 2
	var shadow := face.duplicate() as Label
	shadow.name = face.name + "ShadowDepth"
	shadow.z_index = 0
	shadow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	shadow.position.y += 6.0
	shadow.add_theme_color_override("font_color", Color("54200c"))
	shadow.add_theme_color_override("font_outline_color", Color("54200c"))
	shadow.add_theme_constant_override("outline_size", 6)
	face.add_sibling(shadow)
	face.move_to_front()

func _style_controls() -> void:
	var font := load("res://assets/ui/fonts/LilitaOne-Regular.ttf") as FontFile
	if font != null:
		volume_slider.add_theme_font_override("font", font)
		lights_toggle.add_theme_font_override("font", font)
		lights_toggle.add_theme_font_size_override("font_size", 22)
	var track := StyleBoxFlat.new()
	track.bg_color = Color("58351e")
	track.border_color = Color("efb943")
	track.set_border_width_all(3)
	track.set_corner_radius_all(8)
	volume_slider.add_theme_stylebox_override("slider", track)
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("f8c94b")
	fill.set_corner_radius_all(8)
	volume_slider.add_theme_stylebox_override("grabber_area", fill)
	volume_slider.add_theme_stylebox_override("grabber_area_highlight", fill)
	var knob := StyleBoxFlat.new()
	knob.bg_color = Color("fff0ad")
	knob.border_color = Color("a85b15")
	knob.set_border_width_all(3)
	knob.set_corner_radius_all(12)
	volume_slider.add_theme_stylebox_override("grabber", knob)
	volume_slider.add_theme_stylebox_override("grabber_highlight", knob)
	var toggle_off := StyleBoxFlat.new()
	toggle_off.bg_color = Color("58351e")
	toggle_off.border_color = Color("edb440")
	toggle_off.set_border_width_all(3)
	toggle_off.set_corner_radius_all(16)
	var toggle_on := toggle_off.duplicate() as StyleBoxFlat
	toggle_on.bg_color = Color("26775d")
	var toggle_hover := toggle_off.duplicate() as StyleBoxFlat
	toggle_hover.border_color = Color("fff0ad")
	for state in ["normal", "pressed"]:
		lights_toggle.add_theme_stylebox_override(state, toggle_on if state == "pressed" else toggle_off)
	lights_toggle.add_theme_stylebox_override("hover", toggle_hover)
	lights_toggle.add_theme_stylebox_override("hover_pressed", toggle_on)
	lights_toggle.add_theme_color_override("font_color", Color("fff0bd"))
	var option := scale_picker
	option.add_theme_font_size_override("font_size", 23)
	option.add_theme_color_override("font_color", Color("fff0bd"))
	option.add_theme_color_override("font_hover_color", Color("fff7d7"))
	var option_plate := StyleBoxFlat.new()
	option_plate.bg_color = Color("59351f")
	option_plate.border_color = Color("e9ae40")
	option_plate.set_border_width_all(3)
	option_plate.set_corner_radius_all(12)
	option_plate.content_margin_left = 18
	option_plate.content_margin_right = 22
	option.add_theme_stylebox_override("normal", option_plate)
	var option_hover := option_plate.duplicate() as StyleBoxFlat
	option_hover.bg_color = Color("704627")
	option_hover.border_color = Color("ffe087")
	option.add_theme_stylebox_override("hover", option_hover)
	option.add_theme_stylebox_override("pressed", option_plate)
	option.add_theme_stylebox_override("focus", option_hover)

func _on_volume_slider_changed(value: float) -> void:
	_update_volume_label(value)
	volume_changed.emit(value)

func _update_volume_label(value: float) -> void:
	var label := $Content/VolumeLabel as Label
	label.text = "Volumen general · %d%%" % roundi(value * 100.0)

func volume_label_font(font: FontFile) -> void:
	var label := $Content/VolumeLabel as Label
	label.add_theme_font_override("font", font)
	label.add_theme_font_size_override("font_size", 22)
	label.add_theme_color_override("font_color", Color("f4d88f"))
	lights_toggle.add_theme_font_size_override("font_size", 20)
	lights_toggle.add_theme_color_override("font_color", Color("fff0bd"))
	var scale_label := $Content/ScaleLabel as Label
	scale_label.add_theme_font_override("font", font)
	scale_label.add_theme_font_size_override("font_size", 22)
	scale_label.add_theme_color_override("font_color", Color("f4d88f"))
	var lights_label := $Content/LightsLabel as Label
	lights_label.add_theme_font_override("font", font)
	lights_label.add_theme_font_size_override("font_size", 22)
	lights_label.add_theme_color_override("font_color", Color("f4d88f"))

func _on_back_button_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var tint := Color(0.9, 0.82, 0.66) if event.pressed else Color(1.1, 1.06, 0.94)
		var target_scale := Vector2(0.97, 0.97) if event.pressed else Vector2(1.025, 1.025)
		_animate_back_button(tint, target_scale)

func _animate_back_button(tint: Color, target_scale: Vector2) -> void:
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(back_button, "modulate", tint, 0.12)
	tween.parallel().tween_property(back_button, "scale", target_scale, 0.12)
