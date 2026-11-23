@tool
extends StaticBody3D

const PAGE_THRESHOLDS: Array[int] = [4, 7, 10]

var pages_placed := 0

func _ready() -> void:
	_hide_old_notice_papers()
	_ensure_progressive_pages()
	_apply_page_visibility()

func set_pages_placed(count: int) -> void:
	pages_placed = clampi(count, 0, PAGE_THRESHOLDS.size())
	_hide_old_notice_papers()
	_ensure_progressive_pages()
	_apply_page_visibility()

func _hide_old_notice_papers() -> void:
	for child in get_children():
		var node_name := String(child.name).to_lower()
		if node_name.begins_with("pergamino_aviso_") or node_name.begins_with("sello_azul_") or node_name.begins_with("sello_rojo_") or node_name.begins_with("escritura_aviso_"):
			child.visible = false

func _ensure_progressive_pages() -> void:
	var centers: Array[Vector3] = [Vector3(-0.53, 1.9, 0.052), Vector3(0.05, 1.91, 0.052), Vector3(0.55, 1.88, 0.052)]
	var sizes: Array[Vector2] = [Vector2(0.53, 0.77), Vector2(0.48, 0.86), Vector2(0.48, 0.7)]
	var tilts: Array[float] = [-0.07, 0.025, 0.08]
	var seal_colors: Array[Color] = [Color("315caa"), Color("ad4d37"), Color("bf9147")]
	for index in range(centers.size()):
		var page_name := "Pagina_entregada_%d" % (index + 1)
		if get_node_or_null(NodePath(page_name)) != null:
			continue
		var page := Node3D.new()
		page.name = page_name
		page.position = centers[index]
		page.rotation.z = tilts[index]
		page.visible = false
		add_child(page)
		_set_editor_owner(page)

		var sheet := CSGBox3D.new()
		sheet.name = "Hoja"
		sheet.size = Vector3(sizes[index].x, sizes[index].y, 0.035)
		sheet.material = _paper_material()
		page.add_child(sheet)
		_set_editor_owner(sheet)

		var wax := CSGBox3D.new()
		wax.name = "Sello"
		wax.position = Vector3(0, sizes[index].y * 0.32, 0.026)
		wax.size = Vector3(0.13, 0.1, 0.02)
		wax.material = _flat_material(seal_colors[index])
		page.add_child(wax)
		_set_editor_owner(wax)

		for line_index in range(3):
			var line := CSGBox3D.new()
			line.name = "Linea_%d" % (line_index + 1)
			line.position = Vector3(0, 0.02 - float(line_index) * 0.13, 0.027)
			line.size = Vector3(sizes[index].x * [0.58, 0.67, 0.52][line_index], 0.018, 0.008)
			line.material = _flat_material(Color("60462b"))
			page.add_child(line)
			_set_editor_owner(line)

func _apply_page_visibility() -> void:
	for index in range(PAGE_THRESHOLDS.size()):
		var page := get_node_or_null(NodePath("Pagina_entregada_%d" % (index + 1))) as Node3D
		if page != null:
			page.visible = index < pages_placed

func _set_editor_owner(node: Node) -> void:
	if not Engine.is_editor_hint():
		return
	var scene_root := get_tree().edited_scene_root
	if scene_root == null:
		return
	node.owner = scene_root
	for child in node.get_children():
		_set_editor_owner(child)

func _paper_material() -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("fff0cd")
	material.roughness = 0.96
	return material

func _flat_material(tint: Color) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.roughness = 0.9
	return material
