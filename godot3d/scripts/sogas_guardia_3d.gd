@tool
extends Node3D

## Decorative braided rope loops fitted in the local dimensions of character-knight.glb.
## Instance this node under the existing knight model; it contains rope geometry only.

const ROPE_COLORS := [Color("f5c342"), Color("d99a20"), Color("ffda67")]
const LOOP_SPECS := [
	{"name": "Tobillos", "y": 0.055, "radius_x": 0.185, "radius_z": 0.145},
	{"name": "Torso", "y": 0.285, "radius_x": 0.315, "radius_z": 0.168},
]
const LOOP_SEGMENTS := 96
const TUBE_SIDES := 6
const TWIST_TURNS := 8
const STRAND_OFFSET := 0.012
const TUBE_RADIUS := 0.009

func _ready() -> void:
	_build_rope_only()

func _build_rope_only() -> void:
	for child in get_children():
		if child.name.begins_with("Rope_"):
			remove_child(child)
			child.free()
	for spec in LOOP_SPECS:
		_add_braided_loop(spec)
	_add_hanging_lead()

func _add_braided_loop(spec: Dictionary) -> void:
	var loop_name := String(spec.name)
	for strand_index in range(3):
		var strand := MeshInstance3D.new()
		strand.name = "Rope_%s_Strand_%d" % [loop_name, strand_index + 1]
		strand.mesh = _make_strand_mesh(float(spec.y), float(spec.radius_x), float(spec.radius_z), strand_index)
		var material := StandardMaterial3D.new()
		material.albedo_color = ROPE_COLORS[strand_index]
		material.roughness = 0.88
		material.cull_mode = BaseMaterial3D.CULL_DISABLED
		strand.material_override = material
		add_child(strand)
		if Engine.is_editor_hint():
			strand.owner = get_tree().edited_scene_root
	_add_knot(loop_name, float(spec.y), float(spec.radius_z))

func _make_strand_mesh(center_y: float, radius_x: float, radius_z: float, strand_index: int) -> ArrayMesh:
	var surface := SurfaceTool.new()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)
	var phase_offset := TAU * float(strand_index) / 3.0
	for segment in range(LOOP_SEGMENTS):
		var a0 := TAU * float(segment) / float(LOOP_SEGMENTS)
		var a1 := TAU * float(segment + 1) / float(LOOP_SEGMENTS)
		for side in range(TUBE_SIDES):
			var b0 := TAU * float(side) / float(TUBE_SIDES)
			var b1 := TAU * float(side + 1) / float(TUBE_SIDES)
			var p00 := _tube_point(a0, b0, center_y, radius_x, radius_z, phase_offset)
			var p10 := _tube_point(a1, b0, center_y, radius_x, radius_z, phase_offset)
			var p11 := _tube_point(a1, b1, center_y, radius_x, radius_z, phase_offset)
			var p01 := _tube_point(a0, b1, center_y, radius_x, radius_z, phase_offset)
			surface.add_vertex(p00)
			surface.add_vertex(p10)
			surface.add_vertex(p11)
			surface.add_vertex(p00)
			surface.add_vertex(p11)
			surface.add_vertex(p01)
	surface.generate_normals()
	return surface.commit()

func _tube_point(angle: float, side_angle: float, center_y: float, radius_x: float, radius_z: float, phase_offset: float) -> Vector3:
	var radial := Vector3(cos(angle), 0.0, sin(angle))
	var base := Vector3(radius_x * cos(angle), center_y, radius_z * sin(angle))
	var twist_phase := angle * float(TWIST_TURNS) + phase_offset
	var strand_center := base + radial * STRAND_OFFSET * cos(twist_phase) + Vector3.UP * STRAND_OFFSET * sin(twist_phase)
	var tangent := Vector3(-radius_x * sin(angle), 0.0, radius_z * cos(angle)).normalized()
	var axis_radial := tangent.cross(Vector3.UP).normalized()
	var axis_up := tangent.cross(axis_radial).normalized()
	return strand_center + (axis_radial * cos(side_angle) + axis_up * sin(side_angle)) * TUBE_RADIUS

func _add_knot(loop_name: String, center_y: float, radius_z: float) -> void:
	var knot := MeshInstance3D.new()
	knot.name = "Rope_%s_Knot" % loop_name
	var knot_mesh := SphereMesh.new()
	knot_mesh.radius = 0.021
	knot_mesh.height = 0.042
	knot_mesh.radial_segments = 8
	knot_mesh.rings = 4
	knot.mesh = knot_mesh
	knot.position = Vector3(0.015, center_y, -radius_z - 0.014)
	var knot_material := StandardMaterial3D.new()
	knot_material.albedo_color = ROPE_COLORS[1]
	knot_material.roughness = 0.88
	knot.material_override = knot_material
	add_child(knot)
	if Engine.is_editor_hint():
		knot.owner = get_tree().edited_scene_root

func _add_hanging_lead() -> void:
	var lead := MeshInstance3D.new()
	lead.name = "Rope_Ankle_Lead"
	var lead_mesh := CylinderMesh.new()
	lead_mesh.top_radius = 0.016
	lead_mesh.bottom_radius = 0.016
	lead_mesh.height = 1.0
	lead_mesh.radial_segments = 8
	lead.mesh = lead_mesh
	# The preview flips the knight upside down, so negative local Y makes the rope rise from the ankle binding.
	lead.position = Vector3(0.0, -0.445, 0.0)
	var lead_material := StandardMaterial3D.new()
	lead_material.albedo_color = ROPE_COLORS[0]
	lead_material.roughness = 0.88
	lead.material_override = lead_material
	add_child(lead)
	if Engine.is_editor_hint():
		lead.owner = get_tree().edited_scene_root
