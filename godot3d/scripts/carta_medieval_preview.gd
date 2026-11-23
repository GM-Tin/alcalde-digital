extends Node3D

const CURRENT_LETTER := preload("res://scenes/props/sobre_medieval_3d.tscn")

var parchment: StandardMaterial3D
var fold_material: StandardMaterial3D
var gold: StandardMaterial3D
var blue: StandardMaterial3D
var wax: StandardMaterial3D
var dark_leather: StandardMaterial3D

func _ready() -> void:
	_make_materials()
	_make_stage()
	_make_camera()
	_make_lighting()
	_make_current_letter()
	_make_redesigned_letter()
	_make_labels()

func _make_materials() -> void:
	parchment = _material(Color("f4dfae"), 0.86)
	fold_material = _material(Color("e8cd94"), 0.9)
	gold = _material(Color("e9a92c"), 0.3, 0.72)
	blue = _material(Color("174ca9"), 0.48, 0.12)
	wax = _material(Color("a71925"), 0.32, 0.08)
	dark_leather = _material(Color("39221a"), 0.72)

func _material(color: Color, roughness: float, metallic: float = 0.0) -> StandardMaterial3D:
	var result := StandardMaterial3D.new()
	result.albedo_color = color
	result.roughness = roughness
	result.metallic = metallic
	result.cull_mode = BaseMaterial3D.CULL_DISABLED
	return result

func _make_stage() -> void:
	var environment_node := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("26344e")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("b8c9ea")
	environment.ambient_light_energy = 0.72
	environment_node.environment = environment
	add_child(environment_node)
	var floor := MeshInstance3D.new()
	floor.name = "PreviewFloor"
	var floor_mesh := BoxMesh.new()
	floor_mesh.size = Vector3(16, 0.18, 8)
	floor.mesh = floor_mesh
	floor.position = Vector3(0, -0.95, 0)
	floor.material_override = _material(Color("414b61"), 0.82)
	add_child(floor)

func _make_camera() -> void:
	var camera := Camera3D.new()
	camera.name = "PreviewCamera"
	camera.position = Vector3(0, 2.1, 8.5)
	camera.fov = 43.0
	add_child(camera)
	camera.look_at(Vector3(0, 0.48, 0), Vector3.UP)
	camera.make_current()

func _make_lighting() -> void:
	var key := DirectionalLight3D.new()
	key.rotation_degrees = Vector3(-37, -28, 0)
	key.light_color = Color("ffe2ad")
	key.light_energy = 1.45
	key.shadow_enabled = true
	add_child(key)
	var fill := OmniLight3D.new()
	fill.position = Vector3(2.5, 2.4, 3.0)
	fill.light_color = Color("a8c5ff")
	fill.light_energy = 0.62
	fill.omni_range = 9.0
	add_child(fill)

func _make_current_letter() -> void:
	var current := CURRENT_LETTER.instantiate() as Node3D
	current.name = "Carta_actual_sin_cambios"
	current.position = Vector3(-1.9, 0.15, 0)
	current.rotation.y = 0.0
	current.scale = Vector3.ONE * 1.55
	add_child(current)

