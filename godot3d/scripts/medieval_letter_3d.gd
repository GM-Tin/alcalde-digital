@tool
extends StaticBody3D

const MODEL_SCALE := 0.30

func _ready() -> void:
	if get_node_or_null("ModelGeometry") != null:
		return
	_build_model()

func _build_model() -> void:
	var geometry := Node3D.new()
	geometry.name = "ModelGeometry"
	geometry.scale = Vector3.ONE * MODEL_SCALE
	add_child(geometry)
	var parchment := _material(Color("f4dfae"), 0.86)
	var fold_material := _material(Color("e8cd94"), 0.9)
	var gold := _material(Color("e9a92c"), 0.3, 0.72)
	var blue := _material(Color("174ca9"), 0.48, 0.12)
	var wax := _material(Color("a71925"), 0.32, 0.08)
	var dark_leather := _material(Color("39221a"), 0.72)
	_add_box(geometry, "Canto_de_cuero", Vector3(2.34, 1.52, 0.20), Vector3.ZERO, dark_leather)
	_add_box(geometry, "Cuerpo_de_pergamino", Vector3(2.22, 1.40, 0.18), Vector3(0, 0, 0.045), parchment)
	_add_box(geometry, "Cinta_azul", Vector3(0.26, 1.30, 0.07), Vector3(0, 0, 0.14), blue)
	_add_box(geometry, "Cinta_punta_izquierda", Vector3(0.26, 0.32, 0.075), Vector3(-0.075, -0.69, 0.15), blue, -0.45)
	_add_box(geometry, "Cinta_punta_derecha", Vector3(0.26, 0.32, 0.075), Vector3(0.075, -0.69, 0.15), blue, 0.45)
	_add_box(geometry, "Marco_superior", Vector3(2.24, 0.065, 0.08), Vector3(0, 0.70, 0.15), gold)
	_add_box(geometry, "Marco_inferior", Vector3(2.24, 0.065, 0.08), Vector3(0, -0.70, 0.15), gold)
	_add_box(geometry, "Marco_izquierdo", Vector3(0.065, 1.34, 0.08), Vector3(-1.09, 0, 0.15), gold)
	_add_box(geometry, "Marco_derecho", Vector3(0.065, 1.34, 0.08), Vector3(1.09, 0, 0.15), gold)
	for x_sign in [-1.0, 1.0]:
		for y_sign in [-1.0, 1.0]:
			_add_box(geometry, "Refuerzo_esquina", Vector3(0.19, 0.19, 0.095), Vector3(x_sign * 1.04, y_sign * 0.65, 0.18), gold, 0.18 * x_sign * y_sign)
	_add_fold(geometry, "Pliegue_izquierdo", [Vector2(-1.04, 0.62), Vector2(-1.04, -0.64), Vector2(0, -0.04)], 0.155, fold_material)
	_add_fold(geometry, "Pliegue_derecho", [Vector2(1.04, 0.62), Vector2(1.04, -0.64), Vector2(0, -0.04)], 0.158, fold_material)
	_add_fold(geometry, "Solapa_superior", [Vector2(-1.02, 0.62), Vector2(1.02, 0.62), Vector2(0, -0.10)], 0.167, parchment)
	_add_box(geometry, "Costura_diagonal_izquierda", Vector3(1.16, 0.025, 0.035), Vector3(-0.51, 0.30, 0.215), gold, -0.58)
	_add_box(geometry, "Costura_diagonal_derecha", Vector3(1.16, 0.025, 0.035), Vector3(0.51, 0.30, 0.215), gold, 0.58)
	_add_cylinder(geometry, "Borde_sello_dorado", 0.30, 0.105, Vector3(0, -0.03, 0.26), gold)
	_add_cylinder(geometry, "Sello_de_cera", 0.245, 0.13, Vector3(0, -0.03, 0.32), wax)
	_add_box(geometry, "Fleur_real_vertical", Vector3(0.075, 0.25, 0.045), Vector3(0, -0.025, 0.405), gold)
	_add_box(geometry, "Fleur_real_rombo", Vector3(0.19, 0.19, 0.05), Vector3(0, 0.02, 0.43), gold, PI * 0.25)
	_add_box(geometry, "Fleur_real_base", Vector3(0.24, 0.06, 0.05), Vector3(0, -0.12, 0.43), gold)
	var collision := CollisionShape3D.new()
	collision.name = "Colision_carta"
	var shape := BoxShape3D.new()
	shape.size = Vector3(2.34, 1.52, 0.24) * MODEL_SCALE
	collision.shape = shape
	add_child(collision)

func _material(color: Color, roughness: float, metallic: float = 0.0) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	return material

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
