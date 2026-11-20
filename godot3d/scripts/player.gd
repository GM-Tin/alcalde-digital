extends CharacterBody3D

@export var speed := 6.0
@export var jump_velocity := 6.2
@export var mouse_sensitivity := 0.0025
@export var max_air_jumps := 1
var gravity := 18.0
var air_jumps_left := 1
var anim: AnimationPlayer
var last_animation := ""
var last_safe_position := Vector3(2, 0.1, 0)
var look_pivot: Node3D
var look_pitch := 0.0
var space_was_pressed := false
var controls_enabled := true
var fall_respawn_requested := false

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	anim = find_animation_player(self)
	if anim:
		play_animation("idle")

func _notification(what: int) -> void:
	if what == NOTIFICATION_APPLICATION_FOCUS_IN and controls_enabled:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if global_position.y > -1.5:
		fall_respawn_requested = false
	var input := Input.get_vector("move_left", "move_right", "move_up", "move_down") if controls_enabled else Vector2.ZERO
	# Read physical WASD directly as a fallback, so movement still works if an
	# imported keyboard device ID differs from the one stored in InputMap.
	var keyboard_input := Vector2(
		int(Input.is_physical_key_pressed(KEY_D)) - int(Input.is_physical_key_pressed(KEY_A)),
		int(Input.is_physical_key_pressed(KEY_S)) - int(Input.is_physical_key_pressed(KEY_W))
	)
	if controls_enabled and keyboard_input != Vector2.ZERO:
		input = keyboard_input.normalized()
	var direction := transform.basis * Vector3(input.x, 0.0, input.y)
	direction.y = 0.0
	if direction.length() > 1.0:
		direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	if is_on_floor():
		air_jumps_left = max_air_jumps
	if not is_on_floor():
		velocity.y -= gravity * delta
	var space_down := Input.is_physical_key_pressed(KEY_SPACE)
	var jump_pressed := Input.is_action_just_pressed("jump") or (space_down and not space_was_pressed)
	space_was_pressed = space_down
	if controls_enabled and jump_pressed and (is_on_floor() or air_jumps_left > 0):
		velocity.y = jump_velocity
		if not is_on_floor():
			air_jumps_left -= 1
	move_and_slide()
	if is_on_floor() and global_position.y > -0.1:
		last_safe_position = global_position
	elif global_position.y < -1.5 and not fall_respawn_requested:
		fall_respawn_requested = true
		velocity = Vector3.ZERO
		var world := get_parent()
		if world != null and world.has_method("_begin_water_respawn"):
			world.call_deferred("_begin_water_respawn")
		else:
			global_position = last_safe_position + Vector3(0, 0.08, 0)
		return
	if anim:
		if not is_on_floor():
			play_animation("jump")
		elif direction.length() > 0.08:
			play_animation("walk")
		else:
			play_animation("idle")

func _input(event: InputEvent) -> void:
	# Menus own mouse and keyboard input until a mode explicitly launches play.
	# In particular, clicking Play must never recapture the cursor as gameplay.
	if not controls_enabled:
		return
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		look_pitch = clamp(look_pitch - event.relative.y * mouse_sensitivity, deg_to_rad(-78.0), deg_to_rad(78.0))
		if look_pivot:
			look_pivot.rotation.x = look_pitch
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		# Let visible gameplay UI controls receive clicks instead of recapturing the pointer.
		if get_viewport().gui_get_hovered_control() != null:
			return
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED else Input.MOUSE_MODE_CAPTURED
		get_viewport().set_input_as_handled()

func set_look_pivot(pivot: Node3D) -> void:
	look_pivot = pivot

func find_animation_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node
	for child in node.get_children():
		var found := find_animation_player(child)
		if found:
			return found
	return null

func play_animation(fragment: String) -> void:
	if not anim:
		return
	for name in anim.get_animation_list():
		if String(name).to_lower().contains(fragment):
			if last_animation != name:
				anim.play(name)
				last_animation = name
			return