func _make_redesigned_letter() -> void:
	var letter := Node3D.new()
	letter.name = "Propuesta_carta_medieval_3D"
	letter.position = Vector3(1.75, 0.12, 0)
	letter.rotation.y = 0.0
	add_child(letter)
	# Thick dark edge and warm parchment face establish a clear, readable silhouette.
	_add_box(letter, "Canto_de_cuero", Vector3(2.34, 1.52, 0.20), Vector3(0, 0, 0), dark_leather)
	_add_box(letter, "Cuerpo_de_pergamino", Vector3(2.22, 1.40, 0.18), Vector3(0, 0, 0.045), parchment)
	_add_box(letter, "Cinta_azul", Vector3(0.26, 1.30, 0.07), Vector3(0, 0, 0.14), blue)
	_add_box(letter, "Cinta_punta_izquierda", Vector3(0.26, 0.32, 0.075), Vector3(-0.075, -0.69, 0.15), blue, -0.45)
	_add_box(letter, "Cinta_punta_derecha", Vector3(0.26, 0.32, 0.075), Vector3(0.075, -0.69, 0.15), blue, 0.45)
	# Raised gold frame pieces, with separate corner caps for a hand-crafted finish.
	_add_box(letter, "Marco_superior", Vector3(2.24, 0.065, 0.08), Vector3(0, 0.70, 0.15), gold)
	_add_box(letter, "Marco_inferior", Vector3(2.24, 0.065, 0.08), Vector3(0, -0.70, 0.15), gold)
	_add_box(letter, "Marco_izquierdo", Vector3(0.065, 1.34, 0.08), Vector3(-1.09, 0, 0.15), gold)
	_add_box(letter, "Marco_derecho", Vector3(0.065, 1.34, 0.08), Vector3(1.09, 0, 0.15), gold)
	for x_sign in [-1.0, 1.0]:
		for y_sign in [-1.0, 1.0]:
			_add_box(letter, "Refuerzo_esquina", Vector3(0.19, 0.19, 0.095), Vector3(x_sign * 1.04, y_sign * 0.65, 0.18), gold, 0.18 * x_sign * y_sign)
	# Folded paper flaps are actual extruded 3D geometry rather than a printed image.
	_add_fold(letter, "Pliegue_izquierdo", [Vector2(-1.04, 0.62), Vector2(-1.04, -0.64), Vector2(0, -0.04)], 0.155, fold_material)
	_add_fold(letter, "Pliegue_derecho", [Vector2(1.04, 0.62), Vector2(1.04, -0.64), Vector2(0, -0.04)], 0.158, fold_material)
	_add_fold(letter, "Solapa_superior", [Vector2(-1.02, 0.62), Vector2(1.02, 0.62), Vector2(0, -0.10)], 0.167, parchment)
	_add_box(letter, "Costura_diagonal_izquierda", Vector3(1.16, 0.025, 0.035), Vector3(-0.51, 0.30, 0.215), gold, -0.58)
	_add_box(letter, "Costura_diagonal_derecha", Vector3(1.16, 0.025, 0.035), Vector3(0.51, 0.30, 0.215), gold, 0.58)
	# Wax medallion with raised royal mark.
	_add_cylinder(letter, "Borde_sello_dorado", 0.30, 0.105, Vector3(0, -0.03, 0.26), gold)
	_add_cylinder(letter, "Sello_de_cera", 0.245, 0.13, Vector3(0, -0.03, 0.32), wax)
	_add_box(letter, "Fleur_real_vertical", Vector3(0.075, 0.25, 0.045), Vector3(0, -0.025, 0.405), gold, 0.0)
	_add_box(letter, "Fleur_real_rombo", Vector3(0.19, 0.19, 0.05), Vector3(0, 0.02, 0.43), gold, PI * 0.25)
	_add_box(letter, "Fleur_real_base", Vector3(0.24, 0.06, 0.05), Vector3(0, -0.12, 0.43), gold)

func _add_box(parent: Node3D, node_name: String, size: Vector3, at: Vector3, material: Material, angle: float = 0.0) -> void:
	var mesh_node := MeshInstance3D.new()
	mesh_node.name = node_name
	var box := BoxMesh.new()
	box.size = size
	mesh_node.mesh = box
	mesh_node.material_override = material
	mesh_node.position = at
	mesh_node.rotation.z = angle
	parent.add_child(mesh_node)

func _add_fold(parent: Node3D, node_name: String, points: Array[Vector2], at_z: float, material: Material) -> void:
	var fold := CSGPolygon3D.new()
	fold.name = node_name
	fold.polygon = PackedVector2Array(points)
	fold.depth = 0.018
	fold.position.z = at_z
	fold.material = material
	parent.add_child(fold)

func _add_cylinder(parent: Node3D, node_name: String, radius: float, depth: float, at: Vector3, material: Material) -> void:
	var mesh_node := MeshInstance3D.new()
	mesh_node.name = node_name
	var cylinder := CylinderMesh.new()
	cylinder.top_radius = radius
	cylinder.bottom_radius = radius
	cylinder.height = depth
	cylinder.radial_segments = 32
	mesh_node.mesh = cylinder
	mesh_node.material_override = material
	mesh_node.position = at
	mesh_node.rotation.x = PI * 0.5
	parent.add_child(mesh_node)

func _make_labels() -> void:
	_add_label("ACTUAL", Vector3(-1.9, -0.79, 0.10), Color("f0dfb0"))
	_add_label("PROPUESTA 3D", Vector3(1.75, -0.79, 0.10), Color("ffe09a"))

func _add_label(text_value: String, at: Vector3, color: Color) -> void:
	var label := Label3D.new()
	label.text = text_value
	label.position = at
	label.font_size = 48
	label.pixel_size = 0.0045
	label.modulate = color
	label.outline_size = 8
	label.outline_modulate = Color("21170f")
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)
