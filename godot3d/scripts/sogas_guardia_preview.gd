extends Node3D

func _ready() -> void:
	var camera := get_node_or_null("Camera3D") as Camera3D
	if camera != null:
		camera.look_at(Vector3(0.0, 0.86, 0.0), Vector3.UP)
