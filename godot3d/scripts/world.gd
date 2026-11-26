@tool
extends Node3D

const PLAYER_SCENE := "res://assets/kenney/characters/Models/GLB format/character-male-a.glb"
const CITY := "res://assets/kenney/city/Models/GLB format/"
const ARCADE := "res://assets/kenney/arcade/Models/GLB format/"
const DUNGEON := "res://assets/kenney/dungeon/Models/GLB format/"
const ARENA := "res://assets/kenney/arena/Models/GLB format/"
const CHARACTERS := "res://assets/kenney/characters/Models/GLB format/"
const ZONE_LENGTH := 72.0
const ZONE_WIDTH := 30.0
const WORLD_LENGTH := ZONE_LENGTH * 3.0
const MAP_SCALE := 1.8
const WORLD_VISIBILITY_DISTANCE := 145.0
const WORLD_VISIBILITY_FADE := 18.0
const FIREFLY_UPDATE_INTERVAL := 1.0 / 30.0
const REQUIRED_INFO_CHESTS := 10
const INFORMATION_BOARD_PAGE_THRESHOLDS: Array[int] = [4, 7, 10]
const GUARDIAN8_REMOTE_INTERACTION_RANGE := 18.0
const GUARDIAN8_REMOTE_HEIGHT_RANGE := 14.0
const MAX_COOP_PLAYERS := 4
const COOP_PORT := 7777
const NPC_MOOD_DURATION := 90.0
const NPC_MOOD_RECHARGE_DURATION := 2.5
const NPC_MOOD_TRACK_WIDTH := 1.37
const NPC_MOOD_FILL_CAP_RADIUS := 0.038
const NPC_MOOD_FILL_HEIGHT := 0.074
const BARD_CHEER_RECHARGE_DURATION := NPC_MOOD_RECHARGE_DURATION
const BARD_CHEER_HOLD_DURATION := 8.0
const BARD_CHEER_STRENGTH := 1.0 / 3.0
const NPC_ZERO_MOOD_DEFEAT_COUNT := 3
const GAME_DURATION_SECONDS := 900.0
const ROULETTE_SPIN_DURATION := 4.8
const ROULETTE_TICK_COUNT := 28
const ROULETTE_OUTCOMES: Array[String] = [
	"¡Velocidad aumentada durante 1 minuto!",
	"¡Ganaste 1 minuto de tiempo!",
	"¡Todos los NPC recuperaron el 100% de ánimo!",
	"¡La ruleta completó la mitad de las cartas!",
	"La ruleta quitó 1 minuto del reloj.",
	"El ánimo de todos los NPC bajó al 50%.",
	"Te mueves más lento durante 1 minuto.",
	"El doble salto queda desactivado durante 1 minuto.",
	"La misión de cartas se reinició."
]
const MENU_BACKGROUND_PATH := "res://assets/ui/medieval_menu_background.png"
const LOADING_BACKGROUND_PATH := "res://assets/ui/loading_kingdom_riverside.png"
const WATER_LOADING_BACKGROUND: Texture2D = preload("res://assets/ui/loading_kingdom_underwater.png")
const DEFEAT_BACKGROUND: Texture2D = preload("res://assets/ui/defeat_kingdom_chaos.png")
const MENU_BUTTONS_PATH := "res://assets/ui/medieval_buttons_atlas.png"
const GAME_UI_ATLAS_PATH := "res://assets/ui/game_ui_atlas.png"
const ROLE_SYMBOLS_ATLAS: Texture2D = preload("res://assets/ui/role_symbols.png")
const ROLE_SYMBOL_MEDALLION: Texture2D = preload("res://assets/ui/role_symbol_medallion_02.png")
const RESTART_BUTTON_MEDALLION: Texture2D = preload("res://assets/ui/restart_button_medallion.png")
const NPC_MOOD_FRAME: Texture2D = preload("res://assets/ui/npc_mood_frame_3d.png")
const NPC_INTERACTION_PLAQUE: Texture2D = preload("res://assets/ui/npc_interaction_plaque_3d.png")
const DIALOGUE_BOARDS_ATLAS: Texture2D = preload("res://assets/ui/dialogue_boards_medieval.png")
const WHALE_PUZZLE_TEXTURE: Texture2D = preload("res://assets/ui/whale_puzzle.svg")
const CARTOON_FONT: FontFile = preload("res://assets/ui/fonts/LilitaOne-Regular.ttf")
const CHEST_PROGRESS_PATH := "user://chest_progress.cfg"
const DAY_PHASE_DURATION := 240.0
const CHEST_OPEN_SOUND_PATH := "res://assets/audio/chest_open.wav"
const CHEST_NEAR_SOUND_PATH := "res://assets/audio/chest_near_loop.wav"
const GAME_AMBIENT_MUSIC_PATH := "res://assets/audio/kingdom_ambient.mp3"
const NPC_INTERACTION_SOUND_PATH := "res://assets/audio/npc_interaction_villager.mp3"
const WATER_SPLASH_SOUND_PATH := "res://assets/audio/water_splash.mp3"
const PLAYER_NAME_TIMES_SCREEN: Texture2D = preload("res://assets/ui/player_name_times_screen.png")
const PLAYER_RECORDS_PATH := "user://player_completion_times.cfg"
const STORY_CINEMATIC_PANEL: Texture2D = preload("res://assets/ui/story_cinematic_panel.png")
const STORY_NARRATION_PATHS: Array[String] = [
	"res://assets/audio/story_intro_1.mp3",
	"res://assets/audio/story_intro_2.mp3",
	"res://assets/audio/story_intro_3.mp3",
	"res://assets/audio/story_intro_4.mp3",
	"res://assets/audio/story_intro_5.mp3",
	"res://assets/audio/story_intro_6.mp3"
]
const STORY_NARRATION_CAPTIONS: Array[String] = [
	"En el reino de Ciudad en Red, sus habitantes vivían en paz. El comercio florecía y la gente confiaba en sus vecinos.",
	"Pero el rey, cansado de sostener cada año la prosperidad del reino, concibió un plan en secreto: robar sus riquezas y esconder su culpa.",
	"Sembró desinformación. Con mensajes y rumores engañosos enfrentó a los habitantes; la economía se debilitó y la confianza se quebró.",
	"Entre cartas dudosas, estafas y retos peligrosos surgieron cuatro héroes: el Héroe, el Mensajero, el Bardo y el Revolucionario.",
	"Cada uno aportará sus talentos: reunir pruebas, llevar mensajes, levantar el ánimo y ayudar al pueblo a reconocer la verdad.",
	"Juntos revelarán el plan del rey y pondrán fin al engaño. Si el reino aprende a verificar y apoyarse, un nuevo amanecer se alzará sobre Ciudad en Red."
]
const CHEST_NEAR_LOOP_START_SECONDS := 0.06
const CHEST_PROXIMITY_RANGE := 8.0
const INFORMATION_BOARD_SCENE := "res://scenes/props/tablon_anuncios_medieval_3d.tscn"
const ROLE_MANAGER := preload("res://scripts/role_manager.gd")
const JOURNALIST_CLAIMS := [
	{"statement":"La alerta del cierre del centro comunitario incluye una fuente oficial verificable.", "is_true":false},
	{"statement":"La jornada de limpieza aparece en el calendario publicado por la alcaldía.", "is_true":true},
	{"statement":"Una encuesta de tres personas basta para representar a todo el reino.", "is_true":false},
	{"statement":"El debate municipal tiene fecha y hora confirmadas en el portal oficial.", "is_true":true},
	{"statement":"Una captura recortada demuestra por sí sola que un candidato cerrará el parque.", "is_true":false},
	{"statement":"La propuesta de reparación publica responsables y presupuesto.", "is_true":true},
	{"statement":"La cifra compartida coincide con el informe público original.", "is_true":true},
	{"statement":"Un mensaje anónimo confirma que el alcalde robó fondos.", "is_true":false},
	{"statement":"La noticia viral conserva su fecha original y no está desactualizada.", "is_true":true},
	{"statement":"El acta electoral confirma el lugar y la hora de la votación.", "is_true":true}
]
var journalist_claims: Array = JOURNALIST_CLAIMS.duplicate(true)

var player: CharacterBody3D
var camera: Camera3D
var overview_camera: Camera3D
var prompt: Label
var ui_layer: CanvasLayer
var hint: Label
var hud: Label
var panel: PanelContainer
var panel_text: Label
var dialogue_title_label: Label
var dialogue_body_label: Label
var dialogue_title_plaque: PanelContainer
var dialogue_title_holder: Control
var dialogue_source_cache := ""
var prompt_keycap_label: Label
var prompt_action_label: Label
var panel_uses_q := false
var question_index := -1
var answered := 0
var role_assignments: Array = []
var local_roles: Array = []
var active_role_index := 0
var active_role := "Ciudadano"
var solo_role_button: Button
var network_button: Button
var network_panel: PanelContainer
var network_status: Label
var address_input: LineEdit
var cheered_npcs: Dictionary = {}
var is_solo_mode := true
var is_network_host := false
var network_peer_ids: Array[int] = []
var network_player_names: Dictionary = {}
var network_player_name := "Jugador"
var bard_cooldowns: Dictionary = {}
var bard_cheer_target := -1
var bard_cheer_elapsed := 0.0
var remote_players: Dictionary = {}
var network_sync_elapsed := 0.0
var interviewed_npcs: Dictionary = {}
var informed_npcs: Dictionary = {}
var journalist_has_documents := false
var journalist_puzzle_npc := -1
var journalist_puzzle_sequence: Array[int] = []
var journalist_puzzle_input: Array[int] = []
var journalist_claim_index := -1
var journalist_puzzle_stage := ""
var journalist_puzzle_correct_option := 1
var journalist_minigame_kind := 0
var journalist_minigame_sequence: Array[int] = []
var journalist_minigame_input: Array[int] = []
var journalist_results: Array[String] = []
var journalist_correct_classifications := 0
var journalist_rejected_false_count := 0
var journalist_validated_info: Array[int] = []
var journalist_verified := false
var influencer_has_information := false
var influencer_delivery_queue: Array[Dictionary] = []
var influencer_delivery_cursor := 0
var shared_info_by_npc: Dictionary = {}
var final_classification_summary := ""
var stations: Array[Dictionary] = []
var info_chests: Array[Dictionary] = []
var npc_targets: Array[Dictionary] = []
var guardian8: Node3D
var guardian8_home_position := Vector3.ZERO
var guardian8_bob_elapsed := 0.0
var guardian8_animators: Array[AnimationPlayer] = []
var guardian8_jump_animation_names: Array[String] = []
var guardian8_mission_completed := false
var guardian8_owner_peer_id := 0
var guardian8_dialogue_pending := false
var tied_guard_9: Node3D
var tied_guard_9_start_transform := Transform3D.IDENTITY
var tied_guard_9_original_transforms: Dictionary = {}
var rescue_knife: Node3D
var rescue_knife_start_transform := Transform3D.IDENTITY
var revolutionary_rescue_started := false
var revolutionary_rescue_completed := false
var revolutionary_rescue_has_knife := false
var revolutionary_knife_inspected := false
var revolutionary_rescue_animation_active := false
var revolutionary_rescue_dialogue_stage := ""
var whale_puzzle_active := false
var whale_puzzle_tiles: Array[int] = []
var whale_puzzle_rotations: Array[int] = []
var whale_puzzle_selected_cell := 0
var whale_puzzle_held_tile := -1
var whale_puzzle_held_rotation := 0
var whale_puzzle_held_origin := -1
var whale_puzzle_cells: Array[Button] = []
var whale_puzzle_panel: PanelContainer
var whale_puzzle_grid: GridContainer
var whale_puzzle_title: Label
var whale_puzzle_instructions: Label
var whale_puzzle_dim: ColorRect
var fraud_guard_nodes: Dictionary = {}
var fraud_guard7_spoken := false
var fraud_letter_received := false
var fraud_case_resolved := false
var fraud_guard7_suspicion_stage := 0
var fraud_wrong_suspicions := 0
var fraud_owner_peer_id := 0
var fraud_guard6_concern_played := false
var npc_greeted: Dictionary = {}
var npc_night_lights: Array[OmniLight3D] = []
var chest_lights: Array[OmniLight3D] = []
var chest_proximity_players: Array[Dictionary] = []
var firefly_nodes: Array[Node3D] = []
var firefly_lights: Array[OmniLight3D] = []
var firefly_orbs: Array[MeshInstance3D] = []
var firefly_time := 0.0
var firefly_update_accumulator := 0.0
var ticket_terminal_position := Vector3(-10000, 0, 0)
var research_desk_position := Vector3(-10000, 0, 0)
var roulette_wheels: Array[Dictionary] = []
var roulette_role_uses: Dictionary = {}
var roulette_spinning_wheels: Dictionary = {}
var roulette_tick_stream: AudioStreamWAV
var npc_mood_duration := NPC_MOOD_DURATION
var game_time_remaining := GAME_DURATION_SECONDS
var game_running := false
var lights_enabled := true
var menu_root: Control
var defeat_background: TextureRect
var home_screen: Control
var menu_panel: PanelContainer
var menu_content: VBoxContainer
var gameplay_top_panel: PanelContainer
var gameplay_top_panel_home_position := Vector2(22, 130)
var gameplay_top_panel_tween: Tween
var gameplay_status_requested_visible := false
var gameplay_role_symbols_row: HBoxContainer
var gameplay_role_symbols_home_position := Vector2(22, 12)
var gameplay_bottom_panel: PanelContainer
var gameplay_crosshair: Label
var gameplay_started := false
var player_name_screen: Control
var player_name_input: LineEdit
var player_name_field_cover: ColorRect
var player_name_placeholder_label: Label
var player_name_message: Label
var leaderboard_overlay: Control
var leaderboard_rows: VBoxContainer
var leaderboard_records: Array[Dictionary] = []
var match_elapsed_seconds := 0.0
var completion_recorded_for_match := false
var story_cinematic_active := false
var spawn_transition_active := false
var time_progress: ProgressBar
var time_label: Label
var time_fill_style: StyleBoxFlat
var mission_panel_style: StyleBoxFlat
var mission_button_style: StyleBoxFlat
var time_frame: TextureRect
var time_label_frame: TextureRect
var restart_button: Button
var restart_button_tween: Tween
var restart_confirmation_root: Control
var restart_confirmation_panel: PanelContainer
var timer_container: Control
var prompt_panel: PanelContainer
var volume_slider: HSlider
var scale_picker: OptionButton
var room_code_input: LineEdit
var room_name_input: LineEdit
var room_password_input: LineEdit
var join_password_input: LineEdit
var room_password := ""
var room_password_hash := ""
var join_password := ""
var join_room_code := ""
var pending_peer_passwords: Dictionary = {}
var network_password_input: LineEdit
var network_player_name_input: LineEdit
var random_room_name := ""
var menu_status: Label
var random_room_code := ""
var game_timer_timeout := false
var last_defeat_cause := "timeout"
var speed_boost_time := 0.0
var slow_time := 0.0
var double_jump_disabled_time := 0.0
var water_respawn_pending := false
var permanent_spawn_position := Vector3.ZERO
var permanent_spawn_position_set := false
var sun_light: DirectionalLight3D
var day_environment: Environment
var day_sky: ShaderMaterial
var day_cycle_elapsed := 0.0
var day_phase_presets: Array[Dictionary] = []
var chest_open_stream: AudioStreamWAV
var chest_near_stream: AudioStreamWAV
var game_ambient_music: AudioStreamPlayer
var npc_interaction_voice_stream: AudioStreamMP3
var water_splash_player: AudioStreamPlayer
var collected_info: Dictionary = {}
var info_delivered := false
var board_pages_placed := 0
var chest_letter: StaticBody3D
var chest_letter_start_transform := Transform3D.IDENTITY
var pending_card_chest_index := -1
var pending_card_clue := ""
var hero_is_carrying_card := false
var card_carrier_peer_id := 0
var questions := [
	{"title":"El mensaje viral", "body":"Un mensaje afirma que cerrarán el centro comunitario. No cita ninguna fuente. ¿Qué haces?", "answers":["Lo reenvío ya", "Busco una fuente oficial", "Lo cambio para que asuste más"], "correct":1, "fact":"Verificar en canales oficiales evita que un rumor se convierta en una alarma."},
	{"title":"La encuesta", "body":"Una encuesta solo preguntó a tus tres amigos. ¿Representa a todo el barrio?", "answers":["Sí, es suficiente", "No, la muestra es muy pequeña", "Solo si la publico muchas veces"], "correct":1, "fact":"Una muestra pequeña o sesgada no describe a toda la comunidad."},
	{"title":"La propuesta", "body":"Una propuesta promete arreglar todas las calles, pero no explica cómo. ¿Qué pregunta ayuda?", "answers":["¿Cuál es el plan y el presupuesto?", "¿Quién tiene más seguidores?", "¿Puedo ponerle un emoji?"], "correct":0, "fact":"Pedir plan, responsables y presupuesto permite comparar propuestas con criterio."},
	{"title":"El archivo", "body":"Encuentras dos versiones de una cifra. ¿Cuál es el siguiente paso?", "answers":["Comparar fecha y fuente original", "Elegir la que me gusta", "Publicar las dos como ciertas"], "correct":0, "fact":"La fecha y el origen de los datos ayudan a entender qué versión es fiable."}
]

func _ready() -> void:
	if Engine.is_editor_hint():
		# Build the diorama as owned scene nodes so the level is editable and savable.
		if get_node_or_null("DioramaBase") == null:
			_build_world()
			_set_scene_owners(self, self)
		# Some placed Kenney structures were missing physics bodies. Repair only
		# imported asset instances without a collider, preserving the edited layout.
		_repair_asset_collisions(self)
		_build_environment_dressing()
		_ensure_missing_tree_collisions(self)
		_ensure_information_board()
		_build_editor_npcs()
		return
	_build_loading_screen()
	await get_tree().process_frame
	if get_node_or_null("DioramaBase") == null:
		_build_world()
	role_assignments = ROLE_MANAGER.assign_roles(1)
	local_roles = role_assignments[0]
	active_role = String(local_roles[active_role_index])
	_repair_asset_collisions(self)
	_build_environment_dressing()
	_ensure_missing_tree_collisions(self)
	_ensure_information_board()
	_set_board_pages_placed(board_pages_placed)
	_scale_map_up()
	_setup_chest_letter()
	_find_research_desk()
	_optimize_static_visuals()
	# Let the physics server register saved geometry before placing guards on clear ground.
	await get_tree().physics_frame
	_setup_npcs()
	_setup_fraud_case_npcs()
	_setup_guardia_08()
	_setup_revolutionary_rescue()
	_setup_guardia_07_writer()
	_load_chest_open_sound()
	_setup_game_ambient_music()
	_load_npc_interaction_voice()
	_setup_water_splash_sound()
	_load_player_completion_times()
	_discover_information_chests()
	_find_ticket_terminal()
	_find_roulette()
	_setup_day_night_cycle()
	_setup_fireflies()
	lights_enabled = _load_setting_bool("lights_enabled", true)
	_on_lights_toggled(lights_enabled)
	_build_player()
	_build_ui()
	lights_enabled = _load_setting_bool("lights_enabled", true)
	_on_volume_changed(_load_setting_float("volume", 0.8))
	get_window().content_scale_factor = _load_setting_float("ui_scale", 1.0)
	multiplayer.peer_connected.connect(_on_network_peer_connected)
	multiplayer.peer_disconnected.connect(_on_network_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	_build_camera()
	player.controls_enabled = false
	player.set_physics_process(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_show_menu_page("home")
	_set_gameplay_ui_visible(false)
	if is_instance_valid(get_node_or_null("LoadingScreen")):
		get_node("LoadingScreen").queue_free()

func _set_scene_owners(node: Node, scene_root: Node) -> void:
	for child in node.get_children():
		child.owner = scene_root
		_set_scene_owners(child, scene_root)

func _ensure_information_board() -> void:
	if get_node_or_null("Tablon_Informacion") != null:
		return
	var packed_board := load(INFORMATION_BOARD_SCENE) as PackedScene
	if packed_board == null:
		push_warning("No pude cargar el tablón medieval de información.")
		return
	var board := packed_board.instantiate() as Node3D
	if board == null:
		push_warning("La escena del tablón no tiene una raíz Node3D.")
		return
	board.name = "Tablon_Informacion"
	board.position = Vector3(60.2522, 0.0, -0.52175903)
	board.set_meta("information_board", true)
	board.set_meta("ticket_terminal", true)
	add_child(board)
	if Engine.is_editor_hint():
		var scene_root := get_tree().edited_scene_root
		if scene_root != null:
			_set_scene_owners(board, scene_root)
			board.owner = scene_root

func _set_board_pages_placed(count: int) -> void:
	board_pages_placed = clampi(count, 0, INFORMATION_BOARD_PAGE_THRESHOLDS.size())
	var board := get_node_or_null("Tablon_Informacion")
	if board != null and board.has_method("set_pages_placed"):
		board.call("set_pages_placed", board_pages_placed)

func _scale_map_up() -> void:
	if has_meta("expanded_map_applied"):
		return
	for child in get_children():
		if not child is Node3D:
			continue
		var map_object := child as Node3D
		var transform := map_object.global_transform
		transform.origin *= MAP_SCALE
		if not _is_chest_instance(map_object):
			transform.basis = transform.basis.scaled(Vector3.ONE * MAP_SCALE)
		map_object.global_transform = transform
	set_meta("expanded_map_applied", true)

func _optimize_static_visuals() -> void:
	# The three districts contain thousands of low-poly mesh nodes. Keep the
	# nearby gameplay area sharp and fade distant meshes before they flood the
	# integrated GPU with unnecessary draw calls.
	for candidate in find_children("*", "MeshInstance3D", true, false):
		var mesh_instance := candidate as MeshInstance3D
		if mesh_instance == null or mesh_instance.mesh == null:
			continue
		mesh_instance.visibility_range_end = WORLD_VISIBILITY_DISTANCE
		mesh_instance.visibility_range_end_margin = WORLD_VISIBILITY_FADE
		mesh_instance.visibility_range_fade_mode = GeometryInstance3D.VISIBILITY_RANGE_FADE_SELF

func _absolute_transform(node: Node3D) -> Transform3D:
	# global_transform logs an engine error when editor-added assets are repaired
	# before entering the active tree. Compose local transforms safely instead.
	var result := node.transform
	var ancestor := node.get_parent()
	while ancestor is Node3D:
		result = (ancestor as Node3D).transform * result
		ancestor = ancestor.get_parent()
	return result

func _is_chest_instance(node: Node3D) -> bool:
	return node.scene_file_path.to_lower().contains("chest.glb") or node.name.to_lower().contains("chest")

func _repair_asset_collisions(node: Node) -> void:
	for child in node.get_children():
		# Remove legacy oversized aggregate boxes from the running/editor scene.
		if child.name == "ReliableBoundsCollider":
			child.queue_free()
			continue
		# Discard old stair and step colliders. Their fitted ramps are rebuilt from
		# each stair's actual world bounds below, avoiding stacked convex/trimesh
		# shapes that used to trap the player between treads.
		if child is StaticBody3D:
			var collider_name := String(child.name).to_lower()
			var is_old_stair_collider := collider_name.contains("climbablestaircollider") or (collider_name.contains("stair") and (collider_name.contains("collider") or collider_name.contains("ramp")) and not collider_name.begins_with("fittedstairramp_"))
			if is_old_stair_collider:
				child.queue_free()
				continue
		if child is Node3D and (child as Node3D).scene_file_path.to_lower().ends_with("stairs.glb"):
			_clear_stair_asset_collisions(child as Node3D)
			_add_stair_ramp_collision(child as Node3D)
			continue
		if child is StaticBody3D and (child.name.to_lower().contains("floor") or child.name == "DioramaBase"):
			# Restore the saved walkable floor supports. The previous zero collision
			# layer let the player fall through the map even where a floor was visible.
			child.collision_layer = 1
			child.collision_mask = 1
		# Many barrels in the editable scene are loose MeshInstance3D nodes, not
		# imported scene roots. Give each one a fitted cylinder collider of its own.
		if child is MeshInstance3D and child.mesh != null and child.name.to_lower().contains("barrel"):
			_add_barrel_cylinder_collision(child)
		if child is MeshInstance3D and child.mesh != null and child.name.to_lower().contains("column"):
			_add_column_mesh_collision(child)
		if child is MeshInstance3D and child.mesh != null and _has_asset_keyword(child, ["pot", "urn", "vase", "jar"]):
			_add_fitted_object_collider(child, true, "ContainerFittedCollider")
		if child is MeshInstance3D and child.mesh != null and _is_floor_tile_mesh(child):
			_add_fitted_object_collider(child, false, "FloorTileFittedCollider")
		if child is MeshInstance3D and child.mesh != null and _is_tree_or_stone_mesh(child):
			_add_convex_object_collision(child)
		if child is MeshInstance3D and child.mesh != null and _is_block_mesh(child):
			_add_fitted_object_collider(child, false, "BlockFittedCollider")
		if child is MeshInstance3D and child.mesh != null and _is_stair_mesh(child):
			_clear_stair_asset_collisions(child)
			_add_stair_ramp_collision(child)
			continue
		if child is MeshInstance3D and child.mesh != null and _is_bridge_or_statue_mesh(child):
			_add_convex_object_collision(child)
		if child is MeshInstance3D and child.mesh != null and _has_asset_keyword(child, ["pedestal", "statue-base", "statue_base"]):
			_add_fitted_object_collider(child, false, "PedestalFittedCollider")
		if child is MeshInstance3D and child.mesh != null and _has_asset_keyword(child, ["flag", "banner"]):
			_add_fitted_object_collider(child, false, "FlagFittedCollider")
		if child is MeshInstance3D and child.mesh != null and _is_tower_piece_mesh(child):
			_add_convex_object_collision(child)
		if child is Node3D:
			var meshes := child.find_children("*", "MeshInstance3D", true, false)
			var has_direct_mesh := false
			for asset_child in child.get_children():
				if asset_child is MeshInstance3D:
					has_direct_mesh = true
					break
			var has_imported_ancestor := false
			var ancestor := child.get_parent()
			while ancestor:
				if ancestor is Node3D and not ancestor.scene_file_path.is_empty():
					has_imported_ancestor = true
					break
				ancestor = ancestor.get_parent()
			# Imported scenes and hand-placed mesh groups both need coverage. This
			# catches simple editor-created props that have no scene_file_path.
			var is_graphic_asset := not child.scene_file_path.is_empty() or (has_direct_mesh and not has_imported_ancestor)
			if is_graphic_asset and not meshes.is_empty():
				var existing_shapes := child.find_children("*", "CollisionShape3D", true, false)
				if existing_shapes.is_empty():
					var replaced_floor_meshes := false
					for mesh_node in meshes:
						var floor_mesh := mesh_node as MeshInstance3D
						if floor_mesh and _is_floor_tile_mesh(floor_mesh):
							_add_fitted_object_collider(floor_mesh, false, "FloorTileFittedCollider")
							replaced_floor_meshes = true
					if not replaced_floor_meshes:
						_add_mesh_collisions(child)
					if Engine.is_editor_hint():
						_set_scene_owners(child, get_tree().edited_scene_root)
		_repair_asset_collisions(child)

func _add_barrel_cylinder_collision(barrel: MeshInstance3D) -> void:
	_add_fitted_object_collider(barrel, true, "BarrelFittedCollider")

func _add_column_mesh_collision(column: MeshInstance3D) -> void:
	_add_fitted_object_collider(column, false, "ColumnFittedCollider")

func _add_fitted_object_collider(graphic: MeshInstance3D, cylindrical: bool, suffix: String) -> void:
	var parent_node := graphic.get_parent()
	if parent_node == null:
		return
	var body_name := String(graphic.name) + "_" + suffix
	if parent_node.get_node_or_null(NodePath(body_name)) != null:
		return
	# Compute bounds in world space, then put an unscaled StaticBody beside the
	# graphic. The previous child collider inherited extreme mesh scales, which
	# can make it appear present while the physics body fails to block the player.
	var local_bounds := graphic.mesh.get_aabb()
	var graphic_to_world := _absolute_transform(graphic)
	var parent_to_world := _absolute_transform(parent_node as Node3D)
	var world_bounds: AABB = graphic_to_world * local_bounds
	if world_bounds.size.x < 0.03 or world_bounds.size.y < 0.03 or world_bounds.size.z < 0.03:
		return
	var body := StaticBody3D.new()
	body.name = body_name
	body.collision_layer = 1
	body.collision_mask = 1
	parent_node.add_child(body)
	body.transform = parent_to_world.affine_inverse() * Transform3D(Basis.IDENTITY, world_bounds.get_center())
	var collision := CollisionShape3D.new()
	if cylindrical:
		var cylinder := CylinderShape3D.new()
		cylinder.height = world_bounds.size.y
		cylinder.radius = maxf(world_bounds.size.x, world_bounds.size.z) * 0.5
		collision.shape = cylinder
	else:
		var box := BoxShape3D.new()
		box.size = world_bounds.size
		collision.shape = box
	body.add_child(collision)
	collision.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else null
	body.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else null

func _is_tree_or_stone_mesh(graphic: MeshInstance3D) -> bool:
	var node: Node = graphic
	while node:
		var key := node.name.to_lower()
		if node is Node3D:
			key += " " + (node as Node3D).scene_file_path.to_lower()
		if key.contains("tree") or key.contains("rock") or key.contains("stone"):
			return true
		node = node.get_parent()
	return false

func _ensure_missing_tree_collisions(root: Node) -> void:
	# Hand-placed trees added in the editor can be loose MeshInstance3D nodes
	# without the fitted collider children that imported tree scenes already have.
	for candidate in root.find_children("*", "MeshInstance3D", true, false):
		var graphic := candidate as MeshInstance3D
		if graphic == null or graphic.mesh == null or not _is_tree_mesh(graphic):
			continue
		var parent_node := graphic.get_parent()
		if parent_node == null:
			continue
		var collider_name := String(graphic.name) + "_FittedConvexCollider"
		if parent_node.get_node_or_null(NodePath(collider_name)) != null:
			continue
		var ancestor := parent_node
		var has_parent_collision := false
		while ancestor != null and ancestor != root:
			if ancestor is StaticBody3D:
				has_parent_collision = true
				break
			ancestor = ancestor.get_parent()
		if not has_parent_collision:
			_add_convex_object_collision(graphic)

func _is_tree_mesh(graphic: MeshInstance3D) -> bool:
	var node: Node = graphic
	while node != null:
		var key := String(node.name).to_lower()
		if node is Node3D:
			key += " " + (node as Node3D).scene_file_path.to_lower()
		if key.contains("tree") or key.contains("pine") or key.contains("arbol") or key.contains("árbol"):
			return true
		node = node.get_parent()
	return false

func _is_block_mesh(graphic: MeshInstance3D) -> bool:
	return _has_asset_keyword(graphic, ["block"])

func _is_floor_tile_mesh(graphic: MeshInstance3D) -> bool:
	if _has_asset_keyword(graphic, ["floor-detail"]):
		return false
	return graphic.name.to_lower().contains("floor") or _has_asset_keyword(graphic, ["floor.glb"])

func _is_stair_mesh(graphic: MeshInstance3D) -> bool:
	return _has_asset_keyword(graphic, ["stair", "stairs"])

func _is_bridge_or_statue_mesh(graphic: MeshInstance3D) -> bool:
	return _has_asset_keyword(graphic, ["bridge", "statue"])

func _is_tower_piece_mesh(graphic: MeshInstance3D) -> bool:
	if _has_asset_keyword(graphic, ["wall-opening"]):
		return false
	return _has_asset_keyword(graphic, ["tower", "watchtower", "turret", "castle", "fort", "building", "skyscraper", "wall", "gate"])

func _has_asset_keyword(graphic: MeshInstance3D, keywords: Array[String]) -> bool:
	var node: Node = graphic
	while node:
		var key := node.name.to_lower()
		if node is Node3D:
			key += " " + (node as Node3D).scene_file_path.to_lower()
		for keyword in keywords:
			if key.contains(keyword):
				return true
		node = node.get_parent()
	return false

func _add_convex_object_collision(graphic: MeshInstance3D) -> void:
	var parent_node := graphic.get_parent()
	if parent_node == null:
		return
	var suffix := "FittedConvexCollider"
	var body_name := String(graphic.name) + "_" + suffix
	if parent_node.get_node_or_null(NodePath(body_name)) != null:
		return
	var convex := graphic.mesh.create_convex_shape()
	if convex == null or convex.points.size() < 4:
		return
	var graphic_to_world := _absolute_transform(graphic)
	var parent_to_world := _absolute_transform(parent_node as Node3D)
	var world_bounds: AABB = graphic_to_world * graphic.mesh.get_aabb()
	var center := world_bounds.get_center()
	var world_points := PackedVector3Array()
	world_points.resize(convex.points.size())
	for i in range(convex.points.size()):
		world_points[i] = graphic_to_world * convex.points[i] - center
	convex.points = world_points
	var body := StaticBody3D.new()
	body.name = body_name
	body.collision_layer = 1
	body.collision_mask = 1
	parent_node.add_child(body)
	body.transform = parent_to_world.affine_inverse() * Transform3D(Basis.IDENTITY, center)
	var collision := CollisionShape3D.new()
	collision.shape = convex
	body.add_child(collision)
	body.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else null
	collision.owner = get_tree().edited_scene_root if Engine.is_editor_hint() else null

func _clear_stair_asset_collisions(stair_root: Node3D) -> void:
	for candidate in stair_root.find_children("*", "StaticBody3D", true, false):
		var body := candidate as StaticBody3D
		var lower_name := body.name.to_lower()
		if lower_name == "assetmeshcollision" or lower_name.contains("fittedconvexcollider") or lower_name.contains("stair"):
			body.queue_free()
	var parent_node := stair_root.get_parent()
	if parent_node == null:
		return
	var prefix := String(stair_root.name).to_lower()
	for sibling in parent_node.get_children():
		if sibling == stair_root or not sibling is StaticBody3D:
			continue
		var lower_name := sibling.name.to_lower()
		if lower_name.begins_with(prefix) and (lower_name.contains("collision") or lower_name.contains("ramp")):
			sibling.queue_free()

func _add_stair_ramp_collision(stair_root: Node3D) -> void:
	var parent_node := stair_root.get_parent()
	if parent_node == null:
		return
	var body_name := "FittedStairRamp_" + String(stair_root.name).validate_node_name()
	if parent_node.get_node_or_null(NodePath(body_name)) != null:
		return
	var bounds := _world_visual_bounds(stair_root)
	if bounds.size.y < 0.08 or bounds.size.x < 0.08 or bounds.size.z < 0.08:
		return
	var run_dir := stair_root.global_transform.basis * Vector3(0, 0, -1)
	run_dir.y = 0.0
	if run_dir.length_squared() < 0.0001:
		return
	run_dir = run_dir.normalized()
	var width_dir := stair_root.global_transform.basis * Vector3.RIGHT
	width_dir.y = 0.0
	if width_dir.length_squared() < 0.0001:
		width_dir = Vector3(-run_dir.z, 0, run_dir.x)
	else:
		width_dir = width_dir.normalized()
	var horizontal_run := bounds.size.x * absf(run_dir.x) + bounds.size.z * absf(run_dir.z)
	var horizontal_width := bounds.size.x * absf(width_dir.x) + bounds.size.z * absf(width_dir.z)
	if horizontal_run < 0.1 or horizontal_width < 0.1:
		return
	var rise := bounds.size.y
	if stair_root.has_meta("stair_ramp_length"):
		horizontal_run = float(stair_root.get_meta("stair_ramp_length"))
	if stair_root.has_meta("stair_ramp_rise"):
		rise = float(stair_root.get_meta("stair_ramp_rise"))
	var slope_direction := (run_dir * horizontal_run + Vector3.UP * rise).normalized()
	var slope_normal := width_dir.cross(slope_direction).normalized()
	if slope_normal.y < 0.0:
		slope_normal = -slope_normal
		width_dir = -width_dir
	var ramp_basis := Basis(slope_direction, slope_normal, width_dir)
	var body := StaticBody3D.new()
	body.name = body_name
	body.collision_layer = 1
	body.collision_mask = 1
	parent_node.add_child(body)
	body.global_transform = Transform3D(ramp_basis, bounds.get_center())
	var collision := CollisionShape3D.new()
	var ramp_shape := BoxShape3D.new()
	ramp_shape.size = Vector3(sqrt(horizontal_run * horizontal_run + rise * rise) + 0.05, 0.14, horizontal_width + 0.12)
	collision.shape = ramp_shape
	body.add_child(collision)
	var scene_root := get_tree().edited_scene_root if Engine.is_editor_hint() else null
	body.owner = scene_root
	collision.owner = scene_root

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	_sync_dialogue_board_text()
	if game_running:
		match_elapsed_seconds += delta
		_update_guardia_08_hop(delta)
		_update_npc_moods(delta)
		_update_npc_facing(delta)
		_update_bard_cheer(delta)
		_update_speed_boost(delta)
		_update_day_night_cycle(delta)
		_animate_fireflies(delta)
		_update_chest_proximity_audio()
		_update_nearest_station()
		_sync_interaction_plaque()
		game_time_remaining = maxf(0.0, game_time_remaining - delta)
		_update_timer_hud()
		if game_time_remaining <= 0.0 and not game_timer_timeout:
			game_timer_timeout = true
			_end_game(false)
	else:
		_stop_all_chest_proximity_sounds()
	if multiplayer.multiplayer_peer != null and player != null:
		network_sync_elapsed += delta
		if network_sync_elapsed >= 0.08:
			network_sync_elapsed = 0.0
			rpc("_receive_remote_transform", multiplayer.get_unique_id(), player.global_position, player.rotation.y)

func _unhandled_input(event: InputEvent) -> void:
	if not game_running and is_instance_valid(player_name_screen) and player_name_screen.visible and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		_show_menu_page("home")
		get_viewport().set_input_as_handled()
		return
	# Keep gameplay controls completely inactive while any menu or lobby is open.
	if not game_running:
		return
	if event is InputEventKey and event.pressed and not event.echo and (event.keycode == KEY_CTRL or event.physical_keycode == KEY_CTRL):
		_animate_gameplay_status_panel(not gameplay_status_requested_visible)
		get_viewport().set_input_as_handled()
		return
	if whale_puzzle_active:
		if event is InputEventKey and event.pressed and not event.echo:
			if event.keycode in [KEY_SHIFT, KEY_CAPSLOCK] or event.physical_keycode in [KEY_SHIFT, KEY_CAPSLOCK]:
				_rotate_whale_puzzle_tile(whale_puzzle_selected_cell, 1)
			else:
				match event.keycode:
					KEY_LEFT: _move_whale_puzzle_cursor(-1, 0)
					KEY_RIGHT: _move_whale_puzzle_cursor(1, 0)
					KEY_UP: _move_whale_puzzle_cursor(0, -1)
					KEY_DOWN: _move_whale_puzzle_cursor(0, 1)
					KEY_SPACE: _toggle_whale_puzzle_pickup()
			get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_SPACE and guardian8_dialogue_pending:
		_close_question()
		get_viewport().set_input_as_handled()
		return
	if game_running and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_TAB:
		_cycle_solo_role()
		get_viewport().set_input_as_handled()
		return
	if journalist_puzzle_npc >= 0 and event is InputEventKey and event.pressed and not event.echo:
		if event.keycode >= KEY_1 and event.keycode <= KEY_3:
			_answer_interview_puzzle(int(event.keycode - KEY_0))
			get_viewport().set_input_as_handled()
			return
	if journalist_claim_index >= 0 and event is InputEventKey and event.pressed and not event.echo:
		if journalist_puzzle_stage == "result":
			if event.keycode >= KEY_1 and event.keycode <= KEY_3:
				get_viewport().set_input_as_handled()
				return
		if event.keycode >= KEY_1 and event.keycode <= KEY_3:
			var journalist_choice := int(event.keycode - KEY_0)
			if journalist_puzzle_stage != "classify" or journalist_choice <= 2:
				_answer_journalist_claim(journalist_choice)
			get_viewport().set_input_as_handled()
			return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F1:
		_toggle_map_overview()
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_F2:
		_show_restart_confirmation()
		get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("extra_mission"):
		if whale_puzzle_active:
			get_viewport().set_input_as_handled()
			return
		if panel != null and panel.visible:
			if panel_uses_q:
				_close_question()
			get_viewport().set_input_as_handled()
		else:
			var extra_target := _nearest_interaction_target()
			if String(extra_target.get("kind", "")) == "guardian8":
				_start_guardian8_interaction()
				get_viewport().set_input_as_handled()
				return
			if String(extra_target.get("kind", "")) == "revolutionary_guard":
				_start_revolutionary_guard_interaction()
				get_viewport().set_input_as_handled()
				return
			if String(extra_target.get("kind", "")) == "fraud_npc" or (fraud_letter_received and String(extra_target.get("kind", "")) == "npc"):
				_open_nearest_station()
				get_viewport().set_input_as_handled()
				return
			get_viewport().set_input_as_handled()
		return
	if event.is_action_pressed("interact"):
		if whale_puzzle_active:
			get_viewport().set_input_as_handled()
			return
		if panel != null and panel.visible:
			if not panel_uses_q and not guardian8_dialogue_pending:
				_close_question()
			get_viewport().set_input_as_handled()
			return
		var interaction_target := _nearest_interaction_target(true)
		if String(interaction_target.get("kind", "")) in ["guardian8", "revolutionary_guard", "fraud_npc"] or (fraud_letter_received and String(interaction_target.get("kind", "")) == "npc"):
			get_viewport().set_input_as_handled()
			return
		if active_role == "Influencer" and not influencer_has_information and not fraud_letter_received and String(interaction_target.get("kind", "")) == "npc":
			var npc_index := int(interaction_target.npc_index)
			if float(bard_cooldowns.get(npc_index, 0.0)) <= 0.0:
				_play_npc_interaction_voice(interaction_target.node as Node3D)
				bard_cheer_target = npc_index
				bard_cheer_elapsed = 0.0
			get_viewport().set_input_as_handled()
			return
		_open_nearest_station(true)
	elif question_index >= 0 and event is InputEventKey and event.pressed and not event.echo:
		var num: int = event.keycode - KEY_1
		if num >= 0 and num <= 2:
			_answer(num)
		elif event.keycode == KEY_ESCAPE:
			_close_question()

func _build_world() -> void:
	var env := WorldEnvironment.new()
	var environment := Environment.new()
	environment.background_mode = Environment.BG_SKY
	var sky := Sky.new()
	var sky_mat := ShaderMaterial.new()
	sky_mat.shader = load("res://scripts/dynamic_sky.gdshader")
	sky_mat.set_shader_parameter("zenith_color", Vector3(0.09, 0.15, 0.25))
	sky_mat.set_shader_parameter("horizon_color", Vector3(0.45, 0.56, 0.67))
	sky_mat.set_shader_parameter("ground_color", Vector3(0.08, 0.10, 0.17))
	sky.sky_material = sky_mat
	environment.sky = sky
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("8296b2")
	environment.ambient_light_energy = 0.2
	environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	# A restrained bloom halo keeps emissive props readable across the whole map.
	environment.glow_enabled = true
	environment.glow_intensity = 0.32
	environment.glow_bloom = 0.06
	env.environment = environment
	add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48, -25, 0)
	sun.light_energy = 0.24
	sun.shadow_enabled = true
	add_child(sun)
	# One continuous diorama base supports all three adjoining biomes.
	_add_box("DioramaBase", Vector3(WORLD_LENGTH * 0.5, -3.5, 0), Vector3(WORLD_LENGTH + 8, 0.5, ZONE_WIDTH + 8), Color("282b38"), true)
	for zone in range(3):
		_build_continuous_zone(zone, float(zone) * ZONE_LENGTH)
	# One learning station sits near the far end of each continuous biome.
	stations = [
		{"position":Vector3(66, 0, 0), "model":INFORMATION_BOARD_SCENE, "title":"Tablón de información"},
		{"position":Vector3(138, 0, 0), "model":ARCADE + "prize-wheel.glb", "title":"Estación de datos"},
		{"position":Vector3(210, 0, 0), "model":DUNGEON + "chest.glb", "title":"Estación de propuestas"}
	]
	for i in range(stations.size()):
		var st: Dictionary = stations[i]
		var station_model: Node3D
		if String(st.model).to_lower().ends_with(".tscn"):
			var station_scene := load(String(st.model)) as PackedScene
			station_model = station_scene.instantiate() as Node3D if station_scene != null else null
			if station_model != null:
				station_model.name = "Tablon_Informacion"
				station_model.position = st.position
				station_model.set_meta("information_board", true)
				station_model.set_meta("ticket_terminal", true)
				add_child(station_model)
		else:
			station_model = _add_model(st.model, st.position, Vector3(2.5, 2.5, 2.5), self, true)
		if station_model != null and String(st.model).to_lower().contains("chest.glb"):
			station_model.set_meta("non_information_chest", true)
		_add_glow_marker(st.position + Vector3(0, 1.8, 0))
		st["question"] = i
		stations[i] = st
	_add_box("WorldNorthBoundary", Vector3(WORLD_LENGTH * 0.5, 1.0, -15.25), Vector3(WORLD_LENGTH, 2, 0.5), Color.BLACK, true, false)
	_add_box("WorldSouthBoundary", Vector3(WORLD_LENGTH * 0.5, 1.0, 15.25), Vector3(WORLD_LENGTH, 2, 0.5), Color.BLACK, true, false)
	_add_box("WorldStartBoundary", Vector3(-2.0, 1.0, 0), Vector3(0.5, 2, ZONE_WIDTH), Color.BLACK, true, false)
	_add_box("WorldEndBoundary", Vector3(WORLD_LENGTH + 2.0, 1.0, 0), Vector3(0.5, 2, ZONE_WIDTH), Color.BLACK, true, false)

func _npc_specs() -> Array[Dictionary]:
	return [
		{"name":"Guardia_01", "position":Vector3(8.0, 0, 0), "dialogue":"Busca quién publicó el dato y comprueba la fuente original."},
		{"name":"Guardia_02", "position":Vector3(19.0, 0, 0), "dialogue":"Revisa la fecha para saber si la información sigue vigente."},
		{"name":"Guardia_03", "position":Vector3(30.0, 0, 0), "dialogue":"Compara las cifras con documentos públicos."},
		{"name":"Guardia_04", "position":Vector3(43.0, 0, 6.0), "dialogue":"Pregunta cuántas personas participaron en la encuesta."},
		{"name":"Guardia_05", "position":Vector3(58.0, 0, 0), "dialogue":"Cuando recojas una carta, llévala al tablón de información antes de buscar la siguiente."}
	]

func _build_editor_npcs() -> void:
	var scene_root := get_tree().edited_scene_root
	if scene_root == null:
		return
	for spec in _npc_specs():
		var npc_name := String(spec.name)
		var npc := get_node_or_null(NodePath(npc_name)) as Node3D
		if npc == null:
			npc = _add_model(CHARACTERS + "character-knight.glb", spec.position, Vector3(1.55, 1.55, 1.55), self)
			if npc == null:
				push_warning("No pude cargar el guardia editable " + npc_name)
				continue
			npc.name = npc_name
			npc.rotation.y = -PI * 0.5
			npc.set_meta("npc_dialogue", String(spec.dialogue))
			_set_scene_owners(npc, scene_root)
			npc.owner = scene_root
		# Apply the standing idle pose to both knight rigs in the imported model.
		# This changes only their skeleton pose; it never touches the editor position.
		_play_guard_idle_animations(npc)

func _play_guard_idle_animations(npc: Node3D) -> AnimationPlayer:
	var primary_animator: AnimationPlayer = null
	var animations := npc.find_children("*", "AnimationPlayer", true, false)
	for candidate in animations:
		var animator := candidate as AnimationPlayer
		if animator == null:
			continue
		if primary_animator == null:
			primary_animator = animator
		var idle_name := ""
		for animation_name in animator.get_animation_list():
			if String(animation_name).to_lower().contains("idle"):
				idle_name = String(animation_name)
				break
		if idle_name.is_empty() and not animator.get_animation_list().is_empty():
			idle_name = String(animator.get_animation_list()[0])
		if idle_name.is_empty():
			continue
		var idle_animation := animator.get_animation(idle_name)
		if idle_animation != null:
			idle_animation.loop_mode = Animation.LOOP_LINEAR
		animator.play(idle_name)
		animator.seek(0.0, true)
	return primary_animator

func _setup_npcs() -> void:
	npc_targets.clear()
	npc_night_lights.clear()
	for candidate in find_children("*", "Node3D", true, false):
		var existing_npc := candidate as Node3D
		if existing_npc.scene_file_path.to_lower().contains("character-employee.glb") or existing_npc.name.to_lower().contains("character-employee"):
			existing_npc.queue_free()
	var reserved_positions: Array[Vector3] = []
	var npc_specs := _npc_specs()
	for i in range(npc_specs.size()):
		var spec: Dictionary = npc_specs[i]
		var npc_name := String(spec.name)
		var npc := get_node_or_null(NodePath(npc_name)) as Node3D
		var safe_position: Vector3
		if npc == null:
			var desired_position: Vector3 = spec.position * MAP_SCALE
			safe_position = _find_clear_guard_position(desired_position, reserved_positions)
			if safe_position.x < -900.0:
				continue
			reserved_positions.append(safe_position)
			npc = _add_model(CHARACTERS + "character-knight.glb", safe_position, Vector3(1.55, 1.55, 1.55), self)
		if npc == null:
			continue
		if npc != null and not reserved_positions.has(npc.global_position):
			reserved_positions.append(npc.global_position)
		npc.name = npc_name
		npc.rotation.y = -PI * 0.5
		npc.set_meta("npc_dialogue", String(spec.dialogue))
		_create_npc_night_light(npc)
		var animator := _play_guard_idle_animations(npc)
		var mood_bar := _create_npc_mood_bar(npc)
		var interaction_badge := _create_npc_interaction_badge()
		npc_targets.append({"node":npc, "position":npc.global_position, "name":npc_name, "mood":1.0, "seconds_left":npc_mood_duration, "recharging":false, "recharge_elapsed":0.0, "animator":animator, "bar":mood_bar, "interaction_badge":interaction_badge, "index":i})

func _setup_fraud_case_npcs() -> void:
	fraud_guard_nodes.clear()
	for guard_name in ["Guardia_06", "Guardia_07"]:
		var guard := get_node_or_null(NodePath(guard_name)) as Node3D
		if guard != null:
			fraud_guard_nodes[guard_name] = guard
			guard.set_meta("fraud_case_guard", true)
			guard.set_meta("npc_dialogue", "Vecino de guardia. Tiene una historia que contar.")
	_start_guardia_06_concern_animation()

func _start_guardia_06_concern_animation() -> void:
	# Guardia 6 starts the match visibly uneasy; keep his concern animation looping.
	var guard := fraud_guard_nodes.get("Guardia_06") as Node3D
	if guard == null:
		return
	var found_animation := false
	for candidate in guard.find_children("*", "AnimationPlayer", true, false):
		var animator := candidate as AnimationPlayer
		if animator == null:
			continue
		var concern_name := ""
		for animation_name in animator.get_animation_list():
			var normalized_name := String(animation_name).to_lower()
			if normalized_name in ["worried", "concern", "emote-no", "emote_no"]:
				concern_name = String(animation_name)
				if normalized_name in ["worried", "concern"]:
					break
		if concern_name.is_empty():
			continue
		var concern_animation := animator.get_animation(concern_name)
		if concern_animation == null:
			continue
		concern_animation.loop_mode = Animation.LOOP_LINEAR
		animator.speed_scale = 0.8
		animator.play(concern_name, 0.12)
		found_animation = true
	if not found_animation:
		push_warning("Guardia 6 no tiene una animación de preocupación disponible.")

func _setup_guardia_07_writer() -> void:
	# Guardia 7 is the letter writer; preserve the map-authored position.
	var writer := fraud_guard_nodes.get("Guardia_07") as Node3D
	if writer == null:
		return
	# Face the writing surface while preserving the map-authored position.
	writer.rotation.y = 0.85 + PI
	_play_guard_idle_animations(writer)
	_attach_writing_quill(writer)
	for candidate in writer.find_children("*", "AnimationPlayer", true, false):
		var animator := candidate as AnimationPlayer
		if animator == null:
			continue
		var writing_animation_name := ""
		for animation_name in animator.get_animation_list():
			if String(animation_name).to_lower() == "interact-right":
				writing_animation_name = String(animation_name)
				break
		if writing_animation_name.is_empty():
			continue
		var writing_animation := animator.get_animation(writing_animation_name)
		if writing_animation != null:
			writing_animation.loop_mode = Animation.LOOP_LINEAR
		animator.speed_scale = 0.7
		animator.play(writing_animation_name, 0.15)

func _setup_guardia_08() -> void:
	guardian8 = get_node_or_null("Guardia_08") as Node3D
	guardian8_animators.clear()
	guardian8_jump_animation_names.clear()
	if guardian8 == null:
		push_warning("No se encontró Guardia_08 en la escena activa; su mini misión quedará deshabilitada.")
		return
	guardian8_home_position = guardian8.global_position
	for candidate in guardian8.find_children("*", "AnimationPlayer", true, false):
		var animator := candidate as AnimationPlayer
		if animator == null:
			continue
		var jump_name := ""
		for animation_name in animator.get_animation_list():
			if String(animation_name).to_lower().contains("jump"):
				jump_name = String(animation_name)
				break
		if not jump_name.is_empty():
			var jump_animation := animator.get_animation(jump_name)
			if jump_animation != null:
				jump_animation.loop_mode = Animation.LOOP_LINEAR
			guardian8_animators.append(animator)
			guardian8_jump_animation_names.append(jump_name)

func _setup_revolutionary_rescue() -> void:
	tied_guard_9 = get_node_or_null("Guardia_09") as Node3D
	rescue_knife = get_node_or_null("Cuchillo_Medieval") as Node3D
	if is_instance_valid(tied_guard_9):
		tied_guard_9_start_transform = tied_guard_9.global_transform
		tied_guard_9_original_transforms.clear()
		for child in tied_guard_9.get_children():
			if child is Node3D and String(child.name).begins_with("GuardiaOriginal"):
				tied_guard_9_original_transforms[String(child.name)] = child.transform
	else:
		push_warning("No se encontró Guardia_09; la misión del Revolucionario queda desactivada.")
	if is_instance_valid(rescue_knife):
		rescue_knife_start_transform = rescue_knife.global_transform
		rescue_knife.visible = true
	else:
		push_warning("No se encontró Cuchillo_Medieval; la misión del Revolucionario queda desactivada.")

func _reset_revolutionary_rescue() -> void:
	revolutionary_rescue_started = false
	revolutionary_rescue_completed = false
	revolutionary_rescue_has_knife = false
	revolutionary_knife_inspected = false
	revolutionary_rescue_animation_active = false
	revolutionary_rescue_dialogue_stage = ""
	if is_instance_valid(rescue_knife):
		if rescue_knife.get_parent() != self:
			rescue_knife.reparent(self, false)
		rescue_knife.global_transform = rescue_knife_start_transform
		rescue_knife.visible = true
		for candidate in rescue_knife.find_children("*", "CollisionObject3D", true, false):
			var collision_object := candidate as CollisionObject3D
			collision_object.collision_layer = 1
			collision_object.collision_mask = 1
	if is_instance_valid(tied_guard_9):
		tied_guard_9.global_transform = tied_guard_9_start_transform
		tied_guard_9.set_process(true)
		for child_name in tied_guard_9_original_transforms:
			var original := tied_guard_9.get_node_or_null(NodePath(String(child_name))) as Node3D
			if original != null:
				original.transform = tied_guard_9_original_transforms[child_name]
		for candidate in tied_guard_9.find_children("*", "Node3D", true, false):
			if String(candidate.name).to_lower().contains("sogas"):
				(candidate as Node3D).visible = true
		if tied_guard_9.has_method("restaurar_suspension"):
			tied_guard_9.call("restaurar_suspension")

func _start_guardia_08_hop() -> void:
	guardian8_bob_elapsed = 0.0
	for index in range(mini(guardian8_animators.size(), guardian8_jump_animation_names.size())):
		var animator := guardian8_animators[index]
		if is_instance_valid(animator):
			animator.speed_scale = 0.82
			animator.play(guardian8_jump_animation_names[index])

func _update_guardia_08_hop(delta: float) -> void:
	if guardian8 == null or not is_instance_valid(guardian8):
		return
	if guardian8_mission_completed:
		guardian8.global_position = guardian8_home_position
		return
	guardian8_bob_elapsed += delta
	# Keep the loop small and in place: it reads as an anxious bounce, without
	# animating a fall or moving the character toward an edge.
	guardian8.global_position = guardian8_home_position + Vector3.UP * absf(sin(guardian8_bob_elapsed * TAU * 0.85)) * 0.18

func _play_guard_concern_animation(guard: Node3D) -> void:
	if guard == null or not is_instance_valid(guard):
		return
	var animators: Array[AnimationPlayer] = []
	var longest_duration := 0.0
	for candidate in guard.find_children("*", "AnimationPlayer", true, false):
		var animator := candidate as AnimationPlayer
		if animator == null:
			continue
		var concern_name := ""
		for animation_name in animator.get_animation_list():
			if String(animation_name).to_lower() in ["emote-no", "emote_no", "worried", "concern"]:
				concern_name = String(animation_name)
				break
		if concern_name.is_empty():
			continue
		var concern_animation := animator.get_animation(concern_name)
		if concern_animation == null:
			continue
		concern_animation.loop_mode = Animation.LOOP_NONE
		animator.speed_scale = 0.8
		animator.play(concern_name, 0.12)
		animators.append(animator)
		longest_duration = maxf(longest_duration, concern_animation.length / 0.8)
	if animators.is_empty():
		_play_guard_idle_animations(guard)
		return
	await get_tree().create_timer(longest_duration).timeout
	for animator in animators:
		if not is_instance_valid(animator):
			continue
		animator.speed_scale = 1.0
		for animation_name in animator.get_animation_list():
			if String(animation_name).to_lower().contains("idle"):
				animator.play(String(animation_name), 0.12)
				break

func _attach_writing_quill(writer: Node3D) -> void:
	var skeletons := writer.find_children("*", "Skeleton3D", true, false)
	if skeletons.is_empty():
		return
	var skeleton := skeletons[0] as Skeleton3D
	if skeleton == null or skeleton.find_bone("arm-right") < 0:
		return
	if skeleton.get_node_or_null("Pluma_en_mano") != null:
		return
	var attachment := BoneAttachment3D.new()
	attachment.name = "Pluma_en_mano"
	attachment.bone_name = "arm-right"
	skeleton.add_child(attachment)
	var pen := Node3D.new()
	pen.name = "Pluma_de_escritura"
	pen.position = Vector3(-0.12, -0.09, 0.02)
	pen.rotation.z = -0.68
	attachment.add_child(pen)
	var feather_material := StandardMaterial3D.new()
	feather_material.albedo_color = Color("6b3b22")
	feather_material.roughness = 0.72
	var shaft_material := StandardMaterial3D.new()
	shaft_material.albedo_color = Color("c9923f")
	shaft_material.metallic = 0.35
	shaft_material.roughness = 0.38
	var feather_mesh := SphereMesh.new()
	feather_mesh.radius = 0.045
	feather_mesh.height = 0.19
	feather_mesh.radial_segments = 8
	feather_mesh.rings = 4
	var feather := MeshInstance3D.new()
	feather.name = "Plumon"
	feather.mesh = feather_mesh
	feather.material_override = feather_material
	feather.position = Vector3(0.015, 0.09, 0)
	feather.scale = Vector3(0.55, 1.0, 0.12)
	pen.add_child(feather)
	var shaft_mesh := CylinderMesh.new()
	shaft_mesh.top_radius = 0.006
	shaft_mesh.bottom_radius = 0.012
	shaft_mesh.height = 0.25
	shaft_mesh.radial_segments = 6
	var shaft := MeshInstance3D.new()
	shaft.name = "Varilla"
	shaft.mesh = shaft_mesh
	shaft.material_override = shaft_material
	pen.add_child(shaft)
	var tip_mesh := CylinderMesh.new()
	tip_mesh.top_radius = 0.0
	tip_mesh.bottom_radius = 0.012
	tip_mesh.height = 0.045
	tip_mesh.radial_segments = 6
	var tip := MeshInstance3D.new()
	tip.name = "Punta"
	tip.mesh = tip_mesh
	tip.material_override = shaft_material
	tip.position = Vector3(0, -0.145, 0)
	tip.rotation.z = PI
	pen.add_child(tip)

func _find_clear_guard_position(desired: Vector3, reserved_positions: Array[Vector3]) -> Vector3:
	var space := get_world_3d().direct_space_state
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.34
	capsule.height = 1.8
	var candidates: Array[Dictionary] = []
	for x_step in range(-12, 13):
		for z_step in range(-12, 13):
			var x := desired.x + float(x_step) * 0.5
			var z := desired.z + float(z_step) * 0.5
			_append_clear_guard_candidate(candidates, space, capsule, x, z, desired, reserved_positions)
	if candidates.is_empty():
		push_warning("No encontré suelo despejado en el claro del spawn para " + str(desired))
		return Vector3(-1000, -1000, -1000)
	candidates.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a.distance < b.distance)
	return candidates[0].position

func _append_clear_guard_candidate(candidates: Array[Dictionary], space: PhysicsDirectSpaceState3D, capsule: CapsuleShape3D, x: float, z: float, desired: Vector3, reserved_positions: Array[Vector3]) -> void:
	if x < 1.5 or x > ZONE_LENGTH * MAP_SCALE - 1.5 or absf(z) > ZONE_WIDTH * MAP_SCALE * 0.5 - 3.5:
		return
	var ray := PhysicsRayQueryParameters3D.create(Vector3(x, 8.0, z), Vector3(x, -1.0, z))
	ray.collision_mask = 1
	var ground := space.intersect_ray(ray)
	if ground.is_empty():
		return
	var ground_y: float = ground.position.y
	if ground_y < -0.2 or ground_y > 3.3:
		return
	if not _spawn_capsule_is_clear(space, capsule, x, z, ground_y):
		return
	var candidate := Vector3(x, ground_y + 0.03, z)
	for placed in reserved_positions:
		if Vector2(candidate.x, candidate.z).distance_to(Vector2(placed.x, placed.z)) < 2.5:
			return
	candidates.append({"position":candidate, "distance":candidate.distance_squared_to(desired)})

func _create_npc_mood_bar(npc: Node3D) -> Node3D:
	var bar_root := Node3D.new()
	bar_root.name = "MoodStatusBar"
	bar_root.position = npc.global_position + Vector3(0, 3.15, 0)
	add_child(bar_root)
	_add_npc_bar_texture(bar_root, "OrnateMoodFrame", NPC_MOOD_FRAME, Vector2(1.78, 0.60), Vector3.ZERO)
	var fill := Node3D.new()
	fill.name = "Fill"
	bar_root.add_child(fill)
	var fill_core := MeshInstance3D.new()
	fill_core.name = "FillCore"
	var fill_mesh := BoxMesh.new()
	fill_mesh.size = Vector3(NPC_MOOD_TRACK_WIDTH - NPC_MOOD_FILL_CAP_RADIUS * 2.0, NPC_MOOD_FILL_HEIGHT, 0.026)
	fill_core.mesh = fill_mesh
	var fill_material := StandardMaterial3D.new()
	fill_material.albedo_color = Color("ffd45a")
	fill_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	fill_core.material_override = fill_material
	fill_core.position.z = 0.045
	fill.add_child(fill_core)
	for cap_name in ["FillLeftCap", "FillRightCap"]:
		var cap := MeshInstance3D.new()
		cap.name = cap_name
		var cap_mesh := SphereMesh.new()
		cap_mesh.radius = NPC_MOOD_FILL_CAP_RADIUS
		cap_mesh.height = NPC_MOOD_FILL_HEIGHT
		cap.mesh = cap_mesh
		cap.material_override = fill_material
		cap.scale.z = 0.35
		cap.position.z = 0.045
		fill.add_child(cap)
	_add_npc_bar_label(bar_root, "MoodLabelShadow", "ÁNIMO · 100%", Vector3(0.018, 0.40, -0.018), 31, Color("24130c"))
	_add_npc_bar_label(bar_root, "MoodLabel", "ÁNIMO · 100%", Vector3(0, 0.42, 0.01), 31, Color("fff0bd"))
	return bar_root

func _add_npc_bar_texture(parent: Node3D, node_name: String, texture: Texture2D, size: Vector2, at: Vector3) -> MeshInstance3D:
	var frame := MeshInstance3D.new()
	frame.name = node_name
	var quad := QuadMesh.new()
	quad.size = size
	frame.mesh = quad
	var material := StandardMaterial3D.new()
	material.albedo_texture = texture
	material.albedo_color = Color.WHITE
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.billboard_mode = BaseMaterial3D.BILLBOARD_ENABLED
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	frame.material_override = material
	frame.position = at
	frame.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(frame)
	return frame

func _add_npc_bar_box(parent: Node3D, node_name: String, box_size: Vector3, at: Vector3, tint: Color, z_rotation := 0.0) -> MeshInstance3D:
	var mesh_node := MeshInstance3D.new()
	mesh_node.name = node_name
	var box := BoxMesh.new()
	box.size = box_size
	mesh_node.mesh = box
	var material := StandardMaterial3D.new()
	material.albedo_color = tint
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.roughness = 0.58
	mesh_node.material_override = material
	mesh_node.position = at
	mesh_node.rotation.z = deg_to_rad(z_rotation)
	parent.add_child(mesh_node)
	return mesh_node

func _add_npc_bar_label(parent: Node3D, node_name: String, value: String, at: Vector3, size: int, tint: Color) -> Label3D:
	var label := Label3D.new()
	label.name = node_name
	label.text = value
	label.position = at
	label.font = CARTOON_FONT
	label.font_size = size
	label.pixel_size = 0.004
	label.modulate = tint
	label.outline_size = 7
	label.outline_modulate = Color("3c2012")
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	label.no_depth_test = false
	parent.add_child(label)
	return label

func _create_npc_interaction_badge() -> Node3D:
	var badge := Node3D.new()
	badge.name = "NpcInteractionBadge"
	badge.visible = false
	add_child(badge)
	_add_npc_bar_texture(badge, "OrnateInteractionPlaque", NPC_INTERACTION_PLAQUE, Vector2(1.62, 0.66), Vector3.ZERO)
	_add_npc_bar_label(badge, "KeyLabelShadow", "E", Vector3(-0.45, -0.075, 0.045), 51, Color("8c6338"))
	_add_npc_bar_label(badge, "KeyLabel", "E", Vector3(-0.46, -0.06, 0.06), 49, Color("3b2113"))
	_add_npc_bar_label(badge, "ActionLabelShadow", "HABLAR", Vector3(0.23, -0.065, 0.035), 29, Color("3b1d0f"))
	_add_npc_bar_label(badge, "ActionLabel", "HABLAR", Vector3(0.22, -0.045, 0.055), 27, Color("fff0bd"))
	return badge

func _set_npc_badge_action(badge: Node3D, action: String) -> void:
	var label := badge.get_node_or_null("ActionLabel") as Label3D
	var label_shadow := badge.get_node_or_null("ActionLabelShadow") as Label3D
	if label == null:
		return
	label.text = action
	if label_shadow != null:
		label_shadow.text = action
	label.font_size = 22 if action.length() > 9 else 27
	if label_shadow != null:
		label_shadow.font_size = label.font_size + 2

func _update_npc_moods(delta: float) -> void:
	for key in bard_cooldowns.keys():
		bard_cooldowns[key] = maxf(0.0, float(bard_cooldowns[key]) - delta)
	var zero_mood_count := 0
	for i in range(npc_targets.size()):
		var state: Dictionary = npc_targets[i]
		var npc := state.node as Node3D
		if not is_instance_valid(npc):
			continue
		if state.recharging:
			state.recharge_elapsed = minf(float(state.recharge_elapsed) + delta, NPC_MOOD_RECHARGE_DURATION)
			state.mood = float(state.recharge_elapsed) / NPC_MOOD_RECHARGE_DURATION
			if float(state.recharge_elapsed) >= NPC_MOOD_RECHARGE_DURATION:
				state.recharging = false
				state.seconds_left = npc_mood_duration
		else:
			state.seconds_left = maxf(float(state.seconds_left) - delta, 0.0)
			state.mood = float(state.seconds_left) / npc_mood_duration
		if float(state.mood) <= 0.0:
			zero_mood_count += 1
		var bar := state.bar as Node3D
		if is_instance_valid(bar):
			bar.global_position = npc.global_position + Vector3(0, 3.15, 0)
			if camera != null:
				bar.global_rotation.y = camera.global_rotation.y
			var fill := bar.get_node_or_null("Fill") as Node3D
			if fill:
				var ratio := clampf(float(state.mood), 0.0, 1.0)
				var fill_width := NPC_MOOD_TRACK_WIDTH * ratio
				var fill_core := fill.get_node_or_null("FillCore") as MeshInstance3D
				if fill_core and fill_core.mesh is BoxMesh:
					var core_mesh := fill_core.mesh as BoxMesh
					core_mesh.size.x = maxf(fill_width - NPC_MOOD_FILL_CAP_RADIUS * 2.0, 0.001)
					fill_core.position.x = -NPC_MOOD_TRACK_WIDTH * 0.5 + fill_width * 0.5
				var left_cap := fill.get_node_or_null("FillLeftCap") as MeshInstance3D
				var right_cap := fill.get_node_or_null("FillRightCap") as MeshInstance3D
				if left_cap:
					left_cap.position.x = -NPC_MOOD_TRACK_WIDTH * 0.5 + NPC_MOOD_FILL_CAP_RADIUS
					left_cap.visible = ratio > 0.005
				if right_cap:
					right_cap.position.x = -NPC_MOOD_TRACK_WIDTH * 0.5 + fill_width - NPC_MOOD_FILL_CAP_RADIUS
					right_cap.visible = ratio > 0.06
				var material := fill.get_node_or_null("FillCore").material_override as StandardMaterial3D if fill.get_node_or_null("FillCore") != null else null
				if material:
					material.albedo_color = Color("ffd45a").lerp(Color("c77e27"), 1.0 - ratio)
			var label := bar.get_node_or_null("MoodLabel") as Label3D
			var label_shadow := bar.get_node_or_null("MoodLabelShadow") as Label3D
			if label:
				label.text = "ÁNIMO · %d%%" % roundi(float(state.mood) * 100.0)
			if label_shadow:
				label_shadow.text = "ÁNIMO · %d%%" % roundi(float(state.mood) * 100.0)
			var interaction_badge := state.get("interaction_badge") as Node3D
			if is_instance_valid(interaction_badge):
				interaction_badge.global_position = npc.global_position + Vector3(0, 2.35, 0)
				if camera != null:
					interaction_badge.global_rotation.y = camera.global_rotation.y
		npc_targets[i] = state
	if game_running and zero_mood_count >= NPC_ZERO_MOOD_DEFEAT_COUNT:
		_end_game(false, "low_morale")

func _update_bard_cheer(delta: float) -> void:
	if bard_cheer_target < 0:
		return
	if active_role != "Influencer" or influencer_has_information or not Input.is_action_pressed("interact"):
		bard_cheer_target = -1
		bard_cheer_elapsed = 0.0
		return
	var target := _nearest_interaction_target()
	if String(target.get("kind", "")) != "npc" or int(target.get("npc_index", -1)) != bard_cheer_target:
		bard_cheer_target = -1
		bard_cheer_elapsed = 0.0
		return
	if float(bard_cooldowns.get(bard_cheer_target, 0.0)) > 0.0:
		bard_cheer_target = -1
		bard_cheer_elapsed = 0.0
		return
	bard_cheer_elapsed = minf(bard_cheer_elapsed + delta, BARD_CHEER_HOLD_DURATION)
	if bard_cheer_elapsed >= BARD_CHEER_HOLD_DURATION:
		var completed_target := bard_cheer_target
		bard_cheer_target = -1
		bard_cheer_elapsed = 0.0
		_cheer_npc(completed_target, BARD_CHEER_STRENGTH)

func _update_npc_facing(delta: float) -> void:
	if player == null:
		return
	for state in npc_targets:
		var npc := state.node as Node3D
		if not is_instance_valid(npc):
			continue
		var direction := player.global_position - npc.global_position
		direction.y = 0.0
		if direction.length_squared() > 0.01 and direction.length() <= 12.0:
			# The Kenney knight models face local +Z, opposite Godot's usual -Z forward.
			var target_yaw := atan2(direction.x, direction.z)
			npc.global_rotation.y = lerp_angle(npc.global_rotation.y, target_yaw, minf(delta * 5.0, 1.0))

func _cheer_npc(npc_index: int, strength: float = 1.0) -> void:
	if npc_index < 0 or npc_index >= npc_targets.size():
		return
	var state: Dictionary = npc_targets[npc_index]
	if strength < 1.0:
		if float(bard_cooldowns.get(npc_index, 0.0)) > 0.0:
			return
		state.mood = minf(1.0, float(state.mood) + strength)
		state.seconds_left = float(state.mood) * npc_mood_duration
		state.recharging = false
		bard_cooldowns[npc_index] = BARD_CHEER_RECHARGE_DURATION
	else:
		if state.recharging:
			return
		state.recharging = true
		state.recharge_elapsed = 0.0
		cheered_npcs[npc_index] = true
	var npc := state.node as Node3D
	var animator := state.animator as AnimationPlayer
	var played_cheer := false
	if is_instance_valid(animator):
		for animation_name in animator.get_animation_list():
			var animation_key := String(animation_name).to_lower()
			if animation_key.contains("cheer") or animation_key.contains("happy") or animation_key.contains("wave") or animation_key.contains("dance"):
				animator.play(String(animation_name))
				played_cheer = true
				break
	if is_instance_valid(npc) and not played_cheer:
		var tween := create_tween()
		tween.set_loops(3)
		tween.tween_property(npc, "position:y", float(npc.position.y) + 0.3, 0.18)
		tween.tween_property(npc, "position:y", float(npc.position.y), 0.18)
	npc_targets[npc_index] = state
	_update_information_hud()
	_broadcast_coop_state()

func _setup_chest_letter() -> void:
	chest_letter = get_node_or_null("Sobre_Medieval_3D") as StaticBody3D
	if chest_letter == null:
		push_warning("No encontré el sobre medieval del spawn para usarlo como carta de los cofres.")
		return
	chest_letter_start_transform = chest_letter.global_transform
	chest_letter.collision_layer = 0
	chest_letter.collision_mask = 0
	for candidate in chest_letter.find_children("*", "CollisionShape3D", true, false):
		(candidate as CollisionShape3D).disabled = true
	chest_letter.visible = false

func _place_chest_letter_at(index: int) -> void:
	if chest_letter == null or index < 0 or index >= info_chests.size():
		return
	var chest := info_chests[index].node as Node3D
	if not is_instance_valid(chest):
		return
	var bounds := _world_visual_bounds(chest)
	var letter_position := Vector3(bounds.get_center().x, bounds.end.y + 0.36, bounds.get_center().z)
	var letter_yaw := chest.global_rotation.y + PI * 0.5
	var letter_basis := Basis(Vector3.UP, letter_yaw).scaled(Vector3.ONE * MAP_SCALE)
	if chest_letter.get_parent() != self:
		chest_letter.reparent(self, false)
	chest_letter.global_transform = Transform3D(letter_basis, letter_position)
	chest_letter.visible = true

func _pick_up_chest_letter() -> void:
	if chest_letter == null or pending_card_chest_index < 0 or hero_is_carrying_card:
		return
	chest_letter.reparent(player, false)
	chest_letter.transform = Transform3D(Basis.IDENTITY.scaled(Vector3.ONE * 0.32), Vector3(0.34, 0.82, -0.52))
	hero_is_carrying_card = true
	card_carrier_peer_id = multiplayer.get_unique_id() if multiplayer.multiplayer_peer != null else 1
	_update_information_hud()
	_broadcast_coop_state()

func _return_chest_letter_to_spawn() -> void:
	if chest_letter == null:
		return
	if chest_letter.get_parent() != self:
		chest_letter.reparent(self, false)
	chest_letter.transform = chest_letter_start_transform
	chest_letter.visible = false

func _deliver_chest_letter_to_board() -> void:
	if pending_card_chest_index < 0 or collected_info.has(pending_card_chest_index):
		return
	collected_info[pending_card_chest_index] = pending_card_clue
	answered = collected_info.size()
	hero_is_carrying_card = false
	card_carrier_peer_id = 0
	var delivered_count := collected_info.size()
	var earned_pages := 0
	for threshold in INFORMATION_BOARD_PAGE_THRESHOLDS:
		if delivered_count >= threshold:
			earned_pages += 1
	_set_board_pages_placed(earned_pages)
	info_delivered = earned_pages >= INFORMATION_BOARD_PAGE_THRESHOLDS.size()
	_return_chest_letter_to_spawn()
	if info_delivered:
		panel_text.text = "✓   CARTA ENTREGADA · TABLÓN COMPLETO\n\nYa colocaste las 10 cartas, una por una. El Mensajero puede recoger el expediente y llevarlo al escritorio de investigación."
	elif earned_pages > 0 and delivered_count in INFORMATION_BOARD_PAGE_THRESHOLDS:
		panel_text.text = "✓   CARTA COLOCADA\n\nLa hoja %d de 3 apareció en el tablón. Cartas entregadas: %d / %d." % [earned_pages, delivered_count, REQUIRED_INFO_CHESTS]
	else:
		panel_text.text = "✓   CARTA COLOCADA\n\nCartas entregadas: %d / %d. Vuelve a un cofre para abrirlo y recoger la siguiente." % [delivered_count, REQUIRED_INFO_CHESTS]
	pending_card_chest_index = -1
	pending_card_clue = ""
	panel.visible = true
	_update_information_hud()
	_broadcast_coop_state()

func _discover_information_chests() -> void:
	info_chests.clear()
	chest_lights.clear()
	chest_proximity_players.clear()
	var candidates := find_children("*", "Node3D", true, false)
	for candidate in candidates:
		var chest := candidate as Node3D
		var path_is_chest := chest.scene_file_path.to_lower().contains("chest.glb")
		var named_chest := chest.name.to_lower().begins_with("chest") and not chest.find_children("*", "MeshInstance3D", true, false).is_empty()
		var has_chest_ancestor := false
		var ancestor := chest.get_parent()
		while ancestor:
			if ancestor is Node3D and (ancestor as Node3D).scene_file_path.to_lower().contains("chest.glb"):
				has_chest_ancestor = true
				break
			ancestor = ancestor.get_parent()
		if has_chest_ancestor:
			continue
		if path_is_chest or named_chest:
			_setup_chest_proximity_sound(chest)
		if chest.get_meta("non_information_chest", false):
			continue
		elif chest.get_meta("trap_chest", false):
			_setup_chest_glow(chest)
		elif path_is_chest or named_chest:
			# Every chest stays in the world each match. Its invisible light anchor is
			# attached regardless of whether this chest has already been opened.
			info_chests.append({"node":chest, "position":chest.global_position, "name":String(chest.name)})
			_setup_chest_glow(chest)
	info_chests.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a.position.x < b.position.x)
	# Build the sound list after the final chest order is known so its indexes
	# continue to match the information collected by each chest.
	for index in range(info_chests.size()):
		var chest := info_chests[index].node as Node3D
		for chest_info in chest_proximity_players:
			if chest_info.node == chest:
				chest_info.index = index
				break

func _setup_chest_proximity_sound(chest: Node3D) -> void:
	if chest == null or chest_near_stream == null:
		return
	var sound := chest.get_node_or_null("ChestProximitySoundPlayer") as AudioStreamPlayer3D
	if sound == null:
		sound = AudioStreamPlayer3D.new()
		sound.name = "ChestProximitySoundPlayer"
		sound.volume_db = -12.0
		sound.unit_size = 4.0
		sound.max_distance = CHEST_PROXIMITY_RANGE
		sound.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
		chest.add_child(sound)
	sound.stream = chest_near_stream
	if not chest_proximity_players.any(func(item: Dictionary) -> bool: return item.node == chest):
		chest_proximity_players.append({"node":chest, "player":sound, "index":-1})

func _update_chest_proximity_audio() -> void:
	if not is_instance_valid(player):
		_stop_all_chest_proximity_sounds()
		return
	for chest_info in chest_proximity_players:
		var chest := chest_info.node as Node3D
		var sound := chest_info.player as AudioStreamPlayer3D
		if not is_instance_valid(chest) or not is_instance_valid(sound):
			continue
		var chest_index := int(chest_info.index)
		var chest_is_open: bool = bool(chest.get_meta("chest_sound_opened", false)) or collected_info.has(chest_index)
		var close_enough := player.global_position.distance_to(chest.global_position) <= CHEST_PROXIMITY_RANGE
		if chest_is_open or not close_enough:
			if sound.playing:
				sound.stop()
		elif not sound.playing:
			sound.play()

func _stop_all_chest_proximity_sounds() -> void:
	for chest_info in chest_proximity_players:
		var sound := chest_info.get("player") as AudioStreamPlayer3D
		if is_instance_valid(sound) and sound.playing:
			sound.stop()

func _stop_chest_proximity_sound(chest: Node3D) -> void:
	if chest == null:
		return
	chest.set_meta("chest_sound_opened", true)
	var sound := chest.get_node_or_null("ChestProximitySoundPlayer") as AudioStreamPlayer3D
	if sound != null and sound.playing:
		sound.stop()

func _chest_id(chest: Node3D) -> String:
	return String(chest.get_path())

func _setup_chest_glow(chest: Node3D) -> void:
	var bounds := _world_visual_bounds(chest)
	# Place the invisible light just above the lid; the anchor has no rendered mesh.
	var chest_top := Vector3(bounds.get_center().x, bounds.end.y + maxf(0.08, bounds.size.y * 0.025), bounds.get_center().z)
	var glow := _add_embedded_glow(chest, chest_top, Color("f2d276"), maxf(18.0, bounds.size.length() * 1.5), 0.3)
	chest_lights.append(glow)

func _save_opened_chest(index: int) -> void:
	var save := ConfigFile.new()
	save.load(CHEST_PROGRESS_PATH)
	var opened: Array = save.get_value("progress", "opened_chests", [])
	var chest := info_chests[index].node as Node3D
	var chest_id := _chest_id(chest)
	if not opened.has(chest_id):
		opened.append(chest_id)
	save.set_value("progress", "opened_chests", opened)
	save.save(CHEST_PROGRESS_PATH)

func _find_ticket_terminal() -> void:
	var candidates := find_children("*", "Node3D", true, false)
	for candidate in candidates:
		var node := candidate as Node3D
		if bool(node.get_meta("ticket_terminal", false)) or bool(node.get_meta("information_board", false)):
			ticket_terminal_position = node.global_position
			return
	if not stations.is_empty():
		ticket_terminal_position = stations[0].position

func _find_research_desk() -> void:
	var desk := get_node_or_null("Escritorio_Investigacion") as Node3D
	if desk == null:
		for candidate in find_children("*", "Node3D", true, false):
			var node := candidate as Node3D
			if bool(node.get_meta("research_desk", false)) or node.name.to_lower().contains("escritorio_investigacion"):
				desk = node
				break
	if desk != null:
		research_desk_position = desk.global_position

func _find_roulette() -> void:
	roulette_wheels.clear()
	roulette_tick_stream = _make_roulette_tick_stream()
	# These are the two colorful spinning discs placed in the editable map.
	# The nearby prize2/prize3 meshes are their stationary bases and stay still.
	for wheel_id in ["rotate-z2", "rotate-z3"]:
		var wheel := get_node_or_null(NodePath(wheel_id)) as MeshInstance3D
		if not is_instance_valid(wheel) or wheel.mesh == null:
			continue
		var wheel_bounds := _world_visual_bounds(wheel)
		var wheel_position := wheel_bounds.get_center()
		var radius := maxf(4.2, wheel_bounds.size.length() * 0.65)
		_enable_roulette_emission(wheel)
		_add_world_glow(wheel_position, Color("ffd45a"), maxf(8.0, wheel_bounds.size.length() * 0.9), 1.7)
		roulette_wheels.append({
			"id": wheel_id,
			"node": wheel,
			"position": wheel_position,
			"range": radius
		})
	# Keep compatibility with a project copy that still uses the imported model name.
	if roulette_wheels.is_empty():
		var fallback := get_node_or_null("prize-wheel2") as Node3D
		if fallback == null:
			for candidate in find_children("*", "Node3D", true, false):
				var node := candidate as Node3D
				if node.scene_file_path.to_lower().contains("prize-wheel.glb") or node.name.to_lower().contains("prize-wheel"):
					fallback = node
					break
		if is_instance_valid(fallback):
			var fallback_bounds := _world_visual_bounds(fallback)
			var fallback_position := fallback_bounds.get_center()
			_enable_roulette_emission(fallback)
			_add_world_glow(fallback_position, Color("ffd45a"), maxf(8.0, fallback_bounds.size.length() * 0.9), 1.7)
			roulette_wheels.append({"id":"prize-wheel", "node":fallback, "position":fallback_position, "range":5.0})

func _make_roulette_tick_stream() -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	stream.mix_rate = 22050
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.stereo = false
	var frame_count := 1102
	var samples := PackedByteArray()
	samples.resize(frame_count * 2)
	for frame in range(frame_count):
		var t := float(frame) / float(stream.mix_rate)
		var envelope := exp(-t * 55.0)
		var sample := int(sin(TAU * 1450.0 * t) * envelope * 7800.0)
		samples.encode_s16(frame * 2, sample)
	stream.data = samples
	return stream

func _world_visual_bounds(root: Node3D) -> AABB:
	var found := false
	var min_corner := Vector3.ZERO
	var max_corner := Vector3.ZERO
	var mesh_candidates := root.find_children("*", "MeshInstance3D", true, false)
	if root is MeshInstance3D:
		mesh_candidates.append(root)
	for candidate in mesh_candidates:
		var mesh_instance := candidate as MeshInstance3D
		if mesh_instance.mesh == null:
			continue
		var local_bounds := mesh_instance.get_aabb()
		for x in [local_bounds.position.x, local_bounds.end.x]:
			for y in [local_bounds.position.y, local_bounds.end.y]:
				for z in [local_bounds.position.z, local_bounds.end.z]:
					var corner := mesh_instance.global_transform * Vector3(x, y, z)
					if not found:
						min_corner = corner
						max_corner = corner
						found = true
					else:
						min_corner = min_corner.min(corner)
						max_corner = max_corner.max(corner)
	if not found:
		return AABB(root.global_position, Vector3.ZERO)
	return AABB(min_corner, max_corner - min_corner)

func _enable_roulette_emission(root: Node3D) -> void:
	for candidate in root.find_children("*", "MeshInstance3D", true, false):
		var mesh_instance := candidate as MeshInstance3D
		if mesh_instance.mesh == null:
			continue
		for surface in range(mesh_instance.mesh.get_surface_count()):
			var source := mesh_instance.get_active_material(surface)
			if not source is StandardMaterial3D:
				continue
			var glowing_material := (source as StandardMaterial3D).duplicate() as StandardMaterial3D
			glowing_material.emission_enabled = true
			if glowing_material.albedo_texture != null:
				glowing_material.emission_texture = glowing_material.albedo_texture
				glowing_material.emission = Color("b4f2ff")
			else:
				glowing_material.emission = glowing_material.albedo_color.lerp(Color("55ddff"), 0.25)
			glowing_material.emission_energy_multiplier = 0.38
			mesh_instance.set_surface_override_material(surface, glowing_material)

func _add_world_glow(at: Vector3, tint: Color, radius: float, brightness: float) -> OmniLight3D:
	var glow := OmniLight3D.new()
	glow.light_color = tint
	glow.light_energy = brightness
	glow.omni_range = radius
	glow.omni_attenuation = 0.22
	glow.light_cull_mask = 0xffffffff
	glow.distance_fade_enabled = false
	glow.shadow_enabled = false
	# This is a world-space lamp; its state never depends on camera direction.
	glow.visible = true
	add_child(glow)
	glow.global_position = at
	return glow

func _add_embedded_glow(owner: Node3D, at_global: Vector3, tint: Color, radius: float, attenuation: float) -> OmniLight3D:
	# A Node3D has no rendered geometry: this invisible anchor stays inside its
	# owner, while the OmniLight child emits in every direction when enabled.
	var invisible_orb := Node3D.new()
	invisible_orb.name = "InvisibleGlowOrb"
	owner.add_child(invisible_orb)
	invisible_orb.position = owner.to_local(at_global)
	var glow := OmniLight3D.new()
	glow.name = "EmbeddedOmniLight"
	glow.light_color = tint
	glow.light_energy = 0.0
	glow.omni_range = radius
	glow.omni_attenuation = attenuation
	glow.light_cull_mask = 0xffffffff
	glow.distance_fade_enabled = false
	glow.shadow_enabled = false
	glow.visible = false
	invisible_orb.add_child(glow)
	return glow

func _create_npc_night_light(npc: Node3D) -> void:
	var npc_bounds := _world_visual_bounds(npc)
	# Keep the invisible blue light close above the head; the anchor follows the NPC.
	var head_top := Vector3(npc_bounds.get_center().x, npc_bounds.end.y + maxf(0.08, npc_bounds.size.y * 0.025), npc_bounds.get_center().z)
	var glow := _add_embedded_glow(npc, head_top, Color("83aaff"), 24.0, 0.28)
	npc_night_lights.append(glow)

func _setup_fireflies() -> void:
	firefly_lights.clear()
	firefly_orbs.clear()
	firefly_nodes.clear()
	var positions: Array[Vector3] = []
	var positions_with_light: Array[bool] = []
	# A few scattered lights keep the paths readable while the clusters make the
	# dark corners feel intentional instead of evenly dotted across the floor.
	for index in range(15):
		var x := 8.0 + float(index) * ((WORLD_LENGTH * MAP_SCALE - 16.0) / 14.0)
		var z := -8.0 if index % 2 == 0 else 8.0
		var y := 2.2 + float((index * 7) % 16) * 0.24
		positions.append(Vector3(x, y, z))
		positions_with_light.append(index % 3 == 0)

	for zone in range(3):
		for side_index in range(2):
			var side := -1.0 if side_index == 0 else 1.0
			var center_x := (float(zone) * ZONE_LENGTH + (17.0 if side_index == 0 else 54.0)) * MAP_SCALE
			for point_index in range(4):
				var angle := TAU * float(point_index) / 4.0 + float(zone) * 0.6
				var radius := 1.4 + float(point_index % 2) * 0.55
				var height := 2.0 + float(point_index) * 1.45
				positions.append(Vector3(center_x + cos(angle) * radius, height, side * (12.0 + sin(angle) * radius)))
				positions_with_light.append(point_index == 0)

	var tree_roots: Array[Node3D] = []
	for candidate in find_children("*", "Node3D", true, false):
		var tree_root := candidate as Node3D
		if tree_root.scene_file_path.to_lower().contains("tree.glb"):
			tree_roots.append(tree_root)
		elif tree_root is MeshInstance3D and tree_root.name.to_lower().contains("tree") and (tree_root as MeshInstance3D).mesh != null and not _has_tree_scene_ancestor(tree_root):
			tree_roots.append(tree_root)
	tree_roots.sort_custom(func(a: Node3D, b: Node3D) -> bool: return a.global_position.x < b.global_position.x)
	var valid_tree_roots: Array[Node3D] = []
	var tree_bounds: Array[AABB] = []
	for tree in tree_roots:
		var bounds := _world_visual_bounds(tree)
		if bounds.size.length() < 0.1:
			continue
		valid_tree_roots.append(tree)
		tree_bounds.append(bounds)
	tree_roots = valid_tree_roots
	for tree_index in range(tree_roots.size()):
		var bounds := tree_bounds[tree_index]
		var tree_center := bounds.get_center()
		var tree_height := bounds.size.y
		var nearby_trees := 0
		for other_index in range(tree_roots.size()):
			if other_index == tree_index:
				continue
			var other_bounds := tree_bounds[other_index]
			var dx := bounds.get_center().x - other_bounds.get_center().x
			var dz := bounds.get_center().z - other_bounds.get_center().z
			var spacing := sqrt(dx * dx + dz * dz)
			var touch_distance := maxf(4.5, (maxf(bounds.size.x, bounds.size.z) + maxf(other_bounds.size.x, other_bounds.size.z)) * 0.3)
			if spacing < touch_distance:
				nearby_trees += 1
		# Keep three vertical points around isolated trees and reduce to top/bottom
		# in tight clusters so the grove stays readable without thousands of nodes.
		var firefly_count := 2 if nearby_trees >= 2 else 3
		var radius := maxf(1.0, maxf(bounds.size.x, bounds.size.z) * 0.38)
		for point_index in range(firefly_count):
			var angle := TAU * float(point_index) / float(firefly_count) + float(tree_index) * 0.41
			# Rotate through low, middle, and high points around the tree.
			var level := point_index if firefly_count == 3 else (0 if point_index == 0 else 2)
			var height_fraction: float = [0.18, 0.53, 0.88][level]
			var height := lerpf(bounds.position.y + 0.25, bounds.end.y - 0.25, height_fraction)
			positions.append(Vector3(tree_center.x + cos(angle) * radius, height, tree_center.z + sin(angle) * radius))
			# A small subset emit light; most remain decorative emissive orbs.
			positions_with_light.append(tree_index % 4 == 0 and point_index == 0)

	for index in range(positions.size()):
		_create_firefly(index, positions[index], positions_with_light[index])

func _has_tree_scene_ancestor(node: Node) -> bool:
	var ancestor := node.get_parent()
	while ancestor != null:
		if ancestor.scene_file_path.to_lower().contains("tree.glb"):
			return true
		ancestor = ancestor.get_parent()
	return false

func _create_firefly(index: int, base_position: Vector3, make_light: bool) -> void:
	var firefly := Node3D.new()
	firefly.name = "Firefly_%02d" % index
	add_child(firefly)
	firefly.global_position = base_position
	firefly.set_meta("base_position", base_position)
	firefly.set_meta("phase_offset", float(index) * 0.73)

	var orb := MeshInstance3D.new()
	orb.name = "FireflyOrb"
	var orb_mesh := SphereMesh.new()
	orb_mesh.radius = 0.095
	orb_mesh.height = 0.19
	orb.mesh = orb_mesh
	var orb_material := StandardMaterial3D.new()
	orb_material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	orb_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	orb_material.albedo_color = Color("d9ff9c", 0.0)
	orb_material.emission_enabled = true
	orb_material.emission = Color("caff82")
	orb_material.emission_energy_multiplier = 0.0
	orb.material_override = orb_material
	orb.visible = false
	firefly.add_child(orb)
	firefly_orbs.append(orb)
	firefly_nodes.append(firefly)

	if make_light and firefly_lights.size() < 36:
		var glow := OmniLight3D.new()
		glow.name = "FireflyGlow"
		glow.light_color = Color("caff91")
		glow.light_energy = 0.0
		glow.omni_range = 5.5
		glow.shadow_enabled = false
		firefly.add_child(glow)
		firefly_lights.append(glow)

func _animate_fireflies(delta: float) -> void:
	firefly_update_accumulator += delta
	if firefly_update_accumulator < FIREFLY_UPDATE_INTERVAL:
		return
	var animation_delta := minf(firefly_update_accumulator, 0.1)
	firefly_update_accumulator = fmod(firefly_update_accumulator, FIREFLY_UPDATE_INTERVAL)
	firefly_time += animation_delta
	for index in range(firefly_nodes.size()):
		var firefly := firefly_nodes[index]
		if not is_instance_valid(firefly):
			continue
		var base_position: Vector3 = firefly.get_meta("base_position", firefly.position)
		var offset := float(firefly.get_meta("phase_offset", 0.0))
		firefly.position = base_position + Vector3(sin(firefly_time * 0.8 + offset) * 0.32, sin(firefly_time * 1.7 + offset) * 0.22, cos(firefly_time * 0.65 + offset) * 0.28)
		var night_amount := 0.0
		if day_sky != null:
			night_amount = float(day_sky.get_shader_parameter("night_amount"))
		var visibility := smoothstep(0.015, 0.72, night_amount)
		var flutter := 0.88 + 0.12 * (0.5 + 0.5 * sin(firefly_time * 2.0 + offset))
		var glow := firefly.get_node_or_null("FireflyGlow") as OmniLight3D
		if glow != null:
			glow.visible = lights_enabled and night_amount > 0.005
			glow.light_energy = night_amount * 0.22 * flutter if lights_enabled else 0.0
		if index < firefly_orbs.size() and is_instance_valid(firefly_orbs[index]):
			var orb := firefly_orbs[index]
			orb.visible = lights_enabled and night_amount > 0.005
			var orb_material := orb.material_override as StandardMaterial3D
			if orb_material != null:
				orb_material.albedo_color.a = visibility if lights_enabled else 0.0
				orb_material.emission_energy_multiplier = night_amount * 1.2 if lights_enabled else 0.0

func _setup_day_night_cycle() -> void:
	var lights := find_children("*", "DirectionalLight3D", true, false)
	if not lights.is_empty():
		sun_light = lights[0] as DirectionalLight3D
	var environments := find_children("*", "WorldEnvironment", true, false)
	if not environments.is_empty():
		day_environment = (environments[0] as WorldEnvironment).environment
		if day_environment != null:
			# Apply this to the saved scene's environment too; the editor-built scene
			# can have an Environment resource that predates the runtime glow setup.
			day_environment.glow_enabled = true
			day_environment.glow_intensity = 0.65
			day_environment.glow_bloom = 0.08
			if day_environment.sky != null:
				day_sky = ShaderMaterial.new()
				day_sky.shader = load("res://scripts/dynamic_sky.gdshader")
				day_sky.set_shader_parameter("zenith_color", Vector3(0.09, 0.15, 0.25))
				day_sky.set_shader_parameter("horizon_color", Vector3(0.45, 0.56, 0.67))
				day_sky.set_shader_parameter("ground_color", Vector3(0.08, 0.10, 0.17))
				day_environment.sky.sky_material = day_sky
	day_phase_presets = [
		{"sun_x":-48.0, "energy":0.24, "ambient":0.20, "ambient_color":Color("8296b2"), "top":Color("172541"), "horizon":Color("728eaa"), "ground_bottom":Color("12182b"), "ground_horizon":Color("546178"), "night":0.0},
		{"sun_x":-8.0, "energy":0.16, "ambient":0.15, "ambient_color":Color("d39683"), "top":Color("413858"), "horizon":Color("e49a73"), "ground_bottom":Color("211a32"), "ground_horizon":Color("72516a"), "night":0.0},
		{"sun_x":18.0, "energy":0.025, "ambient":0.055, "ambient_color":Color("526080"), "top":Color("070d20"), "horizon":Color("17213a"), "ground_bottom":Color("050916"), "ground_horizon":Color("10182b"), "night":1.0}
	]
	day_cycle_elapsed = 0.0
	_apply_day_phase(day_phase_presets[0], day_phase_presets[0], 0.0)

func _update_day_night_cycle(delta: float) -> void:
	if day_phase_presets.size() < 3:
		return
	day_cycle_elapsed = fposmod(day_cycle_elapsed + delta, DAY_PHASE_DURATION * 3.0)
	var phase_index := int(day_cycle_elapsed / DAY_PHASE_DURATION)
	var next_index := (phase_index + 1) % day_phase_presets.size()
	var phase_progress := fposmod(day_cycle_elapsed, DAY_PHASE_DURATION) / DAY_PHASE_DURATION
	_apply_day_phase(day_phase_presets[phase_index], day_phase_presets[next_index], phase_progress)

func _apply_day_phase(from_phase: Dictionary, to_phase: Dictionary, progress: float) -> void:
	if is_instance_valid(sun_light):
		sun_light.rotation_degrees.x = lerpf(float(from_phase.sun_x), float(to_phase.sun_x), progress)
		sun_light.light_energy = lerpf(float(from_phase.energy), float(to_phase.energy), progress)
	if day_environment != null:
		day_environment.ambient_light_energy = lerpf(float(from_phase.ambient), float(to_phase.ambient), progress)
		day_environment.ambient_light_color = from_phase.ambient_color.lerp(to_phase.ambient_color, progress)
	if day_sky != null:
		var zenith: Color = from_phase.top.lerp(to_phase.top, progress)
		var horizon: Color = from_phase.horizon.lerp(to_phase.horizon, progress)
		var ground: Color = from_phase.ground_bottom.lerp(to_phase.ground_bottom, progress)
		day_sky.set_shader_parameter("zenith_color", Vector3(zenith.r, zenith.g, zenith.b))
		day_sky.set_shader_parameter("horizon_color", Vector3(horizon.r, horizon.g, horizon.b))
		day_sky.set_shader_parameter("ground_color", Vector3(ground.r, ground.g, ground.b))
		day_sky.set_shader_parameter("night_amount", lerpf(float(from_phase.night), float(to_phase.night), progress))
	# Reuse the exact night ramp used by fireflies. Guard and chest lights stay
	# completely off until fireflies begin appearing, then fade out with them.
	var night_amount := 0.0
	if day_sky != null:
		night_amount = float(day_sky.get_shader_parameter("night_amount"))
	var lights_active := lights_enabled and night_amount > 0.005
	var light_flutter := 0.88 + 0.12 * (0.5 + 0.5 * sin(firefly_time * 2.0))
	# All invisible NPC/chest orbs start on the exact same dusk threshold as the
	# visible fireflies and smoothly grow with their shared night ramp.
	var shared_light_energy := night_amount * 0.26 * light_flutter if lights_active else 0.0
	for glow in npc_night_lights:
		if is_instance_valid(glow):
			glow.visible = lights_active
			glow.light_energy = shared_light_energy
	for glow in chest_lights:
		if is_instance_valid(glow):
			glow.visible = lights_active
			glow.light_energy = shared_light_energy

func _build_continuous_zone(zone: int, start_x: float) -> void:
	var floor_path: String = [DUNGEON + "floor.glb", ARENA + "floor.glb", ARCADE + "floor.glb"][zone]
	var detail_path: String = [DUNGEON + "floor-detail.glb", ARENA + "floor-detail.glb", DUNGEON + "stones.glb"][zone]
	var floor_color: Color = [Color("786b68"), Color("c99b79"), Color("64657e")][zone]
	var zone_center := start_x + ZONE_LENGTH * 0.5
	# Three 72 m districts touch directly; each has its own detailed, traversable layout.
	if zone == 0:
		_add_box("DungeonFloorWest", Vector3(start_x + 23, -0.3, 0), Vector3(46, 0.6, ZONE_WIDTH), floor_color, true, false)
		_add_box("DungeonFloorEast", Vector3(start_x + 62, -0.3, 0), Vector3(20, 0.6, ZONE_WIDTH), floor_color, true, false)
	else:
		_add_box("ZoneFloor%d" % zone, Vector3(zone_center, -0.3, 0), Vector3(ZONE_LENGTH, 0.6, ZONE_WIDTH), floor_color, true, false)
	for ix in range(36):
		for iz in range(15):
			var tile_pos := Vector3(start_x + 1 + ix * 2, 0.015, -14 + iz * 2)
			# The first district has a real six-metre canal, crossed by its timber bridge.
			if zone == 0 and tile_pos.x >= start_x + 47 and tile_pos.x <= start_x + 53:
				continue
			_add_model(floor_path, tile_pos, Vector3(2, 1, 2), self)
			if (ix * 17 + iz * 11 + zone * 7) % 43 == 0:
				_add_model(detail_path, tile_pos + Vector3(0, 0.03, 0), Vector3(1.1, 1.1, 1.1), self)
	# Stone/ruin perimeter is built from the supplied wall tiles and has mesh collision.
	var border_path: String = [DUNGEON + "wall-half.glb", ARENA + "border-straight.glb", ARCADE + "wall.glb"][zone]
	for i in range(36):
		var border_x := start_x + 1 + i * 2
		_add_model(border_path, Vector3(border_x, 0, -14), Vector3(2, 2, 2), self, true)
		_add_model(border_path, Vector3(border_x, 0, 14), Vector3(2, 2, 2), self, true)
	match zone:
		0: _build_dungeon_layout(start_x)
		1: _build_arena_maze(start_x)
		2: _build_arcade_hall(start_x)

func _build_environment_dressing() -> void:
	# Keep these hand-placed additions grouped so they are easy to find and move
	# in the editor. Positions stay in the unscaled level coordinate system.
	if has_node("EnvironmentDressing"):
		return
	var dressing := Node3D.new()
	dressing.name = "EnvironmentDressing"
	add_child(dressing)
	dressing.owner = self if Engine.is_editor_hint() else null

	var trees := [
		{"name":"DungeonPine_01", "at":Vector3(21, 0, -10.5), "scale":2.0},
		{"name":"DungeonPine_02", "at":Vector3(37, 0, 10.5), "scale":1.8},
		{"name":"DungeonPine_03", "at":Vector3(65, 0, -10.5), "scale":2.1},
		{"name":"ArenaPine_01", "at":Vector3(80, 0, -10.5), "scale":2.0},
		{"name":"ArenaPine_02", "at":Vector3(96, 0, 10.5), "scale":1.8},
		{"name":"ArenaPine_03", "at":Vector3(113, 0, -10.5), "scale":2.1},
		{"name":"ArenaPine_04", "at":Vector3(138, 0, 10.5), "scale":1.9},
		{"name":"ArcadePlanterTree_01", "at":Vector3(151, 0, 10.7), "scale":1.55},
		{"name":"ArcadePlanterTree_02", "at":Vector3(210, 0, -10.7), "scale":1.55}
	]
	for tree_spec in trees:
		var tree := _add_model(ARENA + "tree.glb", tree_spec.at, Vector3.ONE * float(tree_spec.scale), dressing, true)
		if tree != null:
			tree.name = String(tree_spec.name)
			_set_dressing_owner(tree)

	# Small, intentional prop groups hug walls and alcoves; they leave the main
	# walking lane, bridges, stairs, chests and arcade machines unobstructed.
	var details := [
		{"name":"DungeonRubble_01", "path":DUNGEON + "rocks.glb", "at":Vector3(25, 0, 10.2), "scale":1.6, "rotation":0.15},
		{"name":"DungeonRubble_02", "path":DUNGEON + "stones.glb", "at":Vector3(40, 0, -10.1), "scale":1.35, "rotation":0.7},
		{"name":"DungeonBarrel_01", "path":DUNGEON + "barrel.glb", "at":Vector3(17, 0, -10.4), "scale":1.65, "rotation":0.2},
		{"name":"DungeonBanner_01", "path":DUNGEON + "banner.glb", "at":Vector3(33, 0, 11.8), "scale":1.8, "rotation":0.0},
		{"name":"ArenaRubble_01", "path":DUNGEON + "rocks.glb", "at":Vector3(87, 0, 10.3), "scale":1.5, "rotation":0.45},
		{"name":"ArenaRubble_02", "path":DUNGEON + "stones.glb", "at":Vector3(124, 0, -10.2), "scale":1.3, "rotation":0.9},
		{"name":"ArenaBanner_01", "path":ARENA + "banner.glb", "at":Vector3(105, 0, 11.6), "scale":1.9, "rotation":0.0},
		{"name":"ArenaBanner_02", "path":ARENA + "banner.glb", "at":Vector3(131, 0, -11.6), "scale":1.7, "rotation":PI},
		{"name":"ArcadePot_01", "path":DUNGEON + "pot.glb", "at":Vector3(164, 0, 10.4), "scale":1.4, "rotation":0.3},
		{"name":"ArcadePot_02", "path":DUNGEON + "pot.glb", "at":Vector3(190, 0, -10.4), "scale":1.4, "rotation":0.8},
		{"name":"ArcadeCrate_01", "path":DUNGEON + "wood-structure.glb", "at":Vector3(201, 0, 10.5), "scale":1.35, "rotation":0.0}
	]
	for detail in details:
		var prop := _add_model(String(detail.path), detail.at, Vector3.ONE * float(detail.scale), dressing, true, float(detail.rotation))
		if prop != null:
			prop.name = String(detail.name)
			_set_dressing_owner(prop)
	if Engine.is_editor_hint():
		dressing.owner = self

func _set_dressing_owner(node: Node) -> void:
	if not Engine.is_editor_hint():
		return
	node.owner = self
	for child in node.get_children():
		if child.name == "AssetMeshCollision":
			child.owner = self
			for collision_shape in child.get_children():
				collision_shape.owner = self

func _build_dungeon_layout(start_x: float) -> void:
	# Broken stone walls form a winding path; the intentional gaps are doorways.
	_add_wall_run_x(DUNGEON + "wall.glb", start_x + 5, 8, 9, 2.0, 1.8, [5])
	_add_wall_run_x(DUNGEON + "wall.glb", start_x + 12, -6, 12, 2.0, 1.8, [4, 9])
	_add_wall_run_x(DUNGEON + "wall-half.glb", start_x + 30, 6, 12, 2.0, 2.0, [2, 8])
	_add_wall_run_z(DUNGEON + "wall.glb", start_x + 37, -12, 13, 2.0, 1.8, [4, 5, 10])
	_add_wall_run_z(DUNGEON + "wall.glb", start_x + 56, -12, 13, 2.0, 1.8, [2, 3, 9])
	_add_wall_run_z(DUNGEON + "wall-half.glb", start_x + 23, -4, 7, 2.0, 1.8, [2, 3])
	_add_model(DUNGEON + "wall-opening.glb", Vector3(start_x + 37, 0, -2), Vector3(2, 2, 2), self, true, PI * 0.5)
	# The canal is a visible gap in both tile floor and floor collision; the bridge is the crossing.
	_add_box("DungeonCanal", Vector3(start_x + 50, -0.31, 0), Vector3(7.8, 0.06, 27), Color("274f70"), false)
	_add_box("TimberBridgeDeck", Vector3(start_x + 50, 0.26, 0), Vector3(8.2, 0.5, 4.4), Color("936044"), true)
	for plank in range(4):
		_add_model(DUNGEON + "wood-structure.glb", Vector3(start_x + 47 + plank * 2, 0.52, 0), Vector3(2, 1, 4), self, true)
	for post_x in [start_x + 47, start_x + 53]:
		for post_z in [-2.4, 2.4]:
			_add_model(DUNGEON + "wood-support.glb", Vector3(post_x, 0.45, post_z), Vector3(2.4, 2.4, 2.4), self, true)
	# Climbable staircases have a matching sloped collider so the player can walk up them.
	_add_stairway(DUNGEON + "stairs.glb", Vector3(start_x + 8, 0, 8), Vector3(2.8, 2.8, 2.8), 2.8, 2.5)
	_add_box("DungeonRaisedLanding", Vector3(start_x + 11.5, 2.5, 8), Vector3(4.4, 0.3, 3.0), Color("817b91"), true)
	_add_stairway(DUNGEON + "stairs.glb", Vector3(start_x + 61, 0, -9), Vector3(2.8, 2.8, 2.8), 2.8, 2.5)
	_add_box("DungeonExitLanding", Vector3(start_x + 64.5, 2.5, -9), Vector3(4.4, 0.3, 3.0), Color("817b91"), true)
	# A lived-in dungeon workshop, all with solid geometry collision.
	_add_model(DUNGEON + "wood-structure.glb", Vector3(start_x + 20, 0, 10), Vector3(3.4, 3.4, 3.4), self, true)
	_add_model(DUNGEON + "table.glb", Vector3(start_x + 7, 0, 10), Vector3(2.4, 2.4, 2.4), self, true)
	_add_model(DUNGEON + "chair.glb", Vector3(start_x + 5, 0, 10), Vector3(2.4, 2.4, 2.4), self, true)
	_add_model(DUNGEON + "barrel.glb", Vector3(start_x + 13, 0, 10), Vector3(2.5, 2.5, 2.5), self, true)
	_add_model(DUNGEON + "rocks.glb", Vector3(start_x + 32, 0, 10), Vector3(3.2, 3.2, 3.2), self, true)
	_add_model(DUNGEON + "column.glb", Vector3(start_x + 43, 0, 10), Vector3(3, 3, 3), self, true)
	var trap_chest := _add_model(DUNGEON + "chest.glb", Vector3(start_x + 62, 0, 8), Vector3(2.5, 2.5, 2.5), self, true)
	if trap_chest != null:
		trap_chest.set_meta("trap_chest", true)
	_add_model(DUNGEON + "pot.glb", Vector3(start_x + 59, 0, 8), Vector3(2, 2, 2), self, true)
	_add_model(DUNGEON + "gate.glb", Vector3(start_x + 41, 0, -11), Vector3(3, 3, 3), self, true)

func _build_arena_maze(start_x: float) -> void:
	# A broad maze with planned openings, gates and readable loops rather than scattered blocks.
	_add_wall_run_x(ARENA + "wall.glb", start_x + 9, -8, 20, 1.8, 1.8, [3, 4, 14, 15], ARENA + "wall-gate.glb")
	_add_wall_run_x(ARENA + "wall.glb", start_x + 25, 8, 19, 1.8, 1.8, [5, 6, 13], ARENA + "wall-gate.glb")
	_add_wall_run_x(ARENA + "wall.glb", start_x + 49, -2, 11, 1.8, 1.8, [2, 8], ARENA + "wall-gate.glb")
	_add_wall_run_z(ARENA + "wall.glb", start_x + 26, -12, 13, 1.8, 1.8, [4, 5, 10], ARENA + "wall-gate.glb")
	_add_wall_run_z(ARENA + "wall.glb", start_x + 47, -12, 13, 1.8, 1.8, [2, 3, 8, 9], ARENA + "wall-gate.glb")
	_add_wall_run_z(ARENA + "wall.glb", start_x + 64, -12, 13, 1.8, 1.8, [5, 6], ARENA + "wall-gate.glb")
	# Guard towers, statues, banners and columns mark the turns in the labyrinth.
	for x in [start_x + 7, start_x + 36, start_x + 66]:
		_add_model(ARENA + "column.glb", Vector3(x, 0, -11), Vector3(2.8, 2.8, 2.8), self, true)
		_add_model(ARENA + "column.glb", Vector3(x, 0, 11), Vector3(2.8, 2.8, 2.8), self, true)
	_add_model(ARENA + "statue.glb", Vector3(start_x + 39, 0, 3), Vector3(2.6, 2.6, 2.6), self, true)
	_add_model(ARENA + "banner.glb", Vector3(start_x + 19, 0, 11), Vector3(2.8, 2.8, 2.8), self, true)
	_add_model(ARENA + "tree.glb", Vector3(start_x + 58, 0, 10), Vector3(2.5, 2.5, 2.5), self, true)
	_add_model(ARENA + "block.glb", Vector3(start_x + 10, 0, 10), Vector3(2.8, 2.8, 2.8), self, true)
	_add_model(ARENA + "block.glb", Vector3(start_x + 59, 0, -10), Vector3(2.8, 2.8, 2.8), self, true)
	# Ascending arena stairs and raised platforms have climbable ramps and solid tops.
	_add_stairway(ARENA + "stairs.glb", Vector3(start_x + 56, 0, 4), Vector3(3.4, 3.4, 3.4), 2.4, 1.7)
	_add_model(ARENA + "block.glb", Vector3(start_x + 61, 0, 4), Vector3(6, 3.4, 4), self, true)

func _build_arcade_hall(start_x: float) -> void:
	# The final area is a continuous arcade hall with two machine rows and a clear central aisle.
	_add_wall_run_x(ARCADE + "wall.glb", start_x + 1, -12.8, 36, 2.0, 2.0)
	_add_wall_run_x(ARCADE + "wall.glb", start_x + 1, 12.8, 36, 2.0, 2.0)
	var machine_paths := ["arcade-machine.glb", "pinball.glb", "vending-machine.glb", "basketball-game.glb", "claw-machine.glb", "dance-machine.glb"]
	for i in range(7):
		var x := start_x + 7 + i * 9.0
		var machine: String = ARCADE + machine_paths[i % machine_paths.size()]
		_add_model(machine, Vector3(x, 0, -8), Vector3(2.7, 2.7, 2.7), self, true)
		_add_model(machine, Vector3(x, 0, 8), Vector3(2.7, 2.7, 2.7), self, true, PI)
	_add_model(ARCADE + "air-hockey.glb", Vector3(start_x + 28, 0, 0), Vector3(2.8, 2.8, 2.8), self, true)
	_add_model(ARCADE + "basketball-game.glb", Vector3(start_x + 44, 0, 0), Vector3(2.5, 2.5, 2.5), self, true)
	_add_model(ARCADE + "dance-machine.glb", Vector3(start_x + 57, 0, 0), Vector3(2.5, 2.5, 2.5), self, true)
	_add_stairway(ARENA + "stairs.glb", Vector3(start_x + 17, 0, 2), Vector3(3.4, 3.4, 3.4), 3.4, 1.7)
	_add_model(ARCADE + "wall-door-rotate.glb", Vector3(start_x + 36, 0, -12.8), Vector3(2, 2, 2), self, true)

func _add_wall_run_x(path: String, start_x: float, z: float, count: int, spacing: float, scale: float, openings: Array = [], gate_path := "") -> void:
	for i in range(count):
		var at := Vector3(start_x + i * spacing, 0, z)
		if openings.has(i):
			if not gate_path.is_empty():
				_add_model(gate_path, at, Vector3(scale, scale, scale), self, true)
			continue
		_add_model(path, at, Vector3(scale, scale, scale), self, true)

func _add_wall_run_z(path: String, x: float, start_z: float, count: int, spacing: float, scale: float, openings: Array = [], gate_path := "") -> void:
	for i in range(count):
		var at := Vector3(x, 0, start_z + i * spacing)
		if openings.has(i):
			if not gate_path.is_empty():
				_add_model(gate_path, at, Vector3(scale, scale, scale), self, true, PI * 0.5)
			continue
		_add_model(path, at, Vector3(scale, scale, scale), self, true, PI * 0.5)

func _add_stairway(path: String, at: Vector3, model_scale: Vector3, ramp_length: float, ramp_rise: float) -> void:
	# Kenney stair meshes rise toward local -Z; rotate them so the ramp climbs east along the route.
	var stairs := _add_model(path, at, model_scale, self, false, -PI * 0.5)
	if stairs != null:
		stairs.set_meta("stair_ramp_length", ramp_length)
		stairs.set_meta("stair_ramp_rise", ramp_rise)

func _build_player() -> void:
	player = CharacterBody3D.new()
	player.name = "Player"
	player.set_script(load("res://scripts/player.gd"))
	player.collision_layer = 1
	player.collision_mask = 1
	# Pick an unobstructed tile at the entrance so the avatar never starts trapped.
	var safe_start := _find_safe_spawn()
	player.last_safe_position = safe_start
	# A short, visible drop creates a clear arrival moment without keeping the
	# player waiting through a long fall before controls become available.
	player.position = safe_start + Vector3(0, 10, 0)
	player.rotation.y = -PI * 0.5
	player.controls_enabled = true
	var collider := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.28
	capsule.height = 1.2
	collider.shape = capsule
	collider.position.y = 0.6
	player.add_child(collider)
	var model: Node3D = load(PLAYER_SCENE).instantiate()
	model.name = "AnimatedCitizen"
	model.position.y = 0.05
	model.scale = Vector3(0.85, 0.85, 0.85)
	model.visible = true
	player.add_child(model)
	add_child(player)

func _find_safe_spawn() -> Vector3:
	if permanent_spawn_position_set:
		return permanent_spawn_position
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.28
	capsule.height = 1.2
	var space := get_world_3d().direct_space_state
	var clear_candidates: Array[Vector3] = []
	# The editable marker is on the stone clearing between the two trees in the
	# first district, directly below its giant red banner. Keep the exact same
	# first-district point as fallback; never use a banner in another district.
	var spawn_target := Vector3(0.75, 0.15, 4.0) * MAP_SCALE
	var spawn_marker := get_node_or_null("PlayerSpawnPoint") as Node3D
	if spawn_marker != null:
		spawn_target = spawn_marker.global_position
	# Search only this small stone clearing, avoiding the banner pole and trees.
	var spawn_scan_radius := 3.5
	var scan_min_x := maxf(1.0, spawn_target.x - spawn_scan_radius)
	var scan_max_x := minf(WORLD_LENGTH * MAP_SCALE - 1.0, spawn_target.x + spawn_scan_radius)
	var scan_min_z := maxf(-ZONE_WIDTH * MAP_SCALE * 0.5 + 1.0, spawn_target.z - spawn_scan_radius)
	var scan_max_z := minf(ZONE_WIDTH * MAP_SCALE * 0.5 - 1.0, spawn_target.z + spawn_scan_radius)
	for x_step in range(int(scan_min_x * 2.0), int(scan_max_x * 2.0) + 1, 2):
		var x := float(x_step) * 0.5
		for z_step in range(int(scan_min_z * 2.0), int(scan_max_z * 2.0) + 1, 2):
			var z := float(z_step) * 0.5
			var ray := PhysicsRayQueryParameters3D.create(Vector3(x, spawn_target.y + 8.0, z), Vector3(x, spawn_target.y - 5.0, z))
			ray.collision_mask = 1
			var ground := space.intersect_ray(ray)
			if ground.is_empty():
				continue
			var ground_y: float = ground.position.y
			if ground_y < spawn_target.y - 2.0 or ground_y > spawn_target.y + 1.5:
				continue
			if not _spawn_capsule_is_clear(space, capsule, x, z, ground_y):
				continue
			var candidate := Vector3(x, ground_y + 0.08, z)
			clear_candidates.append(candidate)
	if not clear_candidates.is_empty():
		clear_candidates.sort_custom(func(a: Vector3, b: Vector3) -> bool:
			return a.distance_squared_to(spawn_target) < b.distance_squared_to(spawn_target)
		)
		for candidate in clear_candidates:
			if _spawn_route_is_clear(space, capsule, candidate.x, candidate.z, candidate.y - 0.08):
				permanent_spawn_position = candidate
				permanent_spawn_position_set = true
				return candidate
		# If all forward lanes are narrow, spawn at the nearest verified clear cell.
		permanent_spawn_position = clear_candidates[0]
		permanent_spawn_position_set = true
		return clear_candidates[0]
	# Never use a hard-coded point that might be occupied in a user-edited map.
	push_warning("No encontré una celda libre para el spawn; revisa las colisiones del área inicial.")
	permanent_spawn_position = spawn_target + Vector3.UP * 0.08
	permanent_spawn_position_set = true
	return permanent_spawn_position

func _begin_water_respawn() -> void:
	if water_respawn_pending or not game_running or not is_instance_valid(player):
		return
	water_respawn_pending = true
	_play_water_splash_sound()
	spawn_transition_active = true
	player.controls_enabled = false
	player.set_physics_process(false)
	player.velocity = Vector3.ZERO
	player.visible = false
	var transition := _create_loading_transition(true)
	var water_loading_tween := create_tween()
	water_loading_tween.tween_property(transition.bar, "value", 100.0, 10.0).set_trans(Tween.TRANS_LINEAR)
	for seconds_left in range(10, 0, -1):
		if is_instance_valid(transition.status):
			transition.status.text = "REGRESO EN %d SEGUNDO%s" % [seconds_left, "" if seconds_left == 1 else "S"]
		await get_tree().create_timer(1.0).timeout
	if not is_instance_valid(player):
		if is_instance_valid(transition.layer):
			transition.layer.queue_free()
		water_respawn_pending = false
		spawn_transition_active = false
		return
	if not game_running:
		if is_instance_valid(transition.layer):
			transition.layer.queue_free()
		player.visible = true
		water_respawn_pending = false
		spawn_transition_active = false
		return
	var safe_spawn := _find_safe_spawn()
	player.global_position = safe_spawn + Vector3(0, 10, 0)
	player.last_safe_position = safe_spawn
	player.velocity = Vector3.ZERO
	player.visible = true
	player.controls_enabled = false
	player.set_physics_process(true)
	water_respawn_pending = false
	await _finish_spawn_transition(transition, water_loading_tween, 10.0)

func _spawn_capsule_is_clear(space: PhysicsDirectSpaceState3D, capsule: CapsuleShape3D, x: float, z: float, ground_y: float) -> bool:
	var overlap := PhysicsShapeQueryParameters3D.new()
	overlap.shape = capsule
	overlap.transform = Transform3D(Basis.IDENTITY, Vector3(x, ground_y + 0.6, z))
	overlap.collision_mask = 1
	for hit in space.intersect_shape(overlap, 32):
		var collider := hit.get("collider") as Node
		if collider and _is_floor_collider(collider):
			continue
		return false
	return true

func _is_floor_collider(collider: Node) -> bool:
	var path := str(collider.get_path()).to_lower()
	var node_name := collider.name.to_lower()
	return path.contains("/floor/") or node_name.contains("floor") or node_name.begins_with("zonefloor") or node_name.begins_with("dungeonfloor")

func _spawn_route_is_clear(space: PhysicsDirectSpaceState3D, capsule: CapsuleShape3D, start_x: float, z: float, ground_y: float) -> bool:
	# Validate a few metres ahead too; a free starting capsule inside a dead end
	# feels just like broken movement to the player.
	for step in [0.0, 1.5, 3.0, 4.5, 6.0]:
		var x: float = start_x + float(step)
		var overlap := PhysicsShapeQueryParameters3D.new()
		overlap.shape = capsule
		overlap.transform = Transform3D(Basis.IDENTITY, Vector3(x, ground_y + 0.6, z))
		overlap.collision_mask = 1
		for hit in space.intersect_shape(overlap, 32):
			var collider := hit.get("collider") as Node
			if collider and _is_floor_collider(collider):
				continue
			return false
		var ray := PhysicsRayQueryParameters3D.create(Vector3(x, ground_y + 4.0, z), Vector3(x, ground_y - 1.0, z))
		ray.collision_mask = 1
		var ground := space.intersect_ray(ray)
		if ground.is_empty() or absf(ground.position.y - ground_y) > 0.3:
			return false
	return true

func _build_camera() -> void:
	# First-person camera sits at eye height and follows the player's mouse-look pivot.
	camera = Camera3D.new()
	camera.name = "FirstPersonCamera"
	camera.projection = Camera3D.PROJECTION_PERSPECTIVE
	camera.fov = 76.0
	camera.near = 0.05
	camera.position = Vector3(0, 0, 0)
	var look_pivot := Node3D.new()
	look_pivot.name = "LookPivot"
	look_pivot.position.y = 1.0
	player.add_child(look_pivot)
	look_pivot.add_child(camera)
	player.set_look_pivot(look_pivot)
	# F1 switches to a full-map orthographic view for inspecting the complete layout.
	overview_camera = Camera3D.new()
	overview_camera.name = "MapOverviewCamera"
	overview_camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	overview_camera.size = 240.0
	overview_camera.position = Vector3(WORLD_LENGTH * 0.5, 145.0, 0.0)
	overview_camera.rotation_degrees = Vector3(-90.0, 0.0, 0.0)
	add_child(overview_camera)
	# The first-person camera was previously marked current before entering the
	# scene tree; explicitly activate it only after both camera nodes are attached.
	camera.make_current()

func _create_loading_transition(is_water: bool) -> Dictionary:
	var transition_layer := CanvasLayer.new()
	transition_layer.name = "WaterLoadingTransition" if is_water else "SpawnTransition"
	transition_layer.layer = 100
	add_child(transition_layer)
	var loading_image := TextureRect.new()
	loading_image.name = "LoadingKingdomBackground"
	loading_image.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	loading_image.texture = WATER_LOADING_BACKGROUND if is_water else load(LOADING_BACKGROUND_PATH) as Texture2D
	loading_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	loading_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	loading_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_layer.add_child(loading_image)
	var background := ColorRect.new()
	background.name = "LoadingBackground"
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = Color(0.035, 0.055, 0.09, 0.28) if not is_water else Color(0.015, 0.08, 0.14, 0.14)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_layer.add_child(background)
	var title := Label.new()
	title.set_anchors_preset(Control.PRESET_CENTER)
	title.position = Vector2(-320, -72)
	title.custom_minimum_size = Vector2(640, 60)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.text = "REGRESANDO AL ESTANDARTE" if is_water else "PREPARANDO EL REINO"
	_style_cartoon_text(title, 36)
	title.add_theme_color_override("font_color", Color("c7f0ff") if is_water else Color("ffe39a"))
	if is_water:
		title.add_theme_color_override("font_outline_color", Color("075078"))
		title.add_theme_color_override("font_shadow_color", Color(0.015, 0.09, 0.17, 0.85))
	background.add_child(title)
	var loading_bar := ProgressBar.new()
	loading_bar.set_anchors_preset(Control.PRESET_CENTER)
	loading_bar.position = Vector2(-250, 12)
	loading_bar.custom_minimum_size = Vector2(500, 34)
	loading_bar.min_value = 0.0
	loading_bar.max_value = 100.0
	loading_bar.value = 8.0 if not is_water else 0.0
	loading_bar.show_percentage = false
	var loading_track := StyleBoxFlat.new()
	loading_track.bg_color = Color("203545") if is_water else Color("3a2114")
	loading_track.border_color = Color("aeeaff") if is_water else Color("ffd56a")
	loading_track.set_border_width_all(4)
	loading_track.set_corner_radius_all(13)
	loading_track.shadow_color = Color(0.02, 0.12, 0.2, 0.85) if is_water else Color(0.07, 0.035, 0.012, 0.8)
	loading_track.shadow_size = 7
	loading_track.shadow_offset = Vector2(0, 3)
	loading_bar.add_theme_stylebox_override("background", loading_track)
	var loading_fill := StyleBoxFlat.new()
	loading_fill.bg_color = Color("39b8f2") if is_water else Color("ffc83d")
	loading_fill.border_color = Color("d7f7ff") if is_water else Color("fff0a8")
	loading_fill.set_border_width_all(1)
	loading_fill.set_corner_radius_all(9)
	loading_fill.shadow_color = Color(0.08, 0.68, 1.0, 0.9) if is_water else Color(1.0, 0.64, 0.12, 0.8)
	loading_fill.shadow_size = 5
	loading_fill.shadow_offset = Vector2.ZERO
	loading_bar.add_theme_stylebox_override("fill", loading_fill)
	background.add_child(loading_bar)
	var status := Label.new()
	status.name = "LoadingStatus"
	status.set_anchors_preset(Control.PRESET_CENTER)
	status.position = Vector2(-300, 58)
	status.custom_minimum_size = Vector2(600, 36)
	status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	status.add_theme_color_override("font_color", Color("e5f7ff"))
	_style_cartoon_text(status, 20)
	status.visible = is_water
	if is_water:
		status.text = "REGRESO EN 10 SEGUNDOS"
	background.add_child(status)
	var safety_card := PanelContainer.new()
	safety_card.name = "SafetyReflectionCard"
	safety_card.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	safety_card.offset_left = 90.0
	safety_card.offset_top = -144.0
	safety_card.offset_right = -90.0
	safety_card.offset_bottom = -24.0
	safety_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var parchment := StyleBoxFlat.new()
	parchment.bg_color = Color("f0dfbb", 0.96)
	parchment.border_color = Color("42b9e8") if is_water else Color("a56627")
	parchment.set_border_width_all(3)
	parchment.set_corner_radius_all(16)
	parchment.shadow_color = Color(0.015, 0.10, 0.18, 0.7) if is_water else Color(0.05, 0.025, 0.01, 0.65)
	parchment.shadow_size = 10
	parchment.shadow_offset = Vector2(0, 5)
	parchment.content_margin_left = 18.0
	parchment.content_margin_right = 18.0
	parchment.content_margin_top = 7.0
	parchment.content_margin_bottom = 7.0
	safety_card.add_theme_stylebox_override("panel", parchment)
	background.add_child(safety_card)
	var reflection_stack := VBoxContainer.new()
	reflection_stack.add_theme_constant_override("separation", 3)
	safety_card.add_child(reflection_stack)
	var reflection_heading := Label.new()
	reflection_heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reflection_heading.text = "CONSEJO DEL REINO"
	_style_cartoon_text(reflection_heading, 16)
	reflection_heading.add_theme_color_override("font_color", Color("167da8") if is_water else Color("8a4f1f"))
	reflection_heading.add_theme_constant_override("outline_size", 1)
	reflection_heading.add_theme_color_override("font_outline_color", Color("d2f4ff") if is_water else Color("fff0bd"))
	reflection_heading.add_theme_color_override("font_shadow_color", Color(0.03, 0.16, 0.25, 0.35) if is_water else Color(0, 0, 0, 0))
	reflection_stack.add_child(reflection_heading)
	var reflection := Label.new()
	reflection.name = "SafetyReflection"
	reflection.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reflection.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	reflection.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	reflection.text = "Antes de creer o reenviar una carta, verifica su origen. No compartas datos ni monedas con desconocidos y aléjate de retos que pongan a alguien en peligro."
	_style_cartoon_text(reflection, 18)
	reflection.add_theme_color_override("font_color", Color("3c2a1c"))
	reflection.add_theme_constant_override("outline_size", 0)
	reflection.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0))
	reflection.add_theme_constant_override("shadow_offset_x", 0)
	reflection.add_theme_constant_override("shadow_offset_y", 0)
	reflection_stack.add_child(reflection)
	return {"layer":transition_layer, "image":loading_image, "veil":background, "title":title, "bar":loading_bar, "status":status, "card":safety_card, "started_msec":Time.get_ticks_msec()}

func _start_spawn_intro() -> void:
	if spawn_transition_active or not is_instance_valid(player):
		return
	spawn_transition_active = true
	player.controls_enabled = false
	player.set_physics_process(true)
	if is_instance_valid(camera):
		camera.make_current()
	var transition := _create_loading_transition(false)
	var loading_tween := create_tween()
	loading_tween.tween_property(transition.bar, "value", 88.0, 3.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await _finish_spawn_transition(transition, loading_tween, 5.0)

func _finish_spawn_transition(transition: Dictionary, loading_tween: Tween = null, minimum_loading_seconds: float = 0.0) -> void:
	var transition_layer := transition.layer as CanvasLayer
	if not is_instance_valid(player):
		if is_instance_valid(transition_layer):
			transition_layer.queue_free()
		spawn_transition_active = false
		return
	var elapsed := 0.0
	while is_instance_valid(player) and not player.is_on_floor() and elapsed < 4.0:
		await get_tree().physics_frame
		elapsed += 1.0 / Engine.physics_ticks_per_second
	if not is_instance_valid(player):
		transition_layer.queue_free()
		spawn_transition_active = false
		return
	if not player.is_on_floor():
		player.global_position = player.last_safe_position + Vector3.UP * 0.08
		player.velocity = Vector3.ZERO
		await get_tree().physics_frame
	if is_instance_valid(camera):
		camera.make_current()
	var visual := player.get_node_or_null("AnimatedCitizen") as Node3D
	if visual:
		visual.visible = false
	player.controls_enabled = false
	player.velocity = Vector3.ZERO
	var loading_elapsed := float(Time.get_ticks_msec() - int(transition.started_msec)) / 1000.0
	if loading_elapsed < minimum_loading_seconds:
		await get_tree().create_timer(minimum_loading_seconds - loading_elapsed).timeout
	if loading_tween != null and loading_tween.is_running():
		loading_tween.kill()
	(transition.bar as ProgressBar).value = 100.0
	await get_tree().create_timer(0.22).timeout
	var radial_shader := Shader.new()
	radial_shader.code = """
	shader_type canvas_item;
	uniform float radius = 0.0;
	void fragment() {
		float aspect = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
		vec2 centered = (UV - vec2(0.5)) * vec2(aspect, 1.0);
		float distance_from_center = length(centered);
		float alpha = smoothstep(radius - 0.006, radius + 0.006, distance_from_center);
		COLOR = vec4(0.0, 0.0, 0.0, alpha);
	}
	"""
	var radial_material := ShaderMaterial.new()
	radial_material.shader = radial_shader
	var viewport_size := get_viewport().get_visible_rect().size
	var maximum_radius := 0.5 * sqrt(pow(viewport_size.x / maxf(viewport_size.y, 1.0), 2.0) + 1.0) + 0.02
	radial_material.set_shader_parameter("radius", -0.02)
	(transition.veil as ColorRect).color = Color.WHITE
	(transition.veil as ColorRect).material = radial_material
	(transition.image as TextureRect).visible = false
	(transition.title as Label).queue_free()
	(transition.bar as ProgressBar).queue_free()
	(transition.status as Label).queue_free()
	(transition.card as PanelContainer).queue_free()
	var radial_overlay := ColorRect.new()
	radial_overlay.name = "RadialReveal"
	radial_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	radial_overlay.color = Color.BLACK
	radial_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	radial_overlay.material = radial_material
	transition_layer.add_child(radial_overlay)
	var opening := create_tween()
	opening.tween_method(func(radius: float) -> void: radial_material.set_shader_parameter("radius", radius), -0.02, maximum_radius, 0.9).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await opening.finished
	player.controls_enabled = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	transition_layer.queue_free()
	spawn_transition_active = false
	_start_game_ambient_music()

func _setup_game_ambient_music() -> void:
	var stream := load(GAME_AMBIENT_MUSIC_PATH) as AudioStreamMP3
	if stream == null:
		push_warning("No pude cargar la música ambiental del reino.")
		return
	stream.loop = true
	game_ambient_music = AudioStreamPlayer.new()
	game_ambient_music.name = "GameAmbientMusic"
	game_ambient_music.stream = stream
	game_ambient_music.volume_db = -24.0
	game_ambient_music.bus = "Master"
	game_ambient_music.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(game_ambient_music)

func _start_game_ambient_music() -> void:
	if not is_instance_valid(game_ambient_music) or game_ambient_music.playing:
		return
	game_ambient_music.volume_db = -34.0
	game_ambient_music.play()
	create_tween().tween_property(game_ambient_music, "volume_db", -24.0, 2.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _stop_game_ambient_music() -> void:
	if is_instance_valid(game_ambient_music):
		game_ambient_music.stop()

func _setup_water_splash_sound() -> void:
	var stream := load(WATER_SPLASH_SOUND_PATH) as AudioStreamMP3
	if stream == null:
		push_warning("No pude cargar el sonido de caída al agua.")
		return
	water_splash_player = AudioStreamPlayer.new()
	water_splash_player.name = "WaterSplashSound"
	water_splash_player.stream = stream
	water_splash_player.volume_db = -10.0
	water_splash_player.bus = "Master"
	water_splash_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(water_splash_player)

func _play_water_splash_sound() -> void:
	if not is_instance_valid(water_splash_player):
		return
	if water_splash_player.playing:
		water_splash_player.stop()
	water_splash_player.play()

func _load_npc_interaction_voice() -> void:
	npc_interaction_voice_stream = load(NPC_INTERACTION_SOUND_PATH) as AudioStreamMP3
	if npc_interaction_voice_stream == null:
		push_warning("No pude cargar el sonido de voz de los NPCs.")

func _play_npc_interaction_voice(npc: Node3D) -> void:
	if not is_instance_valid(npc) or npc_interaction_voice_stream == null:
		return
	var voice := npc.get_node_or_null("NPCInteractionVoice") as AudioStreamPlayer3D
	if voice == null:
		voice = AudioStreamPlayer3D.new()
		voice.name = "NPCInteractionVoice"
		voice.stream = npc_interaction_voice_stream
		voice.volume_db = -8.0
		voice.unit_size = 4.0
		voice.max_distance = 18.0
		voice.attenuation_model = AudioStreamPlayer3D.ATTENUATION_INVERSE_DISTANCE
		npc.add_child(voice)
	if voice.playing:
		voice.stop()
	voice.play()

func _play_story_cinematic() -> void:
	story_cinematic_active = true
	var cinematic_layer := CanvasLayer.new()
	cinematic_layer.name = "StoryCinematic"
	cinematic_layer.layer = 30
	add_child(cinematic_layer)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	cinematic_layer.add_child(root)
	var backdrop := TextureRect.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.texture = load(LOADING_BACKGROUND_PATH) as Texture2D
	backdrop.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(backdrop)
	var veil := ColorRect.new()
	veil.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	veil.color = Color(0.015, 0.025, 0.055, 0.74)
	veil.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(veil)
	var story_image := TextureRect.new()
	story_image.name = "KingdomStoryPanel"
	story_image.set_anchors_preset(Control.PRESET_CENTER)
	story_image.offset_left = -560.0
	story_image.offset_top = -348.0
	story_image.offset_right = 560.0
	story_image.offset_bottom = 210.0
	story_image.texture = STORY_CINEMATIC_PANEL
	story_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	story_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	story_image.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.add_child(story_image)
	var caption_board := PanelContainer.new()
	caption_board.name = "NarrationCaptionBoard"
	caption_board.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	caption_board.offset_left = 100.0
	caption_board.offset_top = -104.0
	caption_board.offset_right = -100.0
	caption_board.offset_bottom = -26.0
	var caption_style := StyleBoxFlat.new()
	caption_style.bg_color = Color("392317")
	caption_style.border_color = Color("f3bd4c")
	caption_style.set_border_width_all(3)
	caption_style.set_corner_radius_all(18)
	caption_style.shadow_color = Color(0.02, 0.012, 0.01, 0.8)
	caption_style.shadow_size = 9
	caption_style.shadow_offset = Vector2(0, 4)
	caption_style.content_margin_left = 24.0
	caption_style.content_margin_right = 24.0
	caption_style.content_margin_top = 9.0
	caption_style.content_margin_bottom = 9.0
	caption_board.add_theme_stylebox_override("panel", caption_style)
	root.add_child(caption_board)
	var caption := Label.new()
	caption.name = "NarrationCaption"
	caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	caption.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caption.add_theme_color_override("font_color", Color("fff0bd"))
	caption.add_theme_color_override("font_shadow_color", Color("29170f"))
	caption.add_theme_constant_override("shadow_offset_x", 2)
	caption.add_theme_constant_override("shadow_offset_y", 3)
	_style_cartoon_text(caption, 21)
	caption_board.add_child(caption)
	var narrator := AudioStreamPlayer.new()
	narrator.name = "StoryNarrator"
	narrator.volume_db = -2.0
	add_child(narrator)
	var fade_in := create_tween()
	fade_in.tween_property(root, "modulate:a", 1.0, 0.65).from(0.0)
	for index in range(STORY_NARRATION_PATHS.size()):
		caption.text = STORY_NARRATION_CAPTIONS[index]
		var narration := load(STORY_NARRATION_PATHS[index]) as AudioStreamMP3
		if narration == null:
			push_warning("No se pudo cargar el fragmento de narración " + str(index + 1))
			continue
		narrator.stream = narration
		narrator.play()
		await get_tree().create_timer(maxf(narration.get_length(), 0.5), true).timeout
		narrator.stop()
		if not is_inside_tree():
			break
	await get_tree().create_timer(0.45, true).timeout
	var fade_out := create_tween()
	fade_out.tween_property(root, "modulate:a", 0.0, 0.55)
	await fade_out.finished
	narrator.queue_free()
	cinematic_layer.queue_free()
	story_cinematic_active = false

func _toggle_map_overview() -> void:
	if overview_camera.current:
		camera.make_current()
	else:
		overview_camera.make_current()

func _build_loading_screen() -> void:
	var loading_layer := CanvasLayer.new()
	loading_layer.name = "LoadingScreen"
	loading_layer.layer = 20
	add_child(loading_layer)
	var city_background := TextureRect.new()
	city_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	city_background.texture = load(LOADING_BACKGROUND_PATH) as Texture2D
	city_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	city_background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	city_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	loading_layer.add_child(city_background)
	var background := ColorRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = Color(0.035, 0.055, 0.09, 0.28)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	loading_layer.add_child(background)
	var title := Label.new()
	title.set_anchors_preset(Control.PRESET_CENTER)
	title.position = Vector2(-220, -52)
	title.custom_minimum_size = Vector2(440, 58)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.text = "PREPARANDO EL REINO"
	_style_cartoon_text(title, 34)
	title.add_theme_color_override("font_color", Color("ffe39a"))
	loading_layer.add_child(title)
	var progress := ProgressBar.new()
	progress.set_anchors_preset(Control.PRESET_CENTER)
	progress.position = Vector2(-180, 18)
	progress.custom_minimum_size = Vector2(360, 18)
	progress.value = 65
	loading_layer.add_child(progress)
	var reflection := Label.new()
	reflection.name = "SafetyReflection"
	reflection.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	reflection.offset_left = 70.0
	reflection.offset_top = -116.0
	reflection.offset_right = -70.0
	reflection.offset_bottom = -30.0
	reflection.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	reflection.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	reflection.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	reflection.text = "Antes de creer o compartir, verifica. No entregues datos ni dinero a desconocidos y aléjate de retos peligrosos."
	_style_cartoon_text(reflection, 16)
	reflection.add_theme_color_override("font_color", Color("fff0bd"))
	background.add_child(reflection)

func _set_gameplay_ui_visible(visible_now: bool) -> void:
	_animate_gameplay_status_panel(visible_now)
	if is_instance_valid(gameplay_role_symbols_row): gameplay_role_symbols_row.visible = visible_now
	if is_instance_valid(gameplay_bottom_panel): gameplay_bottom_panel.visible = false
	if is_instance_valid(gameplay_crosshair): gameplay_crosshair.visible = visible_now
	if is_instance_valid(timer_container): timer_container.visible = visible_now
	if is_instance_valid(restart_button): restart_button.visible = visible_now
	if is_instance_valid(restart_confirmation_root): restart_confirmation_root.visible = false
	if is_instance_valid(prompt_panel): prompt_panel.visible = visible_now
	elif is_instance_valid(prompt): prompt.visible = visible_now
	if is_instance_valid(panel): panel.visible = false
	if is_instance_valid(network_panel): network_panel.visible = false
	if not visible_now and is_instance_valid(whale_puzzle_panel):
		whale_puzzle_panel.visible = false
		whale_puzzle_dim.visible = false

func _animate_gameplay_status_panel(show_panel: bool) -> void:
	if not is_instance_valid(gameplay_top_panel):
		return
	gameplay_status_requested_visible = show_panel
	if is_instance_valid(gameplay_top_panel_tween) and gameplay_top_panel_tween.is_running():
		gameplay_top_panel_tween.kill()
	var panel_width := maxf(gameplay_top_panel.size.x, gameplay_top_panel.custom_minimum_size.x)
	var offscreen_position := gameplay_top_panel_home_position - Vector2(panel_width + 44.0, 0.0)
	if show_panel:
		gameplay_top_panel.visible = true
		gameplay_top_panel.position = offscreen_position
		gameplay_top_panel.modulate.a = 1.0
		gameplay_top_panel_tween = create_tween()
		gameplay_top_panel_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		gameplay_top_panel_tween.tween_property(gameplay_top_panel, "position", gameplay_top_panel_home_position, 0.48)
		return
	if not gameplay_top_panel.visible:
		return
	gameplay_top_panel_tween = create_tween()
	gameplay_top_panel_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	gameplay_top_panel_tween.tween_property(gameplay_top_panel, "position", offscreen_position, 0.34)
	gameplay_top_panel_tween.tween_callback(func() -> void:
		if is_instance_valid(gameplay_top_panel) and not gameplay_status_requested_visible:
			gameplay_top_panel.visible = false
			gameplay_top_panel.position = gameplay_top_panel_home_position
	)

func _show_menu_page(page: String) -> void:
	if not is_instance_valid(menu_root):
		return
	menu_root.visible = true
	if is_instance_valid(player_name_screen):
		player_name_screen.visible = page == "player_name"
	if page == "player_name":
		home_screen.visible = false
		menu_panel.visible = false
		if is_instance_valid(player_name_message):
			player_name_message.text = ""
		if is_instance_valid(player_name_input):
			player_name_input.text = network_player_name if network_player_name != "Jugador" else ""
			player_name_input.grab_focus.call_deferred()
		if is_instance_valid(leaderboard_overlay):
			leaderboard_overlay.visible = false
		return
	if page == "defeat":
		_ensure_defeat_background()
	if is_instance_valid(defeat_background):
		defeat_background.visible = page == "defeat"
	if page == "home":
		home_screen.visible = true
		menu_panel.visible = false
		return
	home_screen.visible = false
	menu_panel.visible = true
	if page == "tutorial":
		menu_panel.offset_left = -600
		menu_panel.offset_top = -350
		menu_panel.offset_right = 600
		menu_panel.offset_bottom = 350
		var tutorial_style := StyleBoxFlat.new()
		tutorial_style.bg_color = Color(0, 0, 0, 0)
		tutorial_style.border_color = Color(0, 0, 0, 0)
		menu_panel.add_theme_stylebox_override("panel", tutorial_style)
		menu_content.add_theme_constant_override("separation", 18)
	elif page == "settings":
		menu_panel.offset_left = -430
		menu_panel.offset_top = -350
		menu_panel.offset_right = 430
		menu_panel.offset_bottom = 350
		var settings_style := StyleBoxFlat.new()
		settings_style.bg_color = Color(0, 0, 0, 0)
		settings_style.border_color = Color(0, 0, 0, 0)
		settings_style.set_border_width_all(0)
		menu_panel.add_theme_stylebox_override("panel", settings_style)
		menu_content.add_theme_constant_override("separation", 14)
	elif page == "home":
		menu_panel.offset_left = -330
		menu_panel.offset_top = -350
		menu_panel.offset_right = 330
		menu_panel.offset_bottom = 350
		var home_style := StyleBoxFlat.new()
		home_style.bg_color = Color(0, 0, 0, 0)
		home_style.border_color = Color(0, 0, 0, 0)
		home_style.set_border_width_all(0)
		menu_panel.add_theme_stylebox_override("panel", home_style)
		menu_content.add_theme_constant_override("separation", 4)
	else:
		menu_panel.offset_left = -390
		menu_panel.offset_top = -340
		menu_panel.offset_right = 390
		menu_panel.offset_bottom = 340
		var standard_style := StyleBoxFlat.new()
		standard_style.bg_color = Color(0, 0, 0, 0)
		standard_style.border_color = Color(0, 0, 0, 0)
		standard_style.set_border_width_all(0)
		menu_panel.add_theme_stylebox_override("panel", standard_style)
		menu_content.add_theme_constant_override("separation", 12)
	for child in menu_content.get_children():
		menu_content.remove_child(child)
		# Do not destroy the button while its pressed signal is still executing.
		child.queue_free()
	var title := Label.new()
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_style_cartoon_text(title, 42)
	title.add_theme_color_override("font_color", Color("fff0bd"))
	if page != "tutorial" and page != "settings":
		menu_content.add_child(title)
	match page:
		"mode":
			title.text = "ELIGE EL MODO"
			_add_menu_button("MODO SOLITARIO", func(): _show_menu_page("player_name"))
			_add_menu_button("MODO COOPERATIVO", func(): _show_menu_page("coop"))
			_add_menu_button("VOLVER", func(): _show_menu_page("home"))
		"coop":
			title.text = "COOPERATIVO · 2–4 HÉROES"
			_add_menu_label("Crea una sala o únete con el código que te compartieron.", 16)
			_add_menu_button("CREAR SALA", func(): _show_menu_page("create_room"))
			_add_menu_button("PARTIDA RÁPIDA", func(): _show_menu_page("quick_join"))
			_add_menu_button("VOLVER", func(): _show_menu_page("mode"))
		"create_room":
			title.text = "CREAR SALA"
			_add_menu_label("Nombre de la sala", 16)
			room_name_input = LineEdit.new()
			room_name_input.placeholder_text = "Ej.: Los guardianes del reino"
			room_name_input.custom_minimum_size = Vector2(620, 54)
			_style_cartoon_text(room_name_input, 23)
			_style_line_edit_cartoon(room_name_input)
			menu_content.add_child(room_name_input)
			_add_menu_label("Tu nombre de jugador", 16)
			network_player_name_input = LineEdit.new()
			network_player_name_input.placeholder_text = "Ej.: Guardián del reino"
			network_player_name_input.text = network_player_name
			network_player_name_input.custom_minimum_size = Vector2(620, 54)
			_style_cartoon_text(network_player_name_input, 23)
			_style_line_edit_cartoon(network_player_name_input)
			menu_content.add_child(network_player_name_input)
			_add_menu_label("Contraseña de acceso", 16)
			room_password_input = LineEdit.new()
			room_password_input.placeholder_text = "Crea una contraseña para tu sala"
			room_password_input.secret = true
			room_password_input.custom_minimum_size = Vector2(620, 54)
			_style_cartoon_text(room_password_input, 23)
			_style_line_edit_cartoon(room_password_input)
			menu_content.add_child(room_password_input)
			_add_menu_button("GENERAR CÓDIGO Y ESPERAR", _create_room_from_menu)
			_add_menu_button("VOLVER", func(): _show_menu_page("coop"))
		"quick_join":
			title.text = "PARTIDA RÁPIDA"
			_add_menu_label("Pega el código de invitación o la IP del anfitrión.", 16)
			room_code_input = LineEdit.new()
			room_code_input.placeholder_text = "Código de sala o IP"
			room_code_input.text = join_room_code
			room_code_input.custom_minimum_size = Vector2(620, 54)
			_style_cartoon_text(room_code_input, 23)
			_style_line_edit_cartoon(room_code_input)
			menu_content.add_child(room_code_input)
			_add_menu_label("Tu nombre de jugador", 16)
			network_player_name_input = LineEdit.new()
			network_player_name_input.placeholder_text = "Ej.: Mensajero"
			network_player_name_input.text = network_player_name
			network_player_name_input.custom_minimum_size = Vector2(620, 54)
			_style_cartoon_text(network_player_name_input, 23)
			_style_line_edit_cartoon(network_player_name_input)
			menu_content.add_child(network_player_name_input)
			_add_menu_label("Contraseña de la sala", 16)
			join_password_input = LineEdit.new()
			join_password_input.placeholder_text = "Escribe la contraseña que te dieron"
			join_password_input.secret = true
			join_password_input.custom_minimum_size = Vector2(620, 54)
			_style_cartoon_text(join_password_input, 23)
			_style_line_edit_cartoon(join_password_input)
			menu_content.add_child(join_password_input)
			_add_menu_button("CONECTAR", _join_room_code)
			_add_menu_button("VOLVER", func(): _show_menu_page("coop"))
		"lobby":
			title.text = "SALA LISTA"
			var member_names: Array[String] = []
			for peer_id in network_peer_ids:
				var member_name := String(network_player_names.get(peer_id, "Jugador %d" % peer_id))
				member_names.append(member_name + (" (anfitrión)" if peer_id == 1 else ""))
			var credentials_text := "Sala: %s\nCódigo: %s\nJugadores: %d/%d\n%s\nComparte el código y la contraseña con tu grupo. Para Internet se necesita abrir UDP 7777 o usar un servidor de retransmisión." % [random_room_name, random_room_code, maxi(network_peer_ids.size(), 1), MAX_COOP_PLAYERS, "\n".join(PackedStringArray(member_names))]
			if is_network_host:
				credentials_text += "\nContraseña: %s" % room_password
			_add_menu_label(credentials_text, 15)
			if is_network_host:
				_add_menu_button("INICIAR PARTIDA", _start_network_match)
				_add_menu_button("CANCELAR SALA", _cancel_room)
			else:
				_add_menu_label("Esperando a que el anfitrión inicie la partida…", 16)
				_add_menu_button("SALIR DE LA SALA", _cancel_room)
		"waiting":
			title.text = "CONECTADO A LA SALA"
			_add_menu_label("Esperando a que el anfitrión inicie la partida…", 17)
			_add_menu_button("CANCELAR", _cancel_room)
		"tutorial":
			var tutorial_scene := load("res://scenes/tutorial_ui.tscn") as PackedScene
			if tutorial_scene != null:
				var tutorial_ui := tutorial_scene.instantiate()
				tutorial_ui.name = "TutorialContent"
				tutorial_ui.back_requested.connect(func(): _show_menu_page("home"))
				menu_content.add_child(tutorial_ui)
		"settings":
			title.text = "AJUSTES"
			var settings_scene := load("res://scenes/settings_ui.tscn") as PackedScene
			if settings_scene != null:
				var settings_ui := settings_scene.instantiate()
				settings_ui.name = "SettingsContent"
				settings_ui.back_requested.connect(func(): _show_menu_page("home"))
				settings_ui.volume_changed.connect(_on_volume_changed)
				settings_ui.lights_toggled.connect(_on_lights_toggled)
				settings_ui.scale_selected.connect(_on_scale_selected)
				var selected_scale := clampi(roundi((_load_setting_float("ui_scale", 1.0) - 0.85) / 0.15), 0, 2)
				settings_ui.set_values(_load_setting_float("volume", 0.8), _load_setting_bool("lights_enabled", true), selected_scale)
				menu_content.add_child(settings_ui)
		"defeat":
			if last_defeat_cause == "low_morale":
				title.text = "EL REINO PERDIÓ LA CONFIANZA"
				_add_menu_label("Tres o más vecinos llegaron a 0% de ánimo. Anima a la gente antes de que pierda la esperanza.", 16)
			else:
				title.text = "EL REY YA HIZO SU ANUNCIO"
				_add_menu_label("Se agotó el tiempo antes de completar las misiones. Vuelve a intentarlo.", 16)
			_add_menu_button("VOLVER AL INICIO", _return_to_menu)
		"victory":
			title.text = "¡EL REINO ESTÁ A SALVO!" if journalist_correct_classifications == JOURNALIST_CLAIMS.size() else "FINAL IRREGULAR"
			var ending := final_classification_summary
			if ending.is_empty():
				ending = "Completaste las misiones y frenaste la desinformación."
			_add_menu_label(ending, 17)
			_add_menu_button("VOLVER AL INICIO", _return_to_menu)

func _build_player_name_screen(parent: Control) -> void:
	player_name_screen = Control.new()
	player_name_screen.name = "PlayerNameAndTimesScreen"
	player_name_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	player_name_screen.visible = false
	player_name_screen.mouse_filter = Control.MOUSE_FILTER_STOP
	player_name_screen.z_index = 10
	parent.add_child(player_name_screen)
	var background := TextureRect.new()
	background.name = "NameTimesArtwork"
	background.texture = PLAYER_NAME_TIMES_SCREEN
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	background.stretch_mode = TextureRect.STRETCH_SCALE
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player_name_screen.add_child(background)
	player_name_field_cover = ColorRect.new()
	player_name_field_cover.name = "EditableNameFieldPaper"
	player_name_field_cover.set_anchors_preset(Control.PRESET_FULL_RECT)
	player_name_field_cover.anchor_left = 0.219
	player_name_field_cover.anchor_top = 0.423
	player_name_field_cover.anchor_right = 0.535
	player_name_field_cover.anchor_bottom = 0.496
	player_name_field_cover.color = Color("f2e7d7")
	player_name_field_cover.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player_name_field_cover.visible = false
	player_name_screen.add_child(player_name_field_cover)
	player_name_placeholder_label = Label.new()
	player_name_placeholder_label.name = "EditableNamePlaceholder"
	player_name_placeholder_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	player_name_placeholder_label.anchor_left = 0.219
	player_name_placeholder_label.anchor_top = 0.423
	player_name_placeholder_label.anchor_right = 0.535
	player_name_placeholder_label.anchor_bottom = 0.496
	player_name_placeholder_label.text = "Escribe tu nombre..."
	player_name_placeholder_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	player_name_placeholder_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	player_name_placeholder_label.add_theme_color_override("font_color", Color("806751"))
	player_name_placeholder_label.add_theme_font_size_override("font_size", 29)
	player_name_placeholder_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player_name_placeholder_label.visible = false
	player_name_screen.add_child(player_name_placeholder_label)
	player_name_input = LineEdit.new()
	player_name_input.name = "PlayerNameInput"
	player_name_input.set_anchors_preset(Control.PRESET_FULL_RECT)
	player_name_input.anchor_left = 0.205
	player_name_input.anchor_top = 0.407
	player_name_input.anchor_right = 0.548
	player_name_input.anchor_bottom = 0.514
	player_name_input.placeholder_text = ""
	player_name_input.max_length = 24
	player_name_input.alignment = HORIZONTAL_ALIGNMENT_CENTER
	player_name_input.add_theme_font_override("font", CARTOON_FONT)
	player_name_input.add_theme_font_size_override("font_size", 26)
	player_name_input.add_theme_color_override("font_color", Color("58341e"))
	player_name_input.add_theme_color_override("font_placeholder_color", Color("58341e"))
	player_name_input.add_theme_color_override("caret_color", Color("85572d"))
	var empty_style := StyleBoxEmpty.new()
	player_name_input.add_theme_stylebox_override("normal", empty_style)
	player_name_input.add_theme_stylebox_override("focus", empty_style)
	player_name_input.add_theme_stylebox_override("read_only", empty_style)
	player_name_input.text_changed.connect(func(_value: String) -> void:
		player_name_field_cover.visible = player_name_input.has_focus() or not player_name_input.text.is_empty()
		player_name_placeholder_label.visible = player_name_input.has_focus() and player_name_input.text.is_empty()
		if is_instance_valid(player_name_message):
			player_name_message.text = ""
	)
	player_name_input.focus_entered.connect(func() -> void:
		player_name_field_cover.visible = true
		player_name_placeholder_label.visible = player_name_input.text.is_empty()
	)
	player_name_input.focus_exited.connect(func() -> void:
		player_name_field_cover.visible = not player_name_input.text.is_empty()
		player_name_placeholder_label.visible = false
	)
	player_name_input.text_submitted.connect(func(_value: String) -> void: _confirm_player_name())
	player_name_screen.add_child(player_name_input)
	player_name_message = Label.new()
	player_name_message.name = "NameValidationMessage"
	player_name_message.set_anchors_preset(Control.PRESET_FULL_RECT)
	player_name_message.anchor_left = 0.205
	player_name_message.anchor_top = 0.513
	player_name_message.anchor_right = 0.548
	player_name_message.anchor_bottom = 0.55
	player_name_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	player_name_message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	player_name_message.add_theme_font_override("font", CARTOON_FONT)
	player_name_message.add_theme_font_size_override("font_size", 18)
	player_name_message.add_theme_color_override("font_color", Color("7c2d1e"))
	player_name_screen.add_child(player_name_message)
	var continue_button := _create_transparent_screen_button("ContinueButton", Rect2(0.20, 0.55, 0.35, 0.14))
	continue_button.pressed.connect(_confirm_player_name)
	player_name_screen.add_child(continue_button)
	var table_button := _create_transparent_screen_button("TableButton", Rect2(0.277, 0.715, 0.201, 0.085))
	table_button.pressed.connect(func() -> void:
		_refresh_player_leaderboard()
		player_name_message.text = "Tabla de tiempos actualizada."
	)
	player_name_screen.add_child(table_button)
	# Keep the existing co-op flow available as a discreet link below the time board.
	var coop_button := Button.new()
	coop_button.name = "CoopModeLink"
	coop_button.set_anchors_preset(Control.PRESET_FULL_RECT)
	coop_button.anchor_left = 0.705
	coop_button.anchor_top = 0.865
	coop_button.anchor_right = 0.96
	coop_button.anchor_bottom = 0.94
	coop_button.text = "MODO COOPERATIVO"
	coop_button.add_theme_font_override("font", CARTOON_FONT)
	coop_button.add_theme_font_size_override("font_size", 17)
	coop_button.add_theme_color_override("font_color", Color("fff0bd"))
	coop_button.add_theme_color_override("font_outline_color", Color("57321d"))
	coop_button.add_theme_constant_override("outline_size", 3)
	coop_button.flat = true
	coop_button.pressed.connect(func() -> void: _show_menu_page("coop"))
	player_name_screen.add_child(coop_button)
	_build_inline_leaderboard()
	_refresh_player_leaderboard()

func _build_inline_leaderboard() -> void:
	# Cover only the sample rows printed in the reference art, then draw the saved times here.
	var paper := ColorRect.new()
	paper.name = "LeaderboardRowsPaper"
	paper.set_anchors_preset(Control.PRESET_FULL_RECT)
	paper.anchor_left = 0.682
	paper.anchor_top = 0.354
	paper.anchor_right = 0.902
	paper.anchor_bottom = 0.696
	paper.color = Color("edd7a9")
	paper.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player_name_screen.add_child(paper)
	var records_heading := Label.new()
	records_heading.name = "SavedRecordsHeading"
	records_heading.set_anchors_preset(Control.PRESET_FULL_RECT)
	records_heading.anchor_left = 0.682
	records_heading.anchor_top = 0.354
	records_heading.anchor_right = 0.902
	records_heading.anchor_bottom = 0.414
	records_heading.text = "MEJORES PARTIDAS · RÉCORDS"
	records_heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	records_heading.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	records_heading.add_theme_font_size_override("font_size", 15)
	records_heading.add_theme_color_override("font_color", Color("58341e"))
	records_heading.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player_name_screen.add_child(records_heading)
	leaderboard_rows = VBoxContainer.new()
	leaderboard_rows.name = "SavedLeaderboardRows"
	leaderboard_rows.set_anchors_preset(Control.PRESET_FULL_RECT)
	leaderboard_rows.anchor_left = 0.682
	leaderboard_rows.anchor_top = 0.421
	leaderboard_rows.anchor_right = 0.902
	leaderboard_rows.anchor_bottom = 0.696
	leaderboard_rows.add_theme_constant_override("separation", 6)
	leaderboard_rows.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player_name_screen.add_child(leaderboard_rows)

func _create_transparent_screen_button(button_name: String, normalized_rect: Rect2) -> Button:
	var button := Button.new()
	button.name = button_name
	button.set_anchors_preset(Control.PRESET_FULL_RECT)
	button.anchor_left = normalized_rect.position.x
	button.anchor_top = normalized_rect.position.y
	button.anchor_right = normalized_rect.position.x + normalized_rect.size.x
	button.anchor_bottom = normalized_rect.position.y + normalized_rect.size.y
	button.text = ""
	button.focus_mode = Control.FOCUS_NONE
	for style_name in ["normal", "hover", "pressed", "focus", "disabled"]:
		button.add_theme_stylebox_override(style_name, StyleBoxEmpty.new())
	return button

func _create_player_leaderboard_overlay() -> void:
	leaderboard_overlay = Control.new()
	leaderboard_overlay.name = "PlayerLeaderboardOverlay"
	leaderboard_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	leaderboard_overlay.visible = false
	leaderboard_overlay.z_index = 20
	player_name_screen.add_child(leaderboard_overlay)
	var shade := ColorRect.new()
	shade.name = "LeaderboardShade"
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.055, 0.035, 0.025, 0.76)
	shade.mouse_filter = Control.MOUSE_FILTER_STOP
	leaderboard_overlay.add_child(shade)
	var board := PanelContainer.new()
	board.name = "LeaderboardBoard"
	board.set_anchors_preset(Control.PRESET_CENTER)
	board.offset_left = -330
	board.offset_top = -282
	board.offset_right = 330
	board.offset_bottom = 282
	_style_texture_board(board, Rect2(18, 0, 980, 770), Vector2(660, 564), Vector4(86, 86, 82, 74))
	leaderboard_overlay.add_child(board)
	var content := VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	board.add_child(content)
	var title := Label.new()
	title.text = "TABLA DE TIEMPOS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_style_cartoon_text(title, 30)
	title.add_theme_color_override("font_color", Color("fff0bd"))
	content.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "PARTIDAS COMPLETADAS · MÁS RÁPIDAS PRIMERO"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_style_cartoon_text(subtitle, 16)
	subtitle.add_theme_color_override("font_color", Color("6f4528"))
	content.add_child(subtitle)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.custom_minimum_size = Vector2(0, 350)
	content.add_child(scroll)
	leaderboard_rows = VBoxContainer.new()
	leaderboard_rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	leaderboard_rows.add_theme_constant_override("separation", 8)
	scroll.add_child(leaderboard_rows)
	var close_button := Button.new()
	close_button.text = "VOLVER"
	close_button.custom_minimum_size = Vector2(220, 48)
	close_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_style_cartoon_text(close_button, 20)
	_style_wood_button(close_button)
	close_button.pressed.connect(func() -> void: leaderboard_overlay.visible = false)
	content.add_child(close_button)

func _show_player_leaderboard() -> void:
	if player_name_input.text.strip_edges().is_empty():
		player_name_message.text = "Escribe tu nombre para consultar la tabla."
		return
	_refresh_player_leaderboard()
	leaderboard_overlay.visible = true

func _refresh_player_leaderboard() -> void:
	if not is_instance_valid(leaderboard_rows):
		return
	for child in leaderboard_rows.get_children():
		leaderboard_rows.remove_child(child)
		child.queue_free()
	if leaderboard_records.is_empty():
		var empty_label := Label.new()
		empty_label.text = "Aún no hay partidas completadas.\nCompleta una partida para guardar tu tiempo."
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		empty_label.custom_minimum_size = Vector2(0, 100)
		_style_plain_player_record_text(empty_label, 17)
		empty_label.add_theme_color_override("font_color", Color("58341e"))
		leaderboard_rows.add_child(empty_label)
		return
	for index in range(mini(4, leaderboard_records.size())):
		var record: Dictionary = leaderboard_records[index]
		var row := PanelContainer.new()
		var row_style := StyleBoxFlat.new()
		row_style.bg_color = Color("f4e1b6")
		row_style.border_color = Color("c18a35")
		row_style.set_border_width_all(2)
		row_style.set_corner_radius_all(10)
		row_style.content_margin_left = 16
		row_style.content_margin_right = 16
		row_style.content_margin_top = 4
		row_style.content_margin_bottom = 4
		row.add_theme_stylebox_override("panel", row_style)
		var row_content := HBoxContainer.new()
		row_content.add_theme_constant_override("separation", 14)
		var rank := Label.new()
		rank.text = "%02d" % (index + 1)
		rank.custom_minimum_size = Vector2(38, 32)
		rank.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_style_plain_player_record_text(rank, 18)
		rank.add_theme_color_override("font_color", Color("9a5b1d"))
		row_content.add_child(rank)
		var player_label := Label.new()
		player_label.text = String(record.get("name", "Jugador"))
		player_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		player_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		player_label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		_style_plain_player_record_text(player_label, 18)
		player_label.add_theme_color_override("font_color", Color("58341e"))
		row_content.add_child(player_label)
		var time_label := Label.new()
		time_label.text = _format_player_time(int(record.get("seconds", 0)))
		time_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		_style_plain_player_record_text(time_label, 18)
		time_label.add_theme_color_override("font_color", Color("58341e"))
		row_content.add_child(time_label)
		row.add_child(row_content)
		leaderboard_rows.add_child(row)

func _confirm_player_name() -> void:
	if not is_instance_valid(player_name_input):
		return
	var clean_name := player_name_input.text.strip_edges()
	if clean_name.is_empty():
		player_name_message.text = "Escribe tu nombre para continuar."
		player_name_input.grab_focus()
		return
	if clean_name.length() > 24:
		clean_name = clean_name.substr(0, 24)
	network_player_name = clean_name
	if is_instance_valid(player_name_message):
		player_name_message.text = ""
	_start_solo_game()

func _load_player_completion_times() -> void:
	leaderboard_records.clear()
	var config := ConfigFile.new()
	if config.load(PLAYER_RECORDS_PATH) != OK:
		return
	var saved_records: Array = config.get_value("leaderboard", "records", [])
	for record_value in saved_records:
		if not record_value is Dictionary:
			continue
		var record: Dictionary = record_value
		var clean_name := String(record.get("name", "")).strip_edges()
		if clean_name.is_empty():
			continue
		leaderboard_records.append({"name":clean_name, "seconds":maxi(1, int(record.get("seconds", 0)))})
	leaderboard_records.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int(a.get("seconds", 0)) < int(b.get("seconds", 0))
	)

func _record_player_completion_time() -> void:
	if completion_recorded_for_match:
		return
	completion_recorded_for_match = true
	var clean_name := network_player_name.strip_edges()
	if clean_name.is_empty():
		clean_name = "Jugador"
	leaderboard_records.append({"name":clean_name, "seconds":maxi(1, roundi(match_elapsed_seconds))})
	leaderboard_records.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return int(a.get("seconds", 0)) < int(b.get("seconds", 0))
	)
	while leaderboard_records.size() > 50:
		leaderboard_records.pop_back()
	var config := ConfigFile.new()
	config.set_value("leaderboard", "records", leaderboard_records)
	var error := config.save(PLAYER_RECORDS_PATH)
	if error != OK:
		push_warning("No pude guardar los tiempos de las partidas completadas.")

func _format_player_time(total_seconds: int) -> String:
	var safe_seconds := maxi(0, total_seconds)
	return "%02d:%02d" % [safe_seconds / 60, safe_seconds % 60]

func _style_plain_player_record_text(label: Control, font_size: int) -> void:
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0))
	label.add_theme_constant_override("shadow_offset_x", 0)
	label.add_theme_constant_override("shadow_offset_y", 0)

func _ensure_defeat_background() -> void:
	if is_instance_valid(defeat_background):
		return
	defeat_background = TextureRect.new()
	defeat_background.name = "DefeatKingdomBackground"
	defeat_background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	defeat_background.texture = DEFEAT_BACKGROUND
	defeat_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	defeat_background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	defeat_background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var darken := ColorRect.new()
	darken.name = "DefeatBackgroundShade"
	darken.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	darken.color = Color(0.025, 0.04, 0.07, 0.34)
	darken.mouse_filter = Control.MOUSE_FILTER_IGNORE
	defeat_background.add_child(darken)
	menu_root.add_child(defeat_background)
	menu_root.move_child(defeat_background, mini(2, menu_root.get_child_count() - 1))

func _add_menu_label(message: String, size: int) -> void:
	var label := Label.new()
	label.text = message
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_style_cartoon_text(label, size + 5)
	label.add_theme_color_override("font_color", Color("f7f2df"))
	menu_content.add_child(label)

func _add_welcome_header(title: Label) -> void:
	# A compact illustrated crest keeps the welcome copy clear of the button art.
	var header := Control.new()
	header.name = "WelcomeHeader"
	header.custom_minimum_size = Vector2(620, 140)
	header.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var banner := TextureRect.new()
	banner.texture = load("res://assets/ui/welcome_banner.png") as Texture2D
	banner.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	banner.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	banner.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	banner.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header.add_child(banner)
	title.text = "¡BIENVENIDO AL REINO!"
	title.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	title.offset_left = 18
	title.offset_right = -18
	title.offset_top = 56
	title.offset_bottom = -44
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color("fff1bb"))
	title.add_theme_constant_override("outline_size", 3)
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header.add_child(title)
	var subtitle := Label.new()
	subtitle.text = "ALCALDE DIGITAL · CIUDAD EN RED"
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	subtitle.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	subtitle.offset_left = 18
	subtitle.offset_right = -18
	subtitle.offset_top = 94
	subtitle.offset_bottom = -16
	_style_cartoon_text(subtitle, 15)
	subtitle.add_theme_color_override("font_color", Color("70421c"))
	subtitle.add_theme_color_override("font_outline_color", Color("fff1cf"))
	subtitle.add_theme_constant_override("outline_size", 1)
	subtitle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	header.add_child(subtitle)
	menu_content.add_child(header)

func _style_cartoon_text(control: Control, font_size: int) -> void:
	control.add_theme_font_override("font", CARTOON_FONT)
	control.add_theme_font_size_override("font_size", font_size)
	control.add_theme_color_override("font_outline_color", Color("392012"))
	control.add_theme_constant_override("outline_size", 2)
	control.add_theme_color_override("font_shadow_color", Color(0.12, 0.06, 0.02, 0.85))
	control.add_theme_constant_override("shadow_offset_x", 2)
	control.add_theme_constant_override("shadow_offset_y", 3)

func _style_slider_cartoon(slider: HSlider) -> void:
	var track := StyleBoxFlat.new()
	track.bg_color = Color("432819")
	track.border_color = Color("d99737")
	track.set_border_width_all(2)
	track.set_corner_radius_all(8)
	slider.add_theme_stylebox_override("slider", track)
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("f2b841")
	fill.set_corner_radius_all(8)
	slider.add_theme_stylebox_override("grabber_area", fill)
	var highlight := StyleBoxFlat.new()
	highlight.bg_color = Color("ffd876")
	highlight.set_corner_radius_all(8)
	slider.add_theme_stylebox_override("grabber_area_highlight", highlight)

func _style_check_button_cartoon(check_button: CheckButton) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("59351f", 0.92)
	normal.border_color = Color("d99b39")
	normal.set_border_width_all(2)
	normal.set_corner_radius_all(12)
	normal.content_margin_left = 18
	normal.content_margin_right = 18
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("704627", 0.96)
	hover.border_color = Color("ffe087")
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("3f2a1c", 0.98)
	check_button.add_theme_stylebox_override("normal", normal)
	check_button.add_theme_stylebox_override("hover", hover)
	check_button.add_theme_stylebox_override("pressed", pressed)
	check_button.add_theme_stylebox_override("hover_pressed", hover)

func _style_option_button_cartoon(option: OptionButton) -> void:
	_style_cartoon_text(option, 23)
	option.add_theme_constant_override("h_separation", 24)
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("59351f")
	normal.border_color = Color("e4a735")
	normal.set_border_width_all(3)
	normal.set_corner_radius_all(14)
	normal.content_margin_left = 22
	normal.content_margin_right = 26
	normal.content_margin_top = 8
	normal.content_margin_bottom = 8
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("704627")
	hover.border_color = Color("ffe087")
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("3f2a1c")
	option.add_theme_stylebox_override("normal", normal)
	option.add_theme_stylebox_override("hover", hover)
	option.add_theme_stylebox_override("pressed", pressed)
	option.add_theme_stylebox_override("focus", hover)
	option.add_theme_color_override("font_color", Color("fff0bd"))
	option.add_theme_color_override("font_hover_color", Color("fff7d7"))
	option.add_theme_color_override("font_pressed_color", Color("fff0bd"))

func _style_line_edit_cartoon(edit: LineEdit) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("58361f")
	normal.border_color = Color("e9ae40")
	normal.set_border_width_all(3)
	normal.set_corner_radius_all(10)
	normal.content_margin_left = 16
	normal.content_margin_right = 16
	var focused := normal.duplicate() as StyleBoxFlat
	focused.border_color = Color("ffe28a")
	edit.add_theme_stylebox_override("normal", normal)
	edit.add_theme_stylebox_override("focus", focused)
	edit.add_theme_color_override("font_color", Color("fff0bd"))
	edit.add_theme_color_override("font_placeholder_color", Color("e5cba4"))

func _add_menu_button(caption: String, callback: Callable, button_size: Vector2 = Vector2(560, 140)) -> void:
	var button := Button.new()
	button.text = ""
	button.custom_minimum_size = button_size
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.focus_mode = Control.FOCUS_ALL
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	var source := load(MENU_BUTTONS_PATH) as Texture2D
	if source != null:
		var plaque := _button_plaque(source, 1)
		button.add_theme_stylebox_override("normal", _make_button_image_style(plaque, Color.WHITE))
		button.add_theme_stylebox_override("hover", _make_button_image_style(plaque, Color(1.16, 1.12, 0.96)))
		button.add_theme_stylebox_override("pressed", _make_button_image_style(plaque, Color(0.78, 0.68, 0.48)))
		button.add_theme_stylebox_override("focus", _make_button_image_style(plaque, Color(1.08, 1.04, 0.92)))
		button.mouse_entered.connect(func(): _animate_image_menu_button(button, Color(1.1, 1.06, 0.94)))
		button.mouse_exited.connect(func(): _animate_image_menu_button(button, Color.WHITE))
	else:
		var fallback := StyleBoxFlat.new()
		fallback.bg_color = Color("315171")
		fallback.border_color = Color("e7bd68")
		fallback.set_border_width_all(2)
		fallback.set_corner_radius_all(14)
		button.add_theme_stylebox_override("normal", fallback)
	_add_extruded_button_text(button, caption, mini(43, clampi(int(760.0 / maxf(float(caption.length()), 9.0)), 20, 43)))
	button.pressed.connect(callback)
	menu_content.add_child(button)

func _add_image_menu_button(caption: String, atlas_index: int, callback: Callable) -> void:
	var source := load(MENU_BUTTONS_PATH) as Texture2D
	if source == null:
		_add_menu_button(caption, callback)
		return
	var plaque := _button_plaque(source, atlas_index)
	var button := Button.new()
	button.name = "ImageButton_%s" % caption.to_pascal_case()
	button.focus_mode = Control.FOCUS_ALL
	button.custom_minimum_size = Vector2(560, 140)
	button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.text = ""
	var normal_style := _make_button_image_style(plaque, Color.WHITE)
	var hover_style := _make_button_image_style(plaque, Color(1.16, 1.12, 0.96))
	var pressed_style := _make_button_image_style(plaque, Color(0.78, 0.68, 0.48))
	button.add_theme_stylebox_override("normal", normal_style)
	button.add_theme_stylebox_override("hover", hover_style)
	button.add_theme_stylebox_override("pressed", pressed_style)
	button.add_theme_stylebox_override("focus", hover_style)
	_add_extruded_button_text(button, caption, 39)
	button.pressed.connect(callback)
	button.resized.connect(func(): button.pivot_offset = button.size / 2.0)
	button.mouse_entered.connect(func(): _animate_image_menu_button(button, Color(1.1, 1.06, 0.94), Vector2(1.025, 1.025)))
	button.mouse_exited.connect(func(): _animate_image_menu_button(button, Color.WHITE, Vector2.ONE))
	button.gui_input.connect(func(event: InputEvent):
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			_animate_image_menu_button(button, Color(0.9, 0.82, 0.66) if event.pressed else Color(1.1, 1.06, 0.94), Vector2(0.97, 0.97) if event.pressed else Vector2.ONE)
	)
	menu_content.add_child(button)

func _add_extruded_button_text(button: Button, caption: String, lettering_size: int = 39) -> void:
	# Stacked cartoon lettering gives the glyphs a raised, extruded look while
	# keeping the plaque artwork crisp and the button fully clickable.
	var layers := [
		{"offset":Vector2(0, 7), "fill":Color("54200c"), "outline":Color("54200c"), "outline_size":6},
		{"offset":Vector2(0, 3), "fill":Color("d47819"), "outline":Color("71320e"), "outline_size":4},
		{"offset":Vector2.ZERO, "fill":Color("fff0bd"), "outline":Color("63300f"), "outline_size":2}
	]
	for layer_data in layers:
		var label := Label.new()
		label.name = "RaisedLetterLayer"
		label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		var offset: Vector2 = layer_data["offset"]
		label.offset_left = offset.x
		label.offset_right = offset.x
		label.offset_top = offset.y
		label.offset_bottom = offset.y
		label.text = caption
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		label.add_theme_font_override("font", CARTOON_FONT)
		label.add_theme_font_size_override("font_size", lettering_size)
		label.add_theme_color_override("font_color", layer_data["fill"])
		label.add_theme_color_override("font_outline_color", layer_data["outline"])
		label.add_theme_constant_override("outline_size", layer_data["outline_size"])
		button.add_child(label)

func _button_plaque(source: Texture2D, atlas_index: int) -> AtlasTexture:
	var row_regions := [
		Rect2(280.0, 25.0, 970.0, 345.0),
		Rect2(280.0, 372.0, 970.0, 328.0),
		Rect2(280.0, 704.0, 970.0, 312.0)
	]
	var plaque := AtlasTexture.new()
	plaque.atlas = source
	plaque.region = row_regions[clampi(atlas_index, 0, row_regions.size() - 1)]
	return plaque

func _make_button_image_style(plaque: AtlasTexture, tint: Color) -> StyleBoxTexture:
	var style := StyleBoxTexture.new()
	style.texture = plaque
	style.modulate_color = tint
	style.texture_margin_left = 18.0
	style.texture_margin_right = 18.0
	style.texture_margin_top = 16.0
	style.texture_margin_bottom = 16.0
	style.content_margin_left = 18.0
	style.content_margin_right = 18.0
	style.content_margin_top = 8.0
	style.content_margin_bottom = 8.0
	return style

func _animate_image_menu_button(button: Button, target_tint: Color, target_scale: Vector2 = Vector2.ONE) -> void:
	if not is_instance_valid(button):
		return
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(button, "modulate", target_tint, 0.12)
	tween.parallel().tween_property(button, "scale", target_scale, 0.12)

func _add_tutorial_card(icon_text: String, description: String) -> void:
	var row := HBoxContainer.new()
	row.custom_minimum_size = Vector2(380, 34)
	var icon := Label.new()
	icon.text = icon_text
	icon.custom_minimum_size = Vector2(145, 32)
	icon.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_style_cartoon_text(icon, 19)
	icon.add_theme_color_override("font_color", Color("ffe39a"))
	row.add_child(icon)
	var text_label := Label.new()
	text_label.text = description
	text_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_style_cartoon_text(text_label, 18)
	text_label.add_theme_color_override("font_color", Color("f7f2df"))
	row.add_child(text_label)
	menu_content.add_child(row)

func _load_setting_float(key: String, fallback: float) -> float:
	var cfg := ConfigFile.new()
	cfg.load("user://settings.cfg")
	return float(cfg.get_value("settings", key, fallback))

func _load_setting_bool(key: String, fallback: bool) -> bool:
	var cfg := ConfigFile.new()
	cfg.load("user://settings.cfg")
	return bool(cfg.get_value("settings", key, fallback))

func _save_setting(key: String, value: Variant) -> void:
	var cfg := ConfigFile.new()
	cfg.load("user://settings.cfg")
	cfg.set_value("settings", key, value)
	cfg.save("user://settings.cfg")

func _on_volume_changed(value: float) -> void:
	var master_bus := AudioServer.get_bus_index("Master")
	if master_bus >= 0:
		AudioServer.set_bus_volume_linear(master_bus, value)
		AudioServer.set_bus_mute(master_bus, value <= 0.001)
	_save_setting("volume", value)

func _on_lights_toggled(enabled: bool) -> void:
	lights_enabled = enabled
	_save_setting("lights_enabled", enabled)
	var night_amount := 0.0
	if day_sky != null:
		night_amount = float(day_sky.get_shader_parameter("night_amount"))
	for glow in npc_night_lights:
		if is_instance_valid(glow):
			glow.visible = enabled and night_amount > 0.005
	for glow in chest_lights:
		if is_instance_valid(glow):
			glow.visible = enabled and night_amount > 0.005
	for firefly in firefly_nodes:
		if not is_instance_valid(firefly):
			continue
		var orb := firefly.get_node_or_null("FireflyOrb") as MeshInstance3D
		if orb != null:
			orb.visible = enabled and day_sky != null and float(day_sky.get_shader_parameter("night_amount")) > 0.005
		var glow := firefly.get_node_or_null("FireflyGlow") as OmniLight3D
		if glow != null:
			glow.visible = enabled and night_amount > 0.005

func _on_scale_selected(index: int) -> void:
	var factors := [0.85, 1.0, 1.15]
	var factor := float(factors[clampi(index, 0, factors.size() - 1)])
	get_window().content_scale_factor = factor
	_save_setting("ui_scale", factor)

func _create_room_from_menu() -> void:
	random_room_name = room_name_input.text.strip_edges() if room_name_input != null else ""
	room_password = room_password_input.text.strip_edges() if room_password_input != null else ""
	network_player_name = network_player_name_input.text.strip_edges() if network_player_name_input != null else "Jugador"
	if random_room_name.is_empty() or room_password.is_empty() or network_player_name.is_empty():
		_show_menu_page("create_room")
		_add_menu_label("Escribe el nombre de la sala, tu nombre y una contraseña.", 15)
		return
	room_password_hash = room_password.sha256_text()
	_host_network_game()
	if multiplayer.multiplayer_peer == null:
		_show_menu_page("create_room")
		_add_menu_label(network_status.text, 14)
		return
	var host_address := "127.0.0.1"
	for address in IP.get_local_addresses():
		var candidate := String(address)
		if candidate.contains(".") and not candidate.begins_with("127.") and not candidate.begins_with("169.254."):
			host_address = candidate
			break
	var nonce := str(randi_range(100000, 999999))
	var payload := "%s|7777|%s" % [host_address, nonce]
	random_room_code = Marshalls.raw_to_base64(payload.to_utf8_buffer()).replace("+", "-").replace("/", "_").replace("=", "")
	_show_menu_page("lobby")

func _decode_room_code(value: String) -> String:
	var code := value.strip_edges()
	if code.contains("."):
		return code
	code = code.replace("-", "+").replace("_", "/")
	while code.length() % 4 != 0:
		code += "="
	var payload := Marshalls.base64_to_raw(code).get_string_from_utf8()
	var parts := payload.split("|")
	if parts.size() >= 2 and parts[0].contains("."):
		return parts[0]
	return ""

func _join_room_code() -> void:
	if room_code_input == null or room_code_input.text.strip_edges().is_empty():
		_show_menu_page("quick_join")
		_add_menu_label("Escribe el código de sala y su contraseña.", 15)
		return
	join_room_code = room_code_input.text.strip_edges()
	join_password = join_password_input.text.strip_edges() if join_password_input != null else ""
	network_player_name = network_player_name_input.text.strip_edges() if network_player_name_input != null else "Jugador"
	if join_password.is_empty() or network_player_name.is_empty():
		_show_menu_page("quick_join")
		_add_menu_label("Escribe tu nombre y la contraseña para entrar.", 15)
		return
	var host := _decode_room_code(room_code_input.text)
	if host.is_empty():
		if network_status != null:
			network_status.text = "El código no es válido. Pide al anfitrión un código nuevo."
			_show_menu_page("quick_join")
			_add_menu_label(network_status.text, 15)
		return
	room_code_input.text = host
	address_input = room_code_input
	_join_network_game()
	if multiplayer.multiplayer_peer != null:
		_show_menu_page("waiting")

func _cancel_room() -> void:
	_stop_game_ambient_music()
	multiplayer.multiplayer_peer = null
	is_solo_mode = true
	is_network_host = false
	network_peer_ids.clear()
	pending_peer_passwords.clear()
	room_password = ""
	room_password_hash = ""
	join_password = ""
	join_room_code = ""
	network_player_names.clear()
	game_running = false
	gameplay_started = false
	player.controls_enabled = false
	player.set_physics_process(false)
	_set_gameplay_ui_visible(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_show_menu_page("home")

func _start_solo_game() -> void:
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer = null
	role_assignments = ROLE_MANAGER.assign_roles(1)
	local_roles = role_assignments[0]
	active_role_index = 0
	active_role = String(local_roles[0])
	is_solo_mode = true
	_reset_match_state()
	_update_role_ui()
	_update_information_hud()
	_launch_game()

func _start_network_match() -> void:
	if not is_network_host or network_peer_ids.size() < 2:
		_show_menu_page("lobby")
		_add_menu_label("Espera a que se conecte al menos otro jugador.", 15)
		return
	_reset_match_state()
	rpc("_receive_match_start")
	_launch_game()

@rpc("authority", "call_remote", "reliable")
func _receive_match_start() -> void:
	_reset_match_state()
	_launch_game()

func _reset_match_state() -> void:
	collected_info.clear()
	hero_is_carrying_card = false
	pending_card_chest_index = -1
	pending_card_clue = ""
	card_carrier_peer_id = 0
	_return_chest_letter_to_spawn()
	info_delivered = false
	journalist_has_documents = false
	_set_board_pages_placed(0)
	interviewed_npcs.clear()
	informed_npcs.clear()
	cheered_npcs.clear()
	bard_cooldowns.clear()
	bard_cheer_target = -1
	bard_cheer_elapsed = 0.0
	journalist_verified = false
	journalist_results.clear()
	journalist_puzzle_npc = -1
	journalist_puzzle_sequence.clear()
	journalist_puzzle_input.clear()
	journalist_claim_index = -1
	journalist_puzzle_stage = ""
	journalist_minigame_sequence.clear()
	journalist_minigame_input.clear()
	influencer_has_information = false
	journalist_correct_classifications = 0
	journalist_rejected_false_count = 0
	journalist_validated_info.clear()
	journalist_claims = JOURNALIST_CLAIMS.duplicate(true)
	influencer_delivery_queue.clear()
	influencer_delivery_cursor = 0
	shared_info_by_npc.clear()
	fraud_guard7_spoken = false
	fraud_letter_received = false
	fraud_case_resolved = false
	fraud_guard7_suspicion_stage = 0
	fraud_wrong_suspicions = 0
	fraud_owner_peer_id = 0
	_reset_revolutionary_rescue()
	fraud_guard6_concern_played = false
	guardian8_mission_completed = false
	guardian8_owner_peer_id = 0
	guardian8_dialogue_pending = false
	whale_puzzle_active = false
	whale_puzzle_tiles.clear()
	whale_puzzle_rotations.clear()
	whale_puzzle_held_tile = -1
	whale_puzzle_held_origin = -1
	if is_instance_valid(whale_puzzle_panel):
		whale_puzzle_panel.visible = false
	if guardian8 != null and is_instance_valid(guardian8):
		guardian8.global_position = guardian8_home_position
	npc_greeted.clear()
	final_classification_summary = ""
	answered = 0
	match_elapsed_seconds = 0.0
	completion_recorded_for_match = false
	roulette_role_uses.clear()
	roulette_spinning_wheels.clear()
	game_time_remaining = GAME_DURATION_SECONDS
	game_timer_timeout = false
	npc_mood_duration = NPC_MOOD_DURATION
	speed_boost_time = 0.0
	slow_time = 0.0
	double_jump_disabled_time = 0.0
	if is_instance_valid(player):
		player.set("max_air_jumps", 1)
		player.set("air_jumps_left", 1)
		player.set("speed", 6.0)
	for chest_info in info_chests:
		_close_chest_visual(chest_info.node as Node3D)
	for chest_sound_info in chest_proximity_players:
		var chest := chest_sound_info.node as Node3D
		if is_instance_valid(chest):
			chest.set_meta("chest_sound_opened", false)
	_stop_all_chest_proximity_sounds()
	var chest_progress := ConfigFile.new()
	chest_progress.set_value("progress", "opened_chests", [])
	chest_progress.save(CHEST_PROGRESS_PATH)
	for state in npc_targets:
		state.mood = 1.0
		state.seconds_left = npc_mood_duration
		state.recharging = false
		state.recharge_elapsed = 0.0

func _launch_game() -> void:
	if gameplay_started:
		return
	gameplay_started = true
	game_running = false
	if is_instance_valid(menu_root):
		menu_root.visible = false
	_set_gameplay_ui_visible(false)
	await _play_story_cinematic()
	if not is_inside_tree():
		return
	game_running = true
	game_timer_timeout = false
	_start_guardia_08_hop()
	day_cycle_elapsed = 0.0
	if is_instance_valid(player):
		var safe_spawn := _find_safe_spawn()
		player.global_position = safe_spawn + Vector3(0, 10, 0)
		player.last_safe_position = safe_spawn
		player.velocity = Vector3.ZERO
		player.visible = true
	if day_phase_presets.size() >= 3:
		_apply_day_phase(day_phase_presets[0], day_phase_presets[0], 0.0)
	_update_timer_hud()
	_update_information_hud()
	menu_root.visible = false
	_set_gameplay_ui_visible(true)
	player.controls_enabled = true
	player.set_physics_process(true)
	_start_spawn_intro()

func _return_to_menu() -> void:
	_stop_game_ambient_music()
	game_running = false
	gameplay_started = false
	player.controls_enabled = false
	player.set_physics_process(false)
	_set_gameplay_ui_visible(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_show_menu_page("home")

func _show_restart_confirmation() -> void:
	if not game_running or not is_instance_valid(restart_confirmation_root):
		return
	game_running = false
	if is_instance_valid(player):
		player.controls_enabled = false
		player.set_physics_process(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	restart_confirmation_root.visible = true

func _cancel_restart_confirmation() -> void:
	if is_instance_valid(restart_confirmation_root):
		restart_confirmation_root.visible = false
	if not gameplay_started:
		return
	game_running = true
	if is_instance_valid(player):
		player.controls_enabled = true
		player.set_physics_process(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _confirm_restart_match() -> void:
	if is_instance_valid(restart_confirmation_root):
		restart_confirmation_root.visible = false
	if multiplayer.multiplayer_peer != null:
		if is_network_host:
			rpc("_receive_restart_match")
			_perform_restart_match()
		else:
			rpc_id(1, "_request_restart_match")
		return
	_perform_restart_match()

func _perform_restart_match() -> void:
	_reset_match_state()
	gameplay_started = true
	game_running = true
	game_timer_timeout = false
	day_cycle_elapsed = 0.0
	if day_phase_presets.size() >= 3:
		_apply_day_phase(day_phase_presets[0], day_phase_presets[0], 0.0)
	if is_instance_valid(player):
		player.velocity = Vector3.ZERO
		var safe_spawn := _find_safe_spawn()
		player.global_position = safe_spawn + Vector3(0, 10, 0)
		player.last_safe_position = safe_spawn
		player.visible = true
		player.controls_enabled = true
		player.set_physics_process(true)
	if is_instance_valid(camera):
		camera.make_current()
	if is_instance_valid(panel):
		panel.visible = false
	if is_instance_valid(prompt_panel):
		prompt_panel.visible = false
	_update_timer_hud()
	_update_role_ui()
	_update_information_hud()
	_set_gameplay_ui_visible(true)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	_broadcast_coop_state()
	_start_spawn_intro()

@rpc("any_peer", "call_remote", "reliable")
func _request_restart_match() -> void:
	if not multiplayer.is_server() or not is_network_host:
		return
	rpc("_receive_restart_match")
	_perform_restart_match()

@rpc("authority", "call_remote", "reliable")
func _receive_restart_match() -> void:
	_perform_restart_match()

func _end_game(won: bool, defeat_cause: String = "timeout") -> void:
	if won:
		_record_player_completion_time()
	_stop_game_ambient_music()
	game_running = false
	if not won:
		last_defeat_cause = defeat_cause
		_reset_match_state()
	player.controls_enabled = false
	player.set_physics_process(false)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	_set_gameplay_ui_visible(false)
	_show_menu_page("victory" if won else "defeat")

func _check_game_completion() -> void:
	if not game_running:
		return
	var all_objectives_complete := collected_info.size() >= REQUIRED_INFO_CHESTS and info_delivered
	all_objectives_complete = all_objectives_complete and interviewed_npcs.size() == npc_targets.size() and journalist_verified
	all_objectives_complete = all_objectives_complete and informed_npcs.size() == npc_targets.size()
	all_objectives_complete = all_objectives_complete and influencer_delivery_cursor >= influencer_delivery_queue.size() and cheered_npcs.size() == npc_targets.size()
	all_objectives_complete = all_objectives_complete and fraud_case_resolved
	all_objectives_complete = all_objectives_complete and guardian8_mission_completed
	if all_objectives_complete:
		if journalist_correct_classifications == JOURNALIST_CLAIMS.size():
			final_classification_summary = "FINAL LIMPIO · El Mensajero clasificó correctamente los diez datos. Solo la información verdadera llegó a los vecinos."
		else:
			final_classification_summary = "FINAL IRREGULAR · Aciertos del Mensajero: %d / %d. El reino frenó el anuncio, pero quedaron errores de verificación y cabos sueltos." % [journalist_correct_classifications, JOURNALIST_CLAIMS.size()]
		_end_game(true)

func _update_timer_hud() -> void:
	if time_progress == null:
		return
	time_progress.max_value = maxf(GAME_DURATION_SECONDS, game_time_remaining)
	time_progress.value = game_time_remaining
	var progress_ratio := game_time_remaining / time_progress.max_value
	var total_seconds := ceili(game_time_remaining)
	time_label.text = "%02d:%02d" % [total_seconds / 60, total_seconds % 60]
	var pulse := 0.5 + 0.5 * sin(Time.get_ticks_msec() / 160.0)
	var urgent := 1.0 - clampf(progress_ratio / 0.25, 0.0, 1.0)
	time_fill_style.bg_color = Color("66d5a7").lerp(Color("f0b643"), 1.0 - progress_ratio)
	time_fill_style.bg_color = time_fill_style.bg_color.lerp(Color("ed6262"), urgent * (0.62 + pulse * 0.18))
	time_label.add_theme_color_override("font_color", Color("fff0bd").lerp(Color("ffd0a0"), urgent * (0.4 + pulse * 0.12)))
	time_label.scale = Vector2.ONE * (1.0 + urgent * pulse * 0.055)

func _build_ui() -> void:
	var layer := CanvasLayer.new()
	ui_layer = layer
	add_child(layer)
	var top := PanelContainer.new()
	top.name = "GameplayStatus"
	gameplay_top_panel = top
	top.position = gameplay_top_panel_home_position
	top.custom_minimum_size = Vector2(420, 240)
	_style_atlas_panel(top, Vector2(420, 240))
	var mission_card := Control.new()
	mission_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var mission_frame := TextureRect.new()
	mission_frame.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mission_frame.texture = _game_ui_atlas_region(Rect2(872, 625, 656, 383))
	mission_frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	mission_frame.stretch_mode = TextureRect.STRETCH_SCALE
	mission_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	mission_card.add_child(mission_frame)
	var top_content := VBoxContainer.new()
	top_content.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	top_content.offset_left = 42
	top_content.offset_right = -42
	top_content.offset_top = 48
	top_content.offset_bottom = -24
	var top_label := Label.new()
	top_label.text = "ALCALDE DIGITAL     ◆     CIUDAD EN RED\nVerifica antes de compartir  ·  Explora tres distritos"
	_style_cartoon_text(top_label, 20)
	top_label.visible = false
	top_content.add_child(top_label)
	solo_role_button = Button.new()
	solo_role_button.custom_minimum_size = Vector2(320, 38)
	_style_cartoon_text(solo_role_button, 19)
	_style_wood_button(solo_role_button)
	solo_role_button.pressed.connect(_cycle_solo_role)
	top_content.add_child(solo_role_button)
	network_button = Button.new()
	network_button.text = "Multijugador por red"
	_style_cartoon_text(network_button, 19)
	network_button.visible = false
	network_button.custom_minimum_size = Vector2(450, 34)
	network_button.pressed.connect(_open_network_panel)
	top_content.add_child(network_button)
	top.custom_minimum_size = Vector2(420, 240)
	hud = Label.new()
	_style_cartoon_text(hud, 17)
	hud.add_theme_color_override("font_color", Color("fff0bd"))
	hud.custom_minimum_size = Vector2(328, 112)
	hud.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hud.text = "◆ Ciudadanía: 0 / 3     ◆ Confianza: 100%"
	top_content.add_child(hud)
	mission_card.add_child(top_content)
	top.add_child(mission_card)
	layer.add_child(top)
	gameplay_role_symbols_row = HBoxContainer.new()
	gameplay_role_symbols_row.name = "AssignedRoleSymbols"
	gameplay_role_symbols_row.position = gameplay_role_symbols_home_position
	gameplay_role_symbols_row.add_theme_constant_override("separation", 8)
	gameplay_role_symbols_row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	gameplay_role_symbols_row.visible = false
	layer.add_child(gameplay_role_symbols_row)
	var bottom := PanelContainer.new()
	gameplay_bottom_panel = bottom
	bottom.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	bottom.offset_top = -62
	bottom.offset_bottom = -14
	_style_panel(bottom, Color("171d2b"), Color("526c83"))
	var bottom_label := Label.new()
	bottom_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	bottom_label.text = "WASD mover · Ratón mirar · ESPACIO saltar · E interactuar · Q misiones extra · TAB cambiar rol"
	bottom_label.visible = false
	_style_cartoon_text(bottom_label, 17)
	bottom.add_child(bottom_label)
	layer.add_child(bottom)
	var crosshair := Label.new()
	gameplay_crosshair = crosshair
	crosshair.set_anchors_preset(Control.PRESET_CENTER)
	crosshair.offset_left = -9
	crosshair.offset_top = -14
	crosshair.offset_right = 9
	crosshair.offset_bottom = 14
	crosshair.text = "+"
	crosshair.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	crosshair.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_style_cartoon_text(crosshair, 20)
	crosshair.add_theme_color_override("font_color", Color("e8f5ff"))
	crosshair.add_theme_color_override("font_shadow_color", Color("111827"))
	crosshair.add_theme_constant_override("shadow_offset_x", 1)
	crosshair.add_theme_constant_override("shadow_offset_y", 1)
	layer.add_child(crosshair)
	prompt = Label.new()
	prompt_panel = PanelContainer.new()
	prompt_panel.name = "InteractionPlaque"
	prompt_panel.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	_style_texture_board(prompt_panel, Rect2(985, 230, 1015, 280), Vector2.ZERO, Vector4(54, 54, 22, 22))
	prompt.custom_minimum_size = Vector2.ZERO
	prompt.visible = false # Keep the original interaction text as the state source.
	var prompt_row := HBoxContainer.new()
	prompt_row.name = "InteractionPlaqueContent"
	prompt_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	prompt_row.alignment = BoxContainer.ALIGNMENT_CENTER
	prompt_row.add_theme_constant_override("separation", 14)
	var keycap_panel := PanelContainer.new()
	keycap_panel.name = "ActionKeycapFrame"
	keycap_panel.custom_minimum_size = Vector2(62, 56)
	keycap_panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	keycap_panel.add_theme_stylebox_override("panel", _dialogue_keycap_style())
	prompt_keycap_label = Label.new()
	prompt_keycap_label.name = "ActionKeycap"
	prompt_keycap_label.custom_minimum_size = Vector2(52, 48)
	prompt_keycap_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_keycap_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_style_cartoon_text(prompt_keycap_label, 22)
	prompt_keycap_label.add_theme_color_override("font_color", Color("fff0d0"))
	keycap_panel.add_child(prompt_keycap_label)
	prompt_row.add_child(keycap_panel)
	prompt_action_label = Label.new()
	prompt_action_label.name = "ActionText"
	prompt_action_label.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	prompt_action_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	prompt_action_label.custom_minimum_size = Vector2(190, 60)
	prompt_action_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	prompt_action_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	prompt_action_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_style_cartoon_text(prompt_action_label, 19)
	prompt_action_label.add_theme_color_override("font_color", Color("fff0d0"))
	prompt_row.add_child(prompt_action_label)
	prompt_panel.add_child(prompt_row)
	layer.add_child(prompt_panel)
	panel = PanelContainer.new()
	panel.name = "DialogueNoticeBoard"
	panel.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
	panel.custom_minimum_size = Vector2.ZERO
	panel.visible = false
	_style_texture_board(panel, Rect2(18, 0, 980, 770), Vector2.ZERO, Vector4(86, 86, 105, 70))
	var dialogue_content := VBoxContainer.new()
	dialogue_content.name = "DialogueContent"
	dialogue_content.add_theme_constant_override("separation", 12)
	var title_row := HBoxContainer.new()
	title_row.name = "DialogueTitleRow"
	title_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_row.alignment = BoxContainer.ALIGNMENT_CENTER
	dialogue_title_holder = Control.new()
	dialogue_title_holder.name = "DialogueTitleHolder"
	dialogue_title_holder.custom_minimum_size = Vector2(0, 72)
	dialogue_title_holder.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	dialogue_title_plaque = PanelContainer.new()
	dialogue_title_plaque.name = "DialogueTitlePlaque"
	dialogue_title_plaque.set_anchors_preset(Control.PRESET_TOP_LEFT)
	dialogue_title_plaque.custom_minimum_size = Vector2(0, 52)
	dialogue_title_plaque.add_theme_stylebox_override("panel", _dialogue_title_style())
	dialogue_title_label = Label.new()
	dialogue_title_label.name = "DialogueTitle"
	dialogue_title_label.custom_minimum_size = Vector2(0, 40)
	dialogue_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialogue_title_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_style_cartoon_text(dialogue_title_label, 24)
	dialogue_title_label.add_theme_color_override("font_color", Color("fff0bd"))
	dialogue_title_plaque.add_child(dialogue_title_label)
	dialogue_title_holder.add_child(dialogue_title_plaque)
	title_row.add_child(dialogue_title_holder)
	dialogue_content.add_child(title_row)
	var dialogue_body_wrap := MarginContainer.new()
	dialogue_body_wrap.name = "DialogueBodyArea"
	dialogue_body_wrap.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dialogue_body_wrap.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dialogue_body_label = Label.new()
	dialogue_body_label.name = "DialogueBody"
	dialogue_body_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	dialogue_body_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP
	dialogue_body_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	dialogue_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_style_cartoon_text(dialogue_body_label, 22)
	dialogue_body_label.add_theme_color_override("font_color", Color("fff4d7"))
	dialogue_body_label.add_theme_color_override("font_shadow_color", Color("51301a"))
	dialogue_body_label.add_theme_constant_override("shadow_offset_x", 1)
	dialogue_body_label.add_theme_constant_override("shadow_offset_y", 2)
	dialogue_body_wrap.add_child(dialogue_body_label)
	dialogue_content.add_child(dialogue_body_wrap)
	panel_text = Label.new()
	panel_text.visible = false
	panel.add_child(dialogue_content)
	layer.add_child(panel)
	get_viewport().size_changed.connect(_layout_dialogue_board)
	_layout_dialogue_board()
	_build_whale_puzzle_ui(layer)
	network_panel = PanelContainer.new()
	network_panel.set_anchors_preset(Control.PRESET_CENTER)
	network_panel.position = Vector2(-250, -145)
	network_panel.custom_minimum_size = Vector2(500, 290)
	network_panel.visible = false
	_style_panel(network_panel, Color("171d2b"), Color("73c9c9"))
	var network_box := VBoxContainer.new()
	var network_title := Label.new()
	network_title.text = "PARTIDA COOPERATIVA · RED/INTERNET"
	_style_cartoon_text(network_title, 23)
	network_box.add_child(network_title)
	var network_instructions := Label.new()
	network_instructions.text = "El anfitrión crea la sala. Los demás se conectan con su IP pública o LAN. Puerto UDP: 7777. Para jugar por Internet, el anfitrión debe permitir/redirigir ese puerto en su router."
	network_instructions.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_style_cartoon_text(network_instructions, 18)
	network_box.add_child(network_instructions)
	var host_button := Button.new()
	host_button.text = "Crear sala (anfitrión)"
	_style_cartoon_text(host_button, 20)
	host_button.pressed.connect(_host_network_game)
	network_box.add_child(host_button)
	address_input = LineEdit.new()
	address_input.placeholder_text = "IP del anfitrión (ej. 192.168.1.20)"
	_style_cartoon_text(address_input, 19)
	_style_line_edit_cartoon(address_input)
	network_box.add_child(address_input)
	network_password_input = LineEdit.new()
	network_password_input.placeholder_text = "Contraseña de la sala"
	network_password_input.secret = true
	_style_cartoon_text(network_password_input, 19)
	_style_line_edit_cartoon(network_password_input)
	network_box.add_child(network_password_input)
	var join_button := Button.new()
	join_button.text = "Conectarme"
	_style_cartoon_text(join_button, 20)
	join_button.pressed.connect(_join_network_game)
	network_box.add_child(join_button)
	var exit_network_button := Button.new()
	exit_network_button.text = "Volver a modo solitario"
	_style_cartoon_text(exit_network_button, 20)
	exit_network_button.pressed.connect(_exit_network_game)
	network_box.add_child(exit_network_button)
	network_status = Label.new()
	network_status.text = "Admite 2–4 jugadores. Los roles se sortean sin repetirse."
	network_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_style_cartoon_text(network_status, 18)
	network_box.add_child(network_status)
	network_panel.add_child(network_box)
	layer.add_child(network_panel)
	var timer_container := Control.new()
	self.timer_container = timer_container
	timer_container.name = "KingdomTimer"
	timer_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	timer_container.set_anchors_preset(Control.PRESET_CENTER_TOP)
	timer_container.offset_left = -270
	timer_container.offset_top = 150
	timer_container.offset_right = 270
	timer_container.offset_bottom = 296
	time_frame = TextureRect.new()
	time_frame.position = Vector2.ZERO
	time_frame.size = Vector2(180, 68)
	time_frame.texture = _game_ui_atlas_region(Rect2(22, 674, 642, 98))
	time_frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	time_frame.stretch_mode = TextureRect.STRETCH_SCALE
	time_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	time_frame.visible = false
	timer_container.add_child(time_frame)
	time_label_frame = TextureRect.new()
	time_label_frame.position = Vector2.ZERO
	time_label_frame.size = Vector2(180, 68)
	time_label_frame.texture = _game_ui_atlas_region(Rect2(879, 57, 382, 157))
	time_label_frame.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	time_label_frame.stretch_mode = TextureRect.STRETCH_SCALE
	time_label_frame.mouse_filter = Control.MOUSE_FILTER_IGNORE
	timer_container.add_child(time_label_frame)
	var timer_background := StyleBoxFlat.new()
	timer_background.bg_color = Color("28160f")
	timer_background.set_corner_radius_all(12)
	timer_background.content_margin_left = 0
	timer_background.content_margin_right = 0
	timer_background.content_margin_top = 0
	timer_background.content_margin_bottom = 0
	time_progress = ProgressBar.new()
	time_progress.position = Vector2(49, 78)
	time_progress.size = Vector2(442, 34)
	time_progress.visible = false
	time_progress.min_value = 0.0
	time_progress.max_value = GAME_DURATION_SECONDS
	time_progress.value = GAME_DURATION_SECONDS
	time_progress.show_percentage = false
	time_progress.add_theme_stylebox_override("background", timer_background)
	var timer_fill := StyleBoxFlat.new()
	time_fill_style = timer_fill
	timer_fill.bg_color = Color("66d5a7")
	timer_fill.set_corner_radius_all(8)
	time_progress.add_theme_stylebox_override("fill", timer_fill)
	timer_container.add_child(time_progress)
	time_label = Label.new()
	time_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	time_label.offset_left = -76
	time_label.offset_top = 15
	time_label.offset_right = 76
	time_label.offset_bottom = 49
	time_label.text = "10:00"
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	time_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	time_label.pivot_offset = Vector2(76, 17)
	_style_cartoon_text(time_label, 25)
	time_label.add_theme_color_override("font_color", Color("fff0bd"))
	timer_container.add_child(time_label)
	layer.add_child(timer_container)
	get_viewport().size_changed.connect(_layout_game_hud)
	_layout_game_hud()
	var menu_scene := load("res://scenes/main_menu_ui.tscn") as PackedScene
	var background_root := menu_scene.instantiate() as Control
	background_root.name = "MainMenu"
	background_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(background_root)
	menu_root = background_root
	home_screen = background_root.get_node("HomeScreen") as Control
	_build_player_name_screen(background_root)
	background_root.connect("play_requested", func(): _show_menu_page("player_name"))
	background_root.connect("tutorial_requested", func(): _show_menu_page("tutorial"))
	background_root.connect("settings_requested", func(): _show_menu_page("settings"))
	menu_panel = PanelContainer.new()
	menu_panel.set_anchors_preset(Control.PRESET_CENTER)
	menu_panel.offset_left = -250
	menu_panel.offset_top = -300
	menu_panel.offset_right = 250
	menu_panel.offset_bottom = 300
	menu_panel.mouse_filter = Control.MOUSE_FILTER_PASS
	var menu_style := StyleBoxFlat.new()
	menu_style.bg_color = Color(0, 0, 0, 0)
	menu_style.border_color = Color(0, 0, 0, 0)
	menu_style.set_border_width_all(0)
	menu_panel.add_theme_stylebox_override("panel", menu_style)
	var menu_margin := MarginContainer.new()
	menu_margin.add_theme_constant_override("margin_left", 22)
	menu_margin.add_theme_constant_override("margin_right", 22)
	menu_margin.add_theme_constant_override("margin_top", 20)
	menu_margin.add_theme_constant_override("margin_bottom", 20)
	menu_content = VBoxContainer.new()
	menu_content.add_theme_constant_override("separation", 12)
	menu_margin.add_child(menu_content)
	menu_panel.add_child(menu_margin)
	background_root.add_child(menu_panel)
	restart_button = Button.new()
	restart_button.name = "RestartMatchButton"
	restart_button.text = ""
	restart_button.tooltip_text = "Reiniciar partida"
	restart_button.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	restart_button.offset_left = -154
	restart_button.offset_top = -130
	restart_button.offset_right = -18
	restart_button.offset_bottom = -18
	restart_button.custom_minimum_size = Vector2(136, 112)
	restart_button.focus_mode = Control.FOCUS_ALL
	restart_button.pivot_offset = restart_button.custom_minimum_size * 0.5
	_style_cartoon_text(restart_button, 24)
	_style_restart_button(restart_button)
	restart_button.mouse_entered.connect(func() -> void: _animate_restart_button(true))
	restart_button.mouse_exited.connect(func() -> void: _animate_restart_button(false))
	restart_button.button_down.connect(func() -> void: _press_restart_button(true))
	restart_button.button_up.connect(func() -> void: _press_restart_button(false))
	restart_button.pressed.connect(_show_restart_confirmation)
	layer.add_child(restart_button)
	restart_confirmation_root = Control.new()
	restart_confirmation_root.name = "RestartConfirmation"
	restart_confirmation_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	restart_confirmation_root.visible = false
	restart_confirmation_root.mouse_filter = Control.MOUSE_FILTER_STOP
	var restart_shade := ColorRect.new()
	restart_shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	restart_shade.color = Color(0.025, 0.035, 0.07, 0.72)
	restart_shade.mouse_filter = Control.MOUSE_FILTER_STOP
	restart_confirmation_root.add_child(restart_shade)
	restart_confirmation_panel = PanelContainer.new()
	restart_confirmation_panel.set_anchors_preset(Control.PRESET_CENTER)
	restart_confirmation_panel.offset_left = -270
	restart_confirmation_panel.offset_top = -125
	restart_confirmation_panel.offset_right = 270
	restart_confirmation_panel.offset_bottom = 125
	_style_wood_panel(restart_confirmation_panel, Color("432a1d"), Vector2(540, 250))
	var restart_box := VBoxContainer.new()
	restart_box.add_theme_constant_override("separation", 10)
	var restart_title := Label.new()
	restart_title.text = "¿REINICIAR LA PARTIDA?"
	restart_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_style_cartoon_text(restart_title, 25)
	restart_title.add_theme_color_override("font_color", Color("ffe39a"))
	restart_box.add_child(restart_title)
	var restart_description := Label.new()
	restart_description.text = "Los cofres, las misiones y el ánimo de los vecinos volverán al inicio."
	restart_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	restart_description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_style_cartoon_text(restart_description, 18)
	restart_description.add_theme_color_override("font_color", Color("fff0d0"))
	restart_box.add_child(restart_description)
	var restart_actions := HBoxContainer.new()
	restart_actions.alignment = BoxContainer.ALIGNMENT_CENTER
	restart_actions.add_theme_constant_override("separation", 18)
	var confirm_restart_button := Button.new()
	confirm_restart_button.text = "SÍ, REINICIAR"
	confirm_restart_button.custom_minimum_size = Vector2(190, 46)
	_style_cartoon_text(confirm_restart_button, 19)
	_style_wood_button(confirm_restart_button)
	confirm_restart_button.pressed.connect(_confirm_restart_match)
	restart_actions.add_child(confirm_restart_button)
	var cancel_restart_button := Button.new()
	cancel_restart_button.text = "CANCELAR"
	cancel_restart_button.custom_minimum_size = Vector2(155, 46)
	_style_cartoon_text(cancel_restart_button, 19)
	_style_wood_button(cancel_restart_button)
	cancel_restart_button.pressed.connect(_cancel_restart_confirmation)
	restart_actions.add_child(cancel_restart_button)
	restart_box.add_child(restart_actions)
	restart_confirmation_panel.add_child(restart_box)
	restart_confirmation_root.add_child(restart_confirmation_panel)
	layer.add_child(restart_confirmation_root)
	background_root.visible = false
	gameplay_top_panel.visible = false
	gameplay_bottom_panel.visible = false
	gameplay_crosshair.visible = false
	prompt_panel.visible = false
	timer_container.visible = false
	restart_button.visible = false
	_update_role_ui()
	_update_information_hud()

func _layout_game_hud() -> void:
	if not is_instance_valid(timer_container):
		return
	if get_viewport().get_visible_rect().size.x >= 1120.0:
		timer_container.set_anchors_preset(Control.PRESET_TOP_RIGHT)
		timer_container.offset_left = -200
		timer_container.offset_top = 16
		timer_container.offset_right = -20
		timer_container.offset_bottom = 84
	else:
		timer_container.set_anchors_preset(Control.PRESET_CENTER_TOP)
		timer_container.offset_left = -90
		timer_container.offset_top = 266
		timer_container.offset_right = 90
		timer_container.offset_bottom = 334

func _cycle_solo_role() -> void:
	if local_roles.size() < 2:
		return
	active_role_index = (active_role_index + 1) % local_roles.size()
	active_role = String(local_roles[active_role_index])
	_update_role_ui()
	_update_information_hud()

func _update_role_ui() -> void:
	if solo_role_button == null:
		return
	solo_role_button.visible = local_roles.size() > 1
	solo_role_button.disabled = local_roles.size() < 2
	solo_role_button.text = "MISIONES"
	_update_role_symbols()
	if network_button != null:
		network_button.text = "Red: %d jugador(es)" % maxi(1, network_peer_ids.size())
	_apply_role_hud_color()

func _update_role_symbols() -> void:
	if not is_instance_valid(gameplay_role_symbols_row):
		return
	for child in gameplay_role_symbols_row.get_children():
		gameplay_role_symbols_row.remove_child(child)
		child.queue_free()
	var role := active_role
	var tile := Control.new()
	tile.name = "RoleSymbol_" + role.replace(" ", "_")
	tile.custom_minimum_size = Vector2(116, 116)
	tile.tooltip_text = _role_display_name(role)
	var medallion := TextureRect.new()
	medallion.name = "MedallionFrame"
	medallion.texture = ROLE_SYMBOL_MEDALLION
	medallion.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	medallion.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	medallion.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	medallion.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tile.add_child(medallion)
	var symbol := TextureRect.new()
	symbol.name = "Symbol"
	var atlas_region := AtlasTexture.new()
	atlas_region.atlas = ROLE_SYMBOLS_ATLAS
	atlas_region.region = _role_symbol_region(role)
	symbol.texture = atlas_region
	symbol.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	symbol.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	symbol.position = Vector2(23, 22)
	symbol.size = Vector2(70, 72)
	symbol.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tile.add_child(symbol)
	gameplay_role_symbols_row.add_child(tile)
	var name_plate := PanelContainer.new()
	name_plate.name = "ActiveRoleNamePlate"
	name_plate.custom_minimum_size = Vector2(260, 72)
	name_plate.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	name_plate.tooltip_text = "Rol activo"
	var name_style := StyleBoxTexture.new()
	name_style.texture = _game_ui_atlas_region(Rect2(20, 15, 820, 220))
	name_style.content_margin_left = 18
	name_style.content_margin_right = 18
	name_style.content_margin_top = 12
	name_style.content_margin_bottom = 0
	name_plate.add_theme_stylebox_override("panel", name_style)
	var name_label := Label.new()
	name_label.name = "ActiveRoleName"
	name_label.text = _role_display_name(role).to_upper()
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	name_label.custom_minimum_size = Vector2(228, 48)
	_style_cartoon_text(name_label, 24)
	name_label.add_theme_color_override("font_color", Color("fff0bd"))
	name_label.add_theme_color_override("font_shadow_color", Color("2b170d"))
	name_label.add_theme_constant_override("shadow_offset_x", 2)
	name_label.add_theme_constant_override("shadow_offset_y", 3)
	name_plate.add_child(name_label)
	gameplay_role_symbols_row.add_child(name_plate)

func _role_symbol_region(role: String) -> Rect2:
	match role:
		"Ciudadano": return Rect2(72, 0, 568, 572) # Héroe · escudo
		"Periodista": return Rect2(666, 0, 646, 558) # Mensajero · carta
		"Influencer": return Rect2(90, 552, 570, 647) # Bardo · laúd
		"Candidato a alcalde": return Rect2(680, 552, 632, 647) # Revolucionario · estandarte
		_: return Rect2(72, 0, 568, 572)

func _role_accent_color(role: String) -> Color:
	match role:
		"Ciudadano": return Color("f5c64e") # Héroe · amarillo
		"Periodista": return Color("61b9f3") # Mensajero · azul
		"Influencer": return Color("c17bea") # Bardo · morado
		"Candidato a alcalde": return Color("f06a68") # Revolucionario · rojo
		_: return Color("f5c64e")

func _apply_role_hud_color() -> void:
	var accent := _role_accent_color(active_role)
	if is_instance_valid(gameplay_top_panel):
		var mission_style := StyleBoxFlat.new()
		mission_style.bg_color = Color(0, 0, 0, 0)
		mission_style.border_color = Color(0, 0, 0, 0)
		mission_style.set_border_width_all(0)
		mission_style.content_margin_left = 0
		mission_style.content_margin_right = 0
		mission_style.content_margin_top = 0
		mission_style.content_margin_bottom = 0
		mission_panel_style = mission_style
		gameplay_top_panel.add_theme_stylebox_override("panel", mission_style)
	if is_instance_valid(hud):
		hud.add_theme_color_override("font_color", accent.lightened(0.24))
	if is_instance_valid(solo_role_button):
		var normal := StyleBoxFlat.new()
		normal.bg_color = Color("663d23")
		normal.border_color = accent
		normal.set_border_width_all(2)
		normal.set_corner_radius_all(10)
		normal.content_margin_left = 12
		normal.content_margin_right = 12
		var hover := normal.duplicate() as StyleBoxFlat
		hover.bg_color = Color("80502a")
		hover.border_color = accent.lightened(0.28)
		var pressed := normal.duplicate() as StyleBoxFlat
		pressed.bg_color = Color("432a1d")
		solo_role_button.add_theme_stylebox_override("normal", normal)
		solo_role_button.add_theme_stylebox_override("hover", hover)
		solo_role_button.add_theme_stylebox_override("pressed", pressed)
		solo_role_button.add_theme_stylebox_override("focus", hover)
		solo_role_button.add_theme_color_override("font_color", accent.lightened(0.38))
		solo_role_button.add_theme_color_override("font_hover_color", Color("fff7d7"))
		solo_role_button.add_theme_color_override("font_pressed_color", accent.lightened(0.38))

func _role_display_name(role: String) -> String:
	match role:
		"Ciudadano": return "Héroe"
		"Periodista": return "Mensajero"
		"Influencer": return "Bardo"
		"Candidato a alcalde": return "Revolucionario"
		_: return role

func _role_mission(role: String) -> String:
	match role:
		"Ciudadano":
			if info_delivered: return "Cartas entregadas: 10/10 · tablón completo"
			if hero_is_carrying_card: return "Lleva la carta al tablón · %d/10" % mini(collected_info.size(), REQUIRED_INFO_CHESTS)
			if pending_card_chest_index >= 0: return "Recoge la carta del cofre y llévala al tablón · %d/10" % mini(collected_info.size(), REQUIRED_INFO_CHESTS)
			return "Abre un cofre, recoge su carta y entrégala · %d/10" % mini(collected_info.size(), REQUIRED_INFO_CHESTS)
		"Periodista":
			if journalist_verified: return "Información verificada"
			if not info_delivered: return "Entrevista vecinos: %d/%d · espera el tablón" % [interviewed_npcs.size(), npc_targets.size()]
			if not journalist_has_documents: return "Recoge el expediente del tablón y llévalo al escritorio"
			if interviewed_npcs.size() < npc_targets.size(): return "Entrevista vecinos: %d/%d" % [interviewed_npcs.size(), npc_targets.size()]
			return "Analiza los datos en el escritorio: %d/%d" % [maxi(journalist_claim_index, 0), journalist_claims.size()]
		"Influencer":
			if not guardian8_mission_completed:
				return "Intervén con Guardia 8: completa el rompecabezas" if guardian8_owner_peer_id == 0 or _is_guardian8_event_owner() else "Guardia 8: otro jugador se encarga"
			if not influencer_has_information: return "Espera la información del Mensajero"
			return "Difunde datos verificados: %d/%d" % [influencer_delivery_cursor, influencer_delivery_queue.size()]
		"Candidato a alcalde":
			if not revolutionary_rescue_completed:
				if revolutionary_rescue_has_knife: return "Lleva el cuchillo con Guardia 9 y pulsa Q para liberarlo"
				if revolutionary_rescue_started: return "Recoge el cuchillo y vuelve con Guardia 9"
				return "Habla con Guardia 9 y busca algo filoso"
			if not guardian8_mission_completed:
				return "Intervén con Guardia 8: completa el rompecabezas" if guardian8_owner_peer_id == 0 or _is_guardian8_event_owner() else "Guardia 8: otro jugador se encarga"
			return "Anima a vecinos: %d/%d" % [cheered_npcs.size(), npc_targets.size()]
		_: return "Completa tu misión"

func _open_network_panel() -> void:
	if network_panel != null:
		network_panel.visible = not network_panel.visible

func _host_network_game() -> void:
	var peer := ENetMultiplayerPeer.new()
	var result := peer.create_server(COOP_PORT, MAX_COOP_PLAYERS - 1)
	if result != OK:
		network_status.text = "No se pudo abrir el puerto 7777. Código: %d" % result
		return
	multiplayer.multiplayer_peer = peer
	is_network_host = true
	is_solo_mode = false
	network_peer_ids = [1]
	network_player_names = {1: network_player_name}
	pending_peer_passwords.clear()
	network_status.text = "Sala creada en el puerto %d. Esperando jugadores (2–4)." % COOP_PORT
	_update_role_ui()

func _join_network_game() -> void:
	var address := address_input.text.strip_edges()
	if address.is_empty():
		network_status.text = "Escribe la IP del anfitrión."
		return
	if join_password.is_empty() and network_password_input != null:
		join_password = network_password_input.text.strip_edges()
	if join_password.is_empty():
		network_status.text = "Escribe la contraseña de la sala."
		return
	var peer := ENetMultiplayerPeer.new()
	var result := peer.create_client(address, COOP_PORT)
	if result != OK:
		network_status.text = "No se pudo iniciar la conexión. Código: %d" % result
		return
	multiplayer.multiplayer_peer = peer
	is_solo_mode = false
	network_status.text = "Conectando con %s:%d…" % [address, COOP_PORT]

func _on_network_peer_connected(peer_id: int) -> void:
	if not is_network_host:
		return
	# A transport connection is not a room member until its password is checked.
	pending_peer_passwords[peer_id] = true

func _on_network_peer_disconnected(peer_id: int) -> void:
	if not is_network_host:
		return
	pending_peer_passwords.erase(peer_id)
	if network_peer_ids.has(peer_id):
		network_peer_ids.erase(peer_id)
		network_player_names.erase(peer_id)
		_sync_room_members.rpc(network_player_names, random_room_name, random_room_code)
		_sync_room_members(network_player_names, random_room_name, random_room_code)
		_update_role_ui()
		if network_peer_ids.size() >= 2:
			_assign_network_roles()
		if is_instance_valid(menu_root) and menu_root.visible:
			_show_menu_page("lobby")

func _on_connected_to_server() -> void:
	network_status.text = "Conectado al anfitrión. Verificando contraseña…"
	_show_menu_page("waiting")
	_add_menu_label(network_status.text, 14)
	rpc_id(1, "_submit_room_password", join_password.sha256_text(), network_player_name)
	join_password = ""

func _on_connection_failed() -> void:
	network_status.text = "No se pudo conectar. Revisa la IP, el puerto 7777 y el firewall del anfitrión."
	_show_menu_page("quick_join")
	_add_menu_label(network_status.text, 14)

func _on_server_disconnected() -> void:
	network_status.text = "Se perdió la conexión con el anfitrión."
	multiplayer.multiplayer_peer = null
	is_solo_mode = true
	network_peer_ids.clear()
	network_player_names.clear()
	room_password = ""
	room_password_hash = ""
	role_assignments = ROLE_MANAGER.assign_roles(1)
	local_roles = role_assignments[0]
	active_role_index = 0
	active_role = String(local_roles[0])
	_update_role_ui()
	_show_menu_page("home")
	_add_menu_label(network_status.text, 14)

func _assign_network_roles() -> void:
	if not is_network_host or network_peer_ids.size() < 2 or network_peer_ids.size() > 4:
		return
	role_assignments = ROLE_MANAGER.assign_roles(network_peer_ids.size())
	for index in range(network_peer_ids.size()):
		var peer_id: int = network_peer_ids[index]
		var roles_for_player: Array = role_assignments[index]
		if peer_id == 1:
			_apply_network_roles(roles_for_player)
		else:
			rpc_id(peer_id, "_receive_network_roles", roles_for_player)
	network_status.text = "Roles sorteados sin repetir entre %d jugadores." % network_peer_ids.size()
	if is_instance_valid(menu_root) and menu_root.visible:
		_show_menu_page("lobby")
		if network_status != null:
			_add_menu_label(network_status.text, 14)

@rpc("any_peer", "call_remote", "reliable")
func _submit_room_password(password_hash: String, player_name: String) -> void:
	if not multiplayer.is_server():
		return
	var peer_id := multiplayer.get_remote_sender_id()
	if not pending_peer_passwords.has(peer_id):
		return
	pending_peer_passwords.erase(peer_id)
	var clean_name := player_name.strip_edges().substr(0, 24)
	if password_hash != room_password_hash or clean_name.is_empty():
		_reject_room_peer(peer_id, "Contraseña incorrecta o nombre de jugador vacío.")
		return
	if network_peer_ids.size() >= MAX_COOP_PLAYERS:
		_reject_room_peer(peer_id, "La sala ya está llena.")
		return
	if not network_peer_ids.has(peer_id):
		network_peer_ids.append(peer_id)
		network_peer_ids.sort()
	network_player_names[peer_id] = clean_name
	rpc_id(peer_id, "_receive_remote_transform", 1, player.global_position, player.rotation.y)
	_assign_network_roles()
	_sync_room_members.rpc(network_player_names, random_room_name, random_room_code)
	_sync_room_members(network_player_names, random_room_name, random_room_code)
	rpc_id(peer_id, "_receive_room_password_result", true, "Acceso concedido.", random_room_name, random_room_code)
	_update_role_ui()
	if is_instance_valid(menu_root) and menu_root.visible:
		_show_menu_page("lobby")
		_add_menu_label("Sala: %s · Jugadores: %d/%d" % [random_room_name, network_peer_ids.size(), MAX_COOP_PLAYERS], 15)

func _reject_room_peer(peer_id: int, message: String) -> void:
	rpc_id(peer_id, "_receive_room_password_result", false, message, "", "")
	get_tree().create_timer(0.5).timeout.connect(func():
		var enet_peer := multiplayer.multiplayer_peer as ENetMultiplayerPeer
		if multiplayer.is_server() and enet_peer != null:
			enet_peer.disconnect_peer(peer_id)
	)

@rpc("authority", "call_remote", "reliable")
func _sync_room_members(names: Dictionary, room_name: String, room_code: String) -> void:
	network_player_names = names.duplicate()
	network_peer_ids.clear()
	for peer_id in network_player_names.keys():
		network_peer_ids.append(int(peer_id))
	network_peer_ids.sort()
	for peer_id in remote_players.keys():
		var avatar := remote_players[peer_id] as Node3D
		if not network_player_names.has(peer_id):
			if is_instance_valid(avatar):
				avatar.queue_free()
			remote_players.erase(peer_id)
			continue
		if is_instance_valid(avatar):
			var name_tag := avatar.get_node_or_null("PlayerName") as Label3D
			if name_tag != null:
				name_tag.text = String(network_player_names[peer_id])
	random_room_name = room_name
	random_room_code = room_code
	_update_role_ui()
	if is_instance_valid(menu_root) and menu_root.visible:
		_show_menu_page("lobby")

@rpc("authority", "call_remote", "reliable")
func _receive_room_password_result(accepted: bool, message: String, room_name: String, room_code: String) -> void:
	if not accepted:
		network_status.text = message
		multiplayer.multiplayer_peer = null
		join_password = ""
		_show_menu_page("quick_join")
		_add_menu_label(message, 15)
		return
	random_room_name = room_name
	random_room_code = room_code
	network_status.text = message
	_show_menu_page("lobby")

@rpc("authority", "call_remote", "reliable")
func _receive_network_roles(roles_for_player: Array) -> void:
	_apply_network_roles(roles_for_player)

func _apply_network_roles(roles_for_player: Array) -> void:
	local_roles = roles_for_player.duplicate()
	if local_roles.is_empty():
		return
	active_role_index = 0
	active_role = String(local_roles[0])
	is_solo_mode = false
	_update_role_ui()
	_update_information_hud()
	_broadcast_coop_state()

@rpc("any_peer", "call_remote", "unreliable_ordered")
func _receive_remote_transform(peer_id: int, position: Vector3, yaw: float) -> void:
	if multiplayer.is_server():
		var sender_id := multiplayer.get_remote_sender_id()
		if sender_id <= 0 or sender_id != peer_id or not network_player_names.has(sender_id):
			return
		for recipient_id in network_peer_ids:
			if recipient_id != sender_id and recipient_id != 1:
				rpc_id(recipient_id, "_receive_remote_transform", peer_id, position, yaw)
	if peer_id == multiplayer.get_unique_id():
		return
	var avatar := remote_players.get(peer_id) as Node3D
	if avatar == null:
		avatar = Node3D.new()
		avatar.name = "RemotePlayer_%d" % peer_id
		var body := MeshInstance3D.new()
		var capsule := CapsuleMesh.new()
		capsule.radius = 0.34
		capsule.height = 1.65
		body.mesh = capsule
		var material := StandardMaterial3D.new()
		material.albedo_color = Color("38c9d2") if peer_id % 2 == 0 else Color("f28e4b")
		body.material_override = material
		avatar.add_child(body)
		var name_tag := Label3D.new()
		name_tag.name = "PlayerName"
		name_tag.text = String(network_player_names.get(peer_id, "Jugador %d" % peer_id))
		name_tag.position = Vector3(0, 1.25, 0)
		name_tag.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		name_tag.no_depth_test = true
		name_tag.font_size = 32
		name_tag.outline_size = 6
		name_tag.pixel_size = 0.008
		avatar.add_child(name_tag)
		add_child(avatar)
		remote_players[peer_id] = avatar
	avatar.global_position = position
	avatar.rotation.y = yaw
	if hero_is_carrying_card and card_carrier_peer_id == peer_id and chest_letter != null:
		chest_letter.reparent(avatar, false)
		chest_letter.transform = Transform3D(Basis.IDENTITY.scaled(Vector3.ONE * 0.32), Vector3(0.34, 0.82, -0.52))
		chest_letter.visible = true

func _broadcast_coop_state() -> void:
	if multiplayer.multiplayer_peer == null:
		return
	var state := {
		"collected": collected_info,
		"delivered": info_delivered,
		"board_pages": board_pages_placed,
		"journalist_has_documents": journalist_has_documents,
		"interviewed": interviewed_npcs.keys(),
		"informed": informed_npcs.keys(),
		"delivery_queue": influencer_delivery_queue,
		"delivery_cursor": influencer_delivery_cursor,
		"shared_info_by_npc": shared_info_by_npc,
		"verified_info": journalist_validated_info,
		"cheered": cheered_npcs.keys(),
		"moods": npc_targets.map(func(npc_state: Dictionary) -> float: return float(npc_state.mood)),
		"pending_card_index": pending_card_chest_index,
		"pending_card_clue": pending_card_clue,
		"carrying_card": hero_is_carrying_card,
		"card_carrier_peer": card_carrier_peer_id,
		"verified": journalist_verified,
		"correct_classifications": journalist_correct_classifications,
		"rejected_false": journalist_rejected_false_count,
		"influencer_has_information": influencer_has_information,
		"fraud_guard7_spoken": fraud_guard7_spoken,
		"fraud_letter_received": fraud_letter_received,
		"fraud_case_resolved": fraud_case_resolved,
		"fraud_guard7_suspicion_stage": fraud_guard7_suspicion_stage,
		"fraud_wrong_suspicions": fraud_wrong_suspicions,
		"fraud_owner_peer_id": fraud_owner_peer_id,
		"fraud_guard6_concern_played": fraud_guard6_concern_played,
		"guardian8_mission_completed": guardian8_mission_completed,
		"guardian8_owner_peer_id": guardian8_owner_peer_id,
		"game_time_remaining": game_time_remaining,
		"roulette_role_uses": roulette_role_uses
	}
	rpc("_receive_coop_state", state)

@rpc("any_peer", "call_remote", "reliable")
func _receive_coop_state(state: Dictionary) -> void:
	var shared_roulette_uses: Dictionary = state.get("roulette_role_uses", {})
	for wheel_id in shared_roulette_uses:
		var local_uses: Dictionary = roulette_role_uses.get(String(wheel_id), {})
		var incoming_uses: Dictionary = shared_roulette_uses[wheel_id]
		for role_name in incoming_uses:
			local_uses[String(role_name)] = true
		roulette_role_uses[String(wheel_id)] = local_uses
	for key in (state.get("collected", {}) as Dictionary):
		if not collected_info.has(key):
			collected_info[key] = state.collected[key]
			if int(key) >= 0 and int(key) < info_chests.size():
				var chest := info_chests[int(key)].node as Node3D
				_stop_chest_proximity_sound(chest)
				_open_chest_visual(chest)
	pending_card_chest_index = int(state.get("pending_card_index", pending_card_chest_index))
	pending_card_clue = String(state.get("pending_card_clue", pending_card_clue))
	hero_is_carrying_card = bool(state.get("carrying_card", hero_is_carrying_card))
	card_carrier_peer_id = int(state.get("card_carrier_peer", card_carrier_peer_id))
	if pending_card_chest_index < 0:
		_return_chest_letter_to_spawn()
	elif hero_is_carrying_card:
		var carrier: Node3D = player if card_carrier_peer_id == multiplayer.get_unique_id() else remote_players.get(card_carrier_peer_id) as Node3D
		if carrier != null and is_instance_valid(carrier):
			chest_letter.reparent(carrier, false)
			chest_letter.transform = Transform3D(Basis.IDENTITY.scaled(Vector3.ONE * 0.32), Vector3(0.34, 0.82, -0.52))
			chest_letter.visible = true
		else:
			chest_letter.visible = false
	else:
		if pending_card_chest_index >= 0 and pending_card_chest_index < info_chests.size():
			var open_chest := info_chests[pending_card_chest_index].node as Node3D
			_stop_chest_proximity_sound(open_chest)
			_open_chest_visual(open_chest)
		_place_chest_letter_at(pending_card_chest_index)
	_set_board_pages_placed(maxi(board_pages_placed, int(state.get("board_pages", 0))))
	info_delivered = board_pages_placed >= INFORMATION_BOARD_PAGE_THRESHOLDS.size() or info_delivered or bool(state.get("delivered", false))
	journalist_has_documents = journalist_has_documents or bool(state.get("journalist_has_documents", false))
	journalist_verified = journalist_verified or bool(state.get("verified", false))
	journalist_correct_classifications = maxi(journalist_correct_classifications, int(state.get("correct_classifications", 0)))
	journalist_rejected_false_count = maxi(journalist_rejected_false_count, int(state.get("rejected_false", 0)))
	influencer_has_information = influencer_has_information or bool(state.get("influencer_has_information", false))
	fraud_guard7_spoken = bool(state.get("fraud_guard7_spoken", fraud_guard7_spoken))
	fraud_letter_received = bool(state.get("fraud_letter_received", fraud_letter_received))
	fraud_case_resolved = bool(state.get("fraud_case_resolved", fraud_case_resolved))
	fraud_guard7_suspicion_stage = int(state.get("fraud_guard7_suspicion_stage", fraud_guard7_suspicion_stage))
	fraud_wrong_suspicions = int(state.get("fraud_wrong_suspicions", fraud_wrong_suspicions))
	var shared_fraud_owner := int(state.get("fraud_owner_peer_id", 0))
	if shared_fraud_owner > 0:
		fraud_owner_peer_id = shared_fraud_owner
	fraud_guard6_concern_played = bool(state.get("fraud_guard6_concern_played", fraud_guard6_concern_played))
	guardian8_mission_completed = guardian8_mission_completed or bool(state.get("guardian8_mission_completed", false))
	var shared_guardian8_owner := int(state.get("guardian8_owner_peer_id", 0))
	if shared_guardian8_owner > 0:
		guardian8_owner_peer_id = shared_guardian8_owner
	if guardian8_mission_completed:
		whale_puzzle_active = false
		guardian8_dialogue_pending = false
		if is_instance_valid(player) and game_running:
			player.controls_enabled = true
		if is_instance_valid(whale_puzzle_panel):
			whale_puzzle_panel.visible = false
		if is_instance_valid(whale_puzzle_dim):
			whale_puzzle_dim.visible = false
		if guardian8 != null and is_instance_valid(guardian8):
			guardian8.global_position = guardian8_home_position
	game_time_remaining = minf(game_time_remaining, float(state.get("game_time_remaining", game_time_remaining)))
	for index in state.get("interviewed", []):
		interviewed_npcs[index] = true
	for index in state.get("informed", []):
		informed_npcs[index] = true
	influencer_delivery_queue.assign(state.get("delivery_queue", influencer_delivery_queue))
	influencer_delivery_cursor = int(state.get("delivery_cursor", influencer_delivery_cursor))
	shared_info_by_npc = state.get("shared_info_by_npc", shared_info_by_npc)
	journalist_validated_info.assign(state.get("verified_info", journalist_validated_info))
	for index in state.get("cheered", []):
		cheered_npcs[index] = true
	var shared_moods: Array = state.get("moods", [])
	for index in range(mini(shared_moods.size(), npc_targets.size())):
		var npc_state: Dictionary = npc_targets[index]
		if float(shared_moods[index]) > float(npc_state.mood):
			npc_state.mood = float(shared_moods[index])
			npc_state.seconds_left = npc_mood_duration * float(npc_state.mood)
			npc_state.recharging = false
			npc_targets[index] = npc_state
	_update_information_hud()

func _exit_network_game() -> void:
	multiplayer.multiplayer_peer = null
	is_network_host = false
	is_solo_mode = true
	network_peer_ids.clear()
	role_assignments = ROLE_MANAGER.assign_roles(1)
	local_roles = role_assignments[0]
	active_role_index = 0
	active_role = String(local_roles[0])
	network_status.text = "Modo solitario activo."
	_update_role_ui()
	_update_information_hud()

func _update_nearest_station() -> void:
	for npc_state in npc_targets:
		var old_badge := npc_state.get("interaction_badge") as Node3D
		if is_instance_valid(old_badge):
			old_badge.visible = false
	if whale_puzzle_active:
		prompt.text = "Flechas · mover  |  MAYÚS / BLOQ MAYÚS · girar 90°  |  ESPACIO · tomar/dejar"
		prompt_panel.visible = false
		return
	if panel != null and panel.visible:
		if guardian8_dialogue_pending:
			prompt.text = "ESPACIO  ·  Pulsa para abrir el rompecabezas"
		else:
			prompt.text = "Q  ·  Cerrar" if panel_uses_q else "E  ·  Cerrar"
		prompt_panel.visible = true
		return
	var target := _nearest_interaction_target()
	if target.is_empty():
		prompt.text = ""
		prompt_panel.visible = false
		return
	match String(target.kind):
		"guardian8":
			if guardian8_mission_completed:
				prompt.text = "Guardia 8 está acompañado · intervención completada"
			elif not _guardian8_role_allowed():
				prompt.text = "Solo el Bardo o el Revolucionario pueden intervenir"
			elif guardian8_owner_peer_id > 0 and not _is_guardian8_event_owner():
				prompt.text = "Otro jugador está acompañando a Guardia 8"
			else:
				prompt.text = "Q · Hablar con Guardia 8 desde el bloque cercano"
		"revolutionary_knife":
			prompt.text = "E · Mirar el cuchillo" if not revolutionary_rescue_started else "E · Recoger el cuchillo"
		"revolutionary_guard":
			if revolutionary_rescue_animation_active:
				prompt.text = "Guardia 9 se está poniendo de pie…"
			elif revolutionary_rescue_has_knife:
				prompt.text = "Q · Cortar las cuerdas y ayudar a Guardia 9"
			elif revolutionary_rescue_started:
				prompt.text = "Guardia 9 espera el cuchillo · vuelve a hablar con Q"
			else:
				prompt.text = "Q · Hablar con Guardia 9"
		"fraud_npc":
			prompt.text = _fraud_prompt(String(target.guard_name))
		"chest":
			var index: int = target.index
			if active_role != "Ciudadano":
				prompt.text = "Solo el Héroe puede recoger cartas"
			elif info_delivered:
				prompt.text = "Misión de cartas completada · este cofre ya no entrega cartas"
			elif collected_info.has(index):
				prompt.text = "Cofre revisado · carta entregada"
			elif pending_card_chest_index >= 0:
				prompt.text = "Recoge la carta pendiente y llévala al tablón"
			else:
				prompt.text = "E  ·  Abrir cofre y sacar una carta"
		"card":
			prompt.text = "E  ·  Recoger la carta %d/10" % (mini(collected_info.size(), REQUIRED_INFO_CHESTS) + 1) if active_role == "Ciudadano" else "La carta es para el Héroe"
		"carry":
			if hero_is_carrying_card:
				prompt.text = "Lleva la carta al tablón de información"
			else:
				prompt.text = "Ve al cofre abierto para recoger la carta"
		"ticket":
			if active_role == "Ciudadano":
				if info_delivered:
					prompt.text = "Tablón completo · el Mensajero puede recoger el expediente"
				elif hero_is_carrying_card:
					prompt.text = "E  ·  Entregar la carta %d/10" % (mini(collected_info.size(), REQUIRED_INFO_CHESTS) + 1)
				elif pending_card_chest_index >= 0:
					prompt.text = "Primero recoge la carta que quedó en el cofre"
				else:
					prompt.text = "Abre un cofre, recoge la carta y tráela aquí"
			elif active_role == "Periodista":
				if journalist_verified:
					prompt.text = "Expediente entregado al Bardo"
				elif not info_delivered:
					prompt.text = "Mensajero: entrevista al público mientras el Héroe completa el tablón"
				elif journalist_has_documents:
					prompt.text = "Expediente recogido · llévalo al escritorio de investigación"
				else:
					prompt.text = "E  ·  Recoger expediente y llevarlo al escritorio"
			else:
				prompt.text = "El tablón lo usan el Héroe y el Mensajero"
		"desk":
			if active_role != "Periodista":
				prompt.text = "Escritorio de investigación · uso del Mensajero"
			elif journalist_verified:
				prompt.text = "Verificación completada · expediente listo"
			elif not info_delivered:
				prompt.text = "Espera a que el Héroe complete las tres hojas del tablón"
			elif not journalist_has_documents:
				prompt.text = "Primero recoge el expediente del tablón de información"
			elif interviewed_npcs.size() < npc_targets.size():
				prompt.text = "Completa las entrevistas: %d/%d" % [interviewed_npcs.size(), npc_targets.size()]
			else:
				prompt.text = "E  ·  Resolver puzles y verificar la información"
		"roulette":
			var wheel_id := String(target.get("roulette_id", "rotate-z2"))
			if bool(roulette_spinning_wheels.get(wheel_id, false)):
				prompt.text = "La ruleta está girando…"
			elif _roulette_role_used(wheel_id, active_role):
				prompt.text = "Ya usaste esta ruleta con el rol " + active_role
			else:
				prompt.text = "E  ·  Girar la ruleta con " + active_role
		"npc":
			var state: Dictionary = npc_targets[int(target.npc_index)]
			var mood_percent := roundi(float(state.mood) * 100.0)
			if fraud_letter_received and not fraud_case_resolved and _is_fraud_event_owner():
				prompt.text = "Q  ·  Sospechar de " + String(target.name).replace("_", " ") + "  ·  fallo: −1 min"
			else:
				match active_role:
					"Periodista": prompt.text = "Entrevista lista · " + String(target.name) if interviewed_npcs.has(target.npc_index) else "E  ·  Hablar y resolver acertijo con " + String(target.name)
					"Influencer":
						if not influencer_has_information:
							var cooldown := float(bard_cooldowns.get(int(target.npc_index), 0.0))
							if cooldown > 0.0:
								prompt.text = "Bardo · espera %d s para volver a animar" % ceili(cooldown)
							elif bard_cheer_target == int(target.npc_index):
								prompt.text = "Mantén E · Animando %d%% (8 s)" % roundi(bard_cheer_elapsed / BARD_CHEER_HOLD_DURATION * 100.0)
							else:
								prompt.text = "Mantén E durante 8 s · Animar un poco a " + String(target.name)
						elif influencer_delivery_cursor >= influencer_delivery_queue.size():
							prompt.text = "Entrega completada · " + String(target.name)
						elif int(target.npc_index) == _next_npc_to_inform():
							prompt.text = "E  ·  Entregar el siguiente dato a " + String(target.name)
						elif informed_npcs.has(target.npc_index):
							prompt.text = "Dato entregado · espera el siguiente turno"
						else:
							prompt.text = "Entrega primero al siguiente vecino"
					"Candidato a alcalde": prompt.text = "Ánimo recargando · %d%%" % mood_percent if state.recharging else "E  ·  Animar a " + String(target.name) + "  ·  Ánimo %d%%" % mood_percent
					_: prompt.text = "E  ·  Conversar con " + String(target.name).replace("_", " ")
	var show_npc_interaction_badge := String(target.kind) == "npc" and (prompt.text.begins_with("E  ·") or prompt.text.begins_with("Mantén E"))
	if show_npc_interaction_badge:
		var npc_index := int(target.npc_index)
		if npc_index >= 0 and npc_index < npc_targets.size():
			var state: Dictionary = npc_targets[npc_index]
			var badge := state.get("interaction_badge") as Node3D
			if is_instance_valid(badge):
				_set_npc_badge_action(badge, _npc_interaction_action_label())
				badge.visible = true
	prompt_panel.visible = not prompt.text.is_empty() and not show_npc_interaction_badge
	_sync_interaction_plaque()

func _npc_interaction_action_label() -> String:
	match active_role:
		"Periodista": return "ENTREVISTAR"
		"Influencer": return "ENTREGAR" if influencer_has_information else "ANIMAR"
		"Candidato a alcalde": return "ANIMAR"
		_: return "HABLAR"

func _nearest_interaction_target(ignore_guardian8 := false) -> Dictionary:
	var nearest: Dictionary = {}
	var best := 3.5
	if not ignore_guardian8 and not guardian8_mission_completed and is_instance_valid(guardian8) and is_instance_valid(player) and player.is_on_floor():
		var guard_offset: Vector3 = player.global_position - guardian8.global_position
		if Vector2(guard_offset.x, guard_offset.z).length() <= GUARDIAN8_REMOTE_INTERACTION_RANGE and absf(guard_offset.y) <= GUARDIAN8_REMOTE_HEIGHT_RANGE:
			return {"kind":"guardian8", "node":guardian8}
	if active_role == "Candidato a alcalde" and not revolutionary_rescue_completed and is_instance_valid(player):
		if not revolutionary_rescue_has_knife and is_instance_valid(rescue_knife) and rescue_knife.visible and rescue_knife.get_parent() == self:
			if player.global_position.distance_to(rescue_knife.global_position) <= 3.5:
				return {"kind":"revolutionary_knife", "node":rescue_knife}
		if is_instance_valid(tied_guard_9):
			var rescue_offset: Vector3 = player.global_position - tied_guard_9.global_position
			if Vector2(rescue_offset.x, rescue_offset.z).length() <= 4.5 and absf(rescue_offset.y) <= 8.0:
				return {"kind":"revolutionary_guard", "node":tied_guard_9}
	if fraud_letter_received and not fraud_case_resolved and _is_fraud_event_owner():
		return _nearest_fraud_suspicion_target()
	if active_role == "Ciudadano" and hero_is_carrying_card:
		if ticket_terminal_position.x > -1000 and player.global_position.distance_to(ticket_terminal_position) <= 3.5:
			return {"kind":"ticket"}
		return {"kind":"carry"}
	if active_role == "Ciudadano" and pending_card_chest_index >= 0:
		if chest_letter != null and chest_letter.visible and player.global_position.distance_to(chest_letter.global_position) <= 3.5:
			return {"kind":"card"}
		return {"kind":"carry"}
	for i in range(info_chests.size()):
		if collected_info.has(i):
			continue
		var chest_pos: Vector3 = info_chests[i].position
		var distance := player.global_position.distance_to(chest_pos)
		if distance < best:
			best = distance
			nearest = {"kind":"chest", "index":i}
	if ticket_terminal_position.x > -1000:
		var terminal_distance := player.global_position.distance_to(ticket_terminal_position)
		if terminal_distance < best:
			best = terminal_distance
			nearest = {"kind":"ticket"}
	if research_desk_position.x > -1000:
		var desk_distance := player.global_position.distance_to(research_desk_position)
		if desk_distance < best:
			best = desk_distance
			nearest = {"kind":"desk"}
	for wheel_info in roulette_wheels:
		var wheel_position: Vector3 = wheel_info.get("position", Vector3(-10000, 0, 0))
		var wheel_distance := player.global_position.distance_to(wheel_position)
		if wheel_distance <= float(wheel_info.get("range", 4.2)) and wheel_distance < best:
			best = wheel_distance
			nearest = {"kind":"roulette", "roulette_id":String(wheel_info.get("id", "rotate-z2"))}
	for i in range(npc_targets.size()):
		var npc: Dictionary = npc_targets[i]
		var npc_position: Vector3 = npc.position
		var distance := player.global_position.distance_to(npc_position)
		if distance < best:
			best = distance
			nearest = {"kind":"npc", "name":npc.name, "node":npc.node, "npc_index":i}
	for guard_name in fraud_guard_nodes:
		if fraud_owner_peer_id > 0 and not _is_fraud_event_owner():
			continue
		var guard := fraud_guard_nodes[guard_name] as Node3D
		if guard == null or not is_instance_valid(guard):
			continue
		var distance := player.global_position.distance_to(guard.global_position)
		if distance < best:
			best = distance
			nearest = {"kind":"fraud_npc", "guard_name":String(guard_name), "name":String(guard_name), "node":guard}
	return nearest

func _nearest_fraud_suspicion_target() -> Dictionary:
	var nearest: Dictionary = {}
	var best := 3.5
	for i in range(npc_targets.size()):
		var state: Dictionary = npc_targets[i]
		var npc := state.node as Node3D
		if npc == null or not is_instance_valid(npc):
			continue
		var distance := player.global_position.distance_to(npc.global_position)
		if distance < best:
			best = distance
			nearest = {"kind":"npc", "name":state.name, "node":npc, "npc_index":i}
	for guard_name in fraud_guard_nodes:
		var guard := fraud_guard_nodes[guard_name] as Node3D
		if guard == null or not is_instance_valid(guard):
			continue
		var distance := player.global_position.distance_to(guard.global_position)
		if distance < best:
			best = distance
			nearest = {"kind":"fraud_npc", "guard_name":String(guard_name), "name":String(guard_name), "node":guard}
	return nearest

func _fraud_prompt(guard_name: String) -> String:
	if fraud_case_resolved:
		return "Caso de las cartas resuelto"
	if fraud_owner_peer_id > 0 and not _is_fraud_event_owner():
		return "Este mini evento ya tiene responsable · sigue tu misión de rol"
	if guard_name == "Guardia_07":
		if fraud_letter_received:
			return "Q  ·  Sospechar de Guardia 7  ·  fallo: −1 min"
		return "Q  ·  Hablar con Guardia 7" if not fraud_guard7_spoken else "Q  ·  Volver a hablar con Guardia 7"
	if not fraud_guard7_spoken:
		return "Habla primero con Guardia 7"
	if fraud_letter_received:
		return "Q  ·  Sospechar de Guardia 6  ·  fallo: −1 min"
	return "Q  ·  Hablar con Guardia 6 y leer la carta"

func _handle_revolutionary_knife_interaction() -> void:
	if active_role != "Candidato a alcalde" or revolutionary_rescue_completed or not is_instance_valid(rescue_knife):
		return
	panel_uses_q = false
	if not revolutionary_rescue_started:
		revolutionary_knife_inspected = true
		panel_text.text = "Oh, un cuchillo.\n\nPulsa E para cerrar."
		return
	if revolutionary_rescue_has_knife:
		panel_text.text = "Ya tienes el cuchillo. Llévalo con Guardia 9 y pulsa Q para ayudarlo.\n\nPulsa E para cerrar."
		return
	revolutionary_rescue_has_knife = true
	if rescue_knife.get_parent() != player:
		rescue_knife.reparent(player, false)
	var carried_transform := rescue_knife.transform
	carried_transform.origin = Vector3(0.40, 0.78, -0.48)
	rescue_knife.transform = carried_transform
	for candidate in rescue_knife.find_children("*", "CollisionObject3D", true, false):
		var collision_object := candidate as CollisionObject3D
		collision_object.collision_layer = 0
		collision_object.collision_mask = 0
	panel_text.text = "Recogiste el cuchillo. Llévalo con Guardia 9 y pulsa Q para cortar las cuerdas.\n\nPulsa E para cerrar."
	_update_information_hud()
	_broadcast_coop_state()

func _start_revolutionary_guard_interaction() -> void:
	if active_role != "Candidato a alcalde" or not is_instance_valid(tied_guard_9) or revolutionary_rescue_completed:
		return
	if revolutionary_rescue_animation_active:
		return
	_play_npc_interaction_voice(tied_guard_9)
	panel_uses_q = true
	if revolutionary_rescue_has_knife:
		_rescue_guardia_09()
		return
	if not revolutionary_rescue_started:
		revolutionary_rescue_started = true
		revolutionary_rescue_dialogue_stage = "guard_intro"
		panel_text.text = "GUARDIA 09 · MENSAJERÍA\n\nTú: —¿Tú qué haces así?\n\nGuardia 9: —Por culpa mía, por hablar con una persona desconocida por mensajería, pensé que tendría una cita romántica. Pero me engañó, me secuestró y me dejó así, colgado literalmente.\n\n—Busca algo filoso con que me puedas ayudar.\n\nPulsa Q para cerrar."
	else:
		revolutionary_rescue_dialogue_stage = "guard_wait"
		panel_text.text = "GUARDIA 09\n\n—Busca algo filoso con que me puedas ayudar. Cuando lo tengas, vuelve y pulsa Q.\n\nPulsa Q para cerrar."
	panel.visible = true
	if is_instance_valid(player):
		player.controls_enabled = false
	_update_information_hud()
	_broadcast_coop_state()

func _rescue_guardia_09() -> void:
	if revolutionary_rescue_animation_active or not is_instance_valid(tied_guard_9):
		return
	revolutionary_rescue_animation_active = true
	panel.visible = false
	panel_uses_q = true
	if is_instance_valid(player):
		player.controls_enabled = false
	tied_guard_9.set_process(false)
	for candidate in tied_guard_9.find_children("*", "Node3D", true, false):
		if String(candidate.name).to_lower().contains("sogas"):
			(candidate as Node3D).visible = false
	var originals: Array[Node3D] = []
	for child in tied_guard_9.get_children():
		if child is Node3D and String(child.name).begins_with("GuardiaOriginal"):
			originals.append(child as Node3D)
	var drop_to := maxf(0.25, tied_guard_9.global_position.y - 0.75)
	var fall := create_tween().set_parallel(true)
	fall.tween_property(tied_guard_9, "global_position:y", drop_to, 0.55).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	for original in originals:
		fall.tween_property(original, "rotation:z", original.rotation.z + 0.45, 0.55).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await fall.finished
	var stand := create_tween().set_parallel(true)
	stand.tween_property(tied_guard_9, "global_position:y", 0.06, 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	for original in originals:
		stand.tween_property(original, "rotation:z", 0.0, 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		stand.tween_property(original, "position:y", 0.0, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	await stand.finished
	# El modelo deja la pose de brazos abiertos de la suspensión y queda de pie
	# con los brazos relajados y un leve movimiento mientras se recupera.
	tied_guard_9.set_process(true)
	if tied_guard_9.has_method("liberar"):
		tied_guard_9.call("liberar")
	revolutionary_rescue_animation_active = false
	revolutionary_rescue_completed = true
	revolutionary_rescue_has_knife = false
	revolutionary_rescue_dialogue_stage = "guard_thanks"
	if is_instance_valid(rescue_knife):
		rescue_knife.visible = false
	panel_text.text = "GUARDIA 09 · LIBERADO\n\n—Muchísimas gracias. Estaré más pendiente la próxima vez de no escribirle a cualquiera ni chatear con desconocidos por mensajería.\n\nPulsa Q para cerrar."
	panel.visible = true
	_update_information_hud()
	_broadcast_coop_state()

func _is_fraud_event_owner() -> bool:
	return fraud_owner_peer_id > 0 and fraud_owner_peer_id == multiplayer.get_unique_id()

func _append_npc_greeting(npc_index: int) -> void:
	if npc_greeted.has(npc_index):
		return
	npc_greeted[npc_index] = true
	var greetings := [
		"¡Buenos días! La plaza está tranquila por ahora.",
		"¡Hola, viajero! ¿Has visto cómo está el mercado hoy?",
		"Saludos. Ojalá las noticias de hoy sean ciertas.",
		"¡Qué bueno verte! Estoy atento a lo que ocurre en el reino.",
		"Hola. Si encuentras información fiable, compártela con cuidado."
	]
	if panel_text != null:
		panel_text.text += "\n\n" + String(greetings[npc_index % greetings.size()])

func _handle_fraud_guard_interaction(guard_name: String) -> void:
	if fraud_case_resolved:
		panel_text.text = "CASO RESUELTO\n\nGuardia 7 confesó la estafa, se disculpó y devolvió el dinero a Guardia 6."
	elif fraud_owner_peer_id > 0 and not _is_fraud_event_owner():
		panel_text.text = "MINI EVENTO EN CURSO\n\nOtro jugador ya se encargó de investigar estas cartas. Continúa con la misión de tu rol: cofres, información y ánimo de los vecinos."
	elif fraud_letter_received:
		_attempt_fraud_suspicion(guard_name)
	elif guard_name == "Guardia_07":
		if fraud_owner_peer_id == 0:
			fraud_owner_peer_id = multiplayer.get_unique_id()
		fraud_guard7_spoken = true
		panel_text.text = "GUARDIA 7 · ESCRIBIENDO\n\n«¡Holaa, viajeroo! Estoy escribiendooo unas cartasss… nada importante, je, je. Las letras se me mueven un poquillooo. Mejor pregunta a otro guardiaaa.»\n\nSu habla arrastrada y las letras repetidas te dejan una duda. Guardia 6 podría saber algo."
		_broadcast_coop_state()
	else:
		if not fraud_guard7_spoken:
			panel_text.text = "GUARDIA 6\n\n«Primero habla con Guardia 7. Él está escribiendo muchas cartas y quizá sepa algo.»"
		else:
			fraud_letter_received = true
			panel_text.text = "GUARDIA 6 · CARTA RECIBIDA\n\n«Alguien me manda cartas pidiendo dinero urgente. Abrí una y quiero que me ayudes a averiguar quién las escribió.»\n\nCARTA:\n“Amigooo, necesito 30 monedas urgentesss. Envíamelas yaaa, no preguntesss y no se lo digasss a nadieee. Estoy un poquillooo confundido, pero te las devolveré prontooo.”\n\nPuedes leerla y sospechar de cualquier NPC con Q. Si acusas a la persona equivocada, perderás 1 minuto."
			fraud_guard6_concern_played = true
			_broadcast_coop_state()
	panel.visible = true
	_update_information_hud()

func _attempt_fraud_suspicion(suspect_name: String) -> void:
	var normalized := suspect_name.replace(" ", "_")
	if normalized == "Guardia_07":
		fraud_guard7_suspicion_stage += 1
		if fraud_guard7_suspicion_stage == 1:
			panel_text.text = "GUARDIA 7 · SE PONE NERVIOSO\n\n«¿Yo? Nooo… esas letras no son mías. No sé nada de las 30 monedasss… digo, de ninguna carta.»\n\nSu respuesta confirma que debes insistir. Pulsa Q otra vez para confrontarlo."
		else:
			fraud_case_resolved = true
			fraud_letter_received = false
			panel_text.text = "ESTAFA DESCUBIERTA\n\nGuardia 7 baja la voz: «Está bien, yo escribí las cartas. Fingí estar borracho para que no me reconocieran. Perdóname; voy a devolverle las 30 monedas a Guardia 6.»\n\nGuardia 6 recuperó su dinero. Caso resuelto."
		_update_information_hud()
		_broadcast_coop_state()
		return
	fraud_wrong_suspicions += 1
	game_time_remaining = maxf(0.0, game_time_remaining - 60.0)
	_update_timer_hud()
	var innocent_line := "«No escribí esa carta. Revisa las pistas y vuelve a intentarlo.»"
	for state in npc_targets:
		if String(state.name) == normalized:
			innocent_line = "«No sé nada de esa estafa. Yo no escribí la carta.»"
			break
	panel_text.text = "SOSPECHA EQUIVOCADA\n\n%s\n\nPerdiste 1 minuto. Tiempo restante: %02d:%02d. Sigue comparando la carta con los NPCs." % [innocent_line, ceili(game_time_remaining) / 60, ceili(game_time_remaining) % 60]
	if game_time_remaining <= 0.0 and not game_timer_timeout:
		game_timer_timeout = true
		_end_game(false)
	_broadcast_coop_state()

func _open_nearest_station(ignore_guardian8 := false) -> void:
	var target := _nearest_interaction_target(ignore_guardian8)
	if target.is_empty():
		return
	if String(target.get("kind", "")) == "npc":
		_play_npc_interaction_voice(target.get("node") as Node3D)
	elif String(target.get("kind", "")) == "fraud_npc":
		_play_npc_interaction_voice(fraud_guard_nodes.get(String(target.get("guard_name", ""))) as Node3D)
	panel_uses_q = String(target.get("kind", "")) in ["fraud_npc", "revolutionary_guard"] or (fraud_letter_received and String(target.get("kind", "")) == "npc")
	match String(target.kind):
		"revolutionary_knife":
			_handle_revolutionary_knife_interaction()
		"chest":
			var index: int = target.index
			if active_role != "Ciudadano":
				panel_text.text = "Solo el Héroe puede abrir cofres para recoger cartas."
			elif info_delivered or collected_info.size() >= REQUIRED_INFO_CHESTS:
				panel_text.text = "La misión del Héroe está completa. Los cofres ya no entregan cartas."
			elif hero_is_carrying_card or pending_card_chest_index >= 0:
				panel_text.text = "Primero recoge la carta del cofre abierto y entrégala en el tablón. Solo puedes llevar una carta a la vez."
			elif collected_info.has(index):
				panel_text.text = "Este cofre ya fue revisado. La carta ya está en el tablón."
			else:
				var clues := ["Alerta: un rumor sobre el centro comunitario no incluye un enlace oficial verificable.", "El calendario municipal anuncia una jornada de limpieza vecinal.", "Una encuesta a tres personas no representa a todo el reino.", "El portal electoral confirma fecha y hora del debate municipal.", "Una captura recortada no demuestra que el parque vaya a cerrar.", "Revisa si la propuesta de reparación presenta responsables y presupuesto.", "Compara la cifra del mensaje con el informe público original.", "El mensaje sobre fondos proviene de una cuenta anónima sin pruebas.", "Comprueba la fecha original de la noticia antes de compartirla.", "Consulta el acta electoral para confirmar el sitio y hora de votación."]
				pending_card_chest_index = index
				pending_card_clue = String(clues[index % clues.size()])
				_save_opened_chest(index)
				var chest := info_chests[index].node as Node3D
				_stop_chest_proximity_sound(chest)
				_open_chest_visual(chest)
				_play_chest_open_sound(chest)
				_place_chest_letter_at(index)
				panel_text.text = "✦   CARTA EN EL COFRE\n\nAbre el cofre y su carta apareció encima. Recógela con E y llévala al tablón antes de abrir otro. Cartas entregadas: %d / %d." % [mini(collected_info.size(), REQUIRED_INFO_CHESTS), REQUIRED_INFO_CHESTS]
				card_carrier_peer_id = 0
				_broadcast_coop_state()
			_update_information_hud()
		"card":
			if active_role == "Ciudadano":
				_pick_up_chest_letter()
			else:
				panel_text.text = "Solo el Héroe puede recoger esta carta."
			_update_information_hud()
		"carry":
			panel_text.text = "Lleva la carta que está en el cofre abierto al tablón de información. No puedes abrir otro cofre todavía."
			_update_information_hud()
		"ticket":
			if active_role == "Ciudadano":
				if hero_is_carrying_card:
					_deliver_chest_letter_to_board()
				elif info_delivered:
					panel_text.text = "✓   TABLÓN COMPLETO\n\nLas 10 cartas ya están colocadas. El Mensajero puede recoger el expediente y llevarlo al escritorio de investigación."
				else:
					panel_text.text = "✦   ENTREGA UNA CARTA A LA VEZ\n\nAbre un cofre, recoge la carta con E y vuelve aquí para colocarla. No puedes llevar varias cartas a la vez. Progreso: %d / %d." % [mini(collected_info.size(), REQUIRED_INFO_CHESTS), REQUIRED_INFO_CHESTS]
			elif active_role == "Periodista":
				if journalist_verified:
					panel_text.text = "✓   EXPEDIENTE VERIFICADO\n\nLa información ya se analizó en el escritorio y está lista para el Bardo."
				elif not info_delivered:
					panel_text.text = "✦   EL TABLÓN AÚN NO ESTÁ COMPLETO\n\nEl Héroe debe colocar las tres hojas antes de que puedas recoger el expediente."
				elif journalist_has_documents:
					panel_text.text = "EXPEDIENTE RECOGIDO\n\nLleva obligatoriamente la información al escritorio de investigación. Allí podrás resolver los puzles y clasificar cada dato."
					_update_information_hud()
				else:
					journalist_has_documents = true
					panel_text.text = "✦   EXPEDIENTE RECOGIDO\n\nHas tomado la información del tablón. Llévala al escritorio de investigación para resolver los puzles y decidir qué datos son verdaderos o falsos."
					_broadcast_coop_state()
			else:
				panel_text.text = "El Héroe entrega aquí las cartas y el Mensajero verifica la información."
			_update_information_hud()
		"desk":
			if active_role == "Periodista":
				_start_journalist_verification()
			else:
				panel_text.text = "ESCRITORIO DE INVESTIGACIÓN\n\nEste puesto secundario es para el Mensajero. Aquí se descifra y verifica el expediente recogido del tablón."
			_update_information_hud()
		"roulette":
			_use_roulette(String(target.get("roulette_id", "rotate-z2")))
		"npc":
			var npc_index: int = target.npc_index
			var npc_node := target.node as Node3D
			if fraud_letter_received and not fraud_case_resolved:
				_attempt_fraud_suspicion(String(target.name))
			else:
				match active_role:
					"Periodista":
						_interview_public(npc_index)
					"Influencer":
						_share_info_to_npc(npc_index)
					"Candidato a alcalde":
						if npc_targets[npc_index].recharging:
							panel_text.text = "✦   " + String(target.name).replace("_", " ") + "\n\nSu ánimo se está recargando. Espera a que termine para volver a animarlo."
						else:
							_cheer_npc(npc_index)
							panel_text.text = "✦   " + String(target.name).replace("_", " ") + "\n\n¡Lo animaste! Su barra volverá a llenarse y bajará en %d segundos." % int(npc_mood_duration)
					_:
						panel_text.text = "✦   " + String(target.name).replace("_", " ") + "\n\nEl vecino te saluda y comparte cómo van las cosas en el reino."
				if active_role != "Periodista":
					_append_npc_greeting(npc_index)
			panel_text.text += "\n\nPulsa E para cerrar."
			_update_information_hud()
		"fraud_npc":
			_handle_fraud_guard_interaction(String(target.guard_name))
			panel_text.text += "\n\nPulsa Q para cerrar."
	panel.visible = not ["chest", "card", "carry"].has(String(target.kind))

func _update_information_hud() -> void:
	if hud == null:
		return
	var status := "CARTAS   %d / %d     ·     VECINOS   %d / %d" % [mini(collected_info.size(), REQUIRED_INFO_CHESTS), REQUIRED_INFO_CHESTS, informed_npcs.size(), npc_targets.size()]
	var fraud_status := "resuelta" if fraud_case_resolved else ("a cargo de otro jugador" if fraud_owner_peer_id > 0 and not _is_fraud_event_owner() else ("carta en mano · sospechas: %d" % fraud_wrong_suspicions if fraud_letter_received else ("habla con Guardia 7" if not fraud_guard7_spoken else "habla con Guardia 6")))
	status += "\nESTAFA · " + fraud_status
	if is_solo_mode:
		status += "\nMISIONES\n%s" % _role_mission(active_role)
	else:
		var missions: Array[String] = []
		for role in local_roles:
			missions.append(_role_mission(String(role)))
		status += "\nMISIONES\n" + "\n".join(PackedStringArray(missions))
	hud.text = status
	_check_game_completion()

func _interview_public(npc_index: int) -> void:
	if interviewed_npcs.has(npc_index):
		panel_text.text = "La entrevista ya quedó registrada. Sigue hablando con los demás vecinos."
		return
	journalist_puzzle_npc = npc_index
	journalist_puzzle_sequence.clear()
	journalist_puzzle_input.clear()
	for _step in range(3):
		journalist_puzzle_sequence.append(randi_range(1, 3))
	_show_interview_puzzle()

func _show_interview_puzzle() -> void:
	var npc_name: String = String(npc_targets[journalist_puzzle_npc].name).replace("_", " ")
	var code := " · ".join(PackedStringArray(journalist_puzzle_sequence.map(func(value: int) -> String: return str(value))))
	panel_text.text = "ENTREVISTA · %s\n\nEl vecino te dicta una clave de tres señales. Repítela en el mismo orden con las teclas 1, 2 y 3.\n\nClave: %s\nTu secuencia: %s\n\nPulsa las tres teclas para completar la entrevista." % [npc_name, code, " · ".join(PackedStringArray(journalist_puzzle_input.map(func(value: int) -> String: return str(value))))]

func _answer_interview_puzzle(signal_number: int) -> void:
	if journalist_puzzle_npc < 0:
		return
	journalist_puzzle_input.append(signal_number)
	var step := journalist_puzzle_input.size() - 1
	if journalist_puzzle_input[step] != journalist_puzzle_sequence[step]:
		journalist_puzzle_input.clear()
		panel_text.text = "La clave no coincidió. La entrevista sigue abierta. Inténtalo de nuevo:\n\n"
		_show_interview_puzzle()
		return
	if journalist_puzzle_input.size() < journalist_puzzle_sequence.size():
		_show_interview_puzzle()
		return
	var npc_index := journalist_puzzle_npc
	journalist_puzzle_npc = -1
	interviewed_npcs[npc_index] = true
	var npc_name: String = String(npc_targets[npc_index].name).replace("_", " ")
	panel_text.text = "ENTREVISTA COMPLETADA · %s\n\nResolviste la clave y registraste su testimonio. Entrevistas: %d / %d.\n\nPuedes continuar con otro vecino mientras el Héroe entrega las cartas." % [npc_name, interviewed_npcs.size(), npc_targets.size()]
	if interviewed_npcs.size() == npc_targets.size():
		panel_text.text += "\n\nCuando el Héroe complete las tres hojas, recoge allí el expediente y llévalo al escritorio de investigación para verificarlo."
	_update_information_hud()
	_broadcast_coop_state()

func _start_journalist_verification() -> void:
	if journalist_verified:
		panel_text.text = "La información ya fue verificada y está lista para el Bardo."
		return
	if not info_delivered:
		panel_text.text = "El Héroe todavía no ha entregado las cartas al tablón."
		return
	if not journalist_has_documents:
		panel_text.text = "Primero recoge el expediente del tablón y llévalo al escritorio de investigación."
		return
	if interviewed_npcs.size() < npc_targets.size():
		panel_text.text = "Antes de revisar la información, entrevista a todos los vecinos. Entrevistas: %d / %d." % [interviewed_npcs.size(), npc_targets.size()]
		return
	journalist_results.clear()
	journalist_correct_classifications = 0
	journalist_rejected_false_count = 0
	journalist_validated_info.clear()
	journalist_claim_index = 0
	journalist_puzzle_stage = "minigame"
	_prepare_journalist_minigame()
	_show_journalist_claim()

func _prepare_journalist_minigame() -> void:
	journalist_minigame_kind = randi_range(0, 3)
	journalist_minigame_sequence.clear()
	journalist_minigame_input.clear()
	var puzzle_text := ""
	var options: Array[String] = []
	journalist_puzzle_correct_option = 1
	match journalist_minigame_kind:
		0:
			puzzle_text = "CÓDIGO DE FUENTE · Elige la pista que permite rastrear el dato hasta su origen."
			options = ["Una captura reenviada", "El documento o portal original", "Un comentario anónimo"]
			journalist_puzzle_correct_option = 2
		1:
			puzzle_text = "CANDADO DE CONTRASEÑA · Memoriza la clave y vuelve a introducirla en orden."
			for _step in range(3):
				journalist_minigame_sequence.append(randi_range(1, 3))
		2:
			puzzle_text = "RUTA DEL ESCÁNER · Traza el camino iluminado introduciendo sus señales en orden."
			for _step in range(4):
				journalist_minigame_sequence.append(randi_range(1, 3))
		_:
			puzzle_text = "PUZLE DE TRES EN RAYA\n\nX | X | 3\nO | 5 | O\n7 | 8 | 9\n\nElige la casilla que completa la línea de X."
			options = ["Casilla 3 · completa la línea", "Casilla 5 · no forma línea", "Casilla 9 · deja el rumor abierto"]
			journalist_puzzle_correct_option = 1
	if not options.is_empty():
		var correct_option_text := options[journalist_puzzle_correct_option - 1]
		options.shuffle()
		journalist_puzzle_correct_option = options.find(correct_option_text) + 1
	journalist_claims[journalist_claim_index]["puzzle_text"] = puzzle_text
	journalist_claims[journalist_claim_index]["puzzle_options"] = options
	journalist_claims[journalist_claim_index]["puzzle_correct"] = journalist_puzzle_correct_option
	journalist_claims[journalist_claim_index]["puzzle_kind"] = journalist_minigame_kind
	journalist_claims[journalist_claim_index]["puzzle_sequence"] = journalist_minigame_sequence.duplicate()
	journalist_puzzle_stage = "sequence" if journalist_minigame_kind == 1 or journalist_minigame_kind == 2 else "minigame"

func _show_journalist_claim() -> void:
	if journalist_claim_index >= journalist_claims.size():
		journalist_claim_index = -1
		journalist_puzzle_stage = ""
		journalist_verified = true
		influencer_has_information = true
		_prepare_influencer_deliveries()
		shared_info_by_npc.clear()
		var handoff := "En solitario, los datos pasaron automáticamente al Bardo. Cambia a ese rol y entrega a cada vecino un dato verdadero verificado." if is_solo_mode else "Los datos verificados pasaron al Bardo. Debe compartirlos con los vecinos, uno por uno."
		var ending := "FINAL LIMPIO" if journalist_correct_classifications == journalist_claims.size() else "FINAL IRREGULAR"
		panel_text.text = "✓   ESCANEO COMPLETADO · %s\n\nAciertos: %d / %d\nDatos verdaderos aprobados: %d\nDatos falsos rechazados: %d\n\n%s" % [ending, journalist_correct_classifications, journalist_claims.size(), journalist_validated_info.size(), journalist_rejected_false_count, handoff]
		_update_information_hud()
		_broadcast_coop_state()
		return
	var claim: Dictionary = journalist_claims[journalist_claim_index]
	if journalist_puzzle_stage == "minigame":
		if journalist_minigame_kind == 1 or journalist_minigame_kind == 2:
			var code := " · ".join(PackedStringArray(journalist_minigame_sequence.map(func(value: int) -> String: return str(value))))
			panel_text.text = "ESCANEO DE DATOS · %d / %d\n\n%s\n\nClave: %s\nPulsa las teclas 1, 2 y 3 en el mismo orden." % [journalist_claim_index + 1, journalist_claims.size(), String(claim.get("puzzle_text", "")), code]
		else:
			var options: Array = claim.get("puzzle_options", [])
			panel_text.text = "ESCANEO DE DATOS · %d / %d\n\nResuelve el minipuzle para abrir el expediente:\n%s\n\n1 · %s\n2 · %s\n3 · %s" % [journalist_claim_index + 1, journalist_claims.size(), String(claim.get("puzzle_text", "")), String(options[0]), String(options[1]), String(options[2])]
	elif journalist_puzzle_stage == "sequence":
		var code := " · ".join(PackedStringArray(journalist_minigame_sequence.map(func(value: int) -> String: return str(value))))
		var typed := " · ".join(PackedStringArray(journalist_minigame_input.map(func(value: int) -> String: return str(value))))
		panel_text.text = "PUZLE EN CURSO · %d / %d\n\n%s\n\nClave: %s\nEntrada: %s\n\nContinúa con las teclas 1, 2 y 3." % [journalist_claim_index + 1, journalist_claims.size(), String(claim.get("puzzle_text", "")), code, typed]
	else:
		var classification := "VERDADERO · las fuentes respaldan el dato." if bool(claim.is_true) else "FALSO · las fuentes no respaldan el dato."
		panel_text.text = "EXPEDIENTE %d / %d\n\n%s\n\nESCÁNER: %s\n\n¿Apruebas este dato para compartirlo?\n1 · SÍ, aprobar\n2 · NO, rechazar" % [journalist_claim_index + 1, journalist_claims.size(), String(claim.statement), classification]

func _answer_journalist_claim(choice: int) -> void:
	if journalist_claim_index < 0 or journalist_claim_index >= journalist_claims.size():
		return
	var claim: Dictionary = journalist_claims[journalist_claim_index]
	if journalist_puzzle_stage == "minigame":
		if choice != int(claim.get("puzzle_correct", 1)):
			_show_journalist_claim()
			var claim_panel_text := panel_text.text
			var title_end := claim_panel_text.find("\n")
			var stable_title := claim_panel_text.substr(0, title_end)
			var claim_body := claim_panel_text.substr(title_end).strip_edges()
			panel_text.text = "%s\n\nNo quedó resuelto. Inténtalo otra vez.\n%s" % [stable_title, claim_body]
			return
		journalist_puzzle_stage = "classify"
		_show_journalist_claim()
		return
	if journalist_puzzle_stage == "sequence":
		journalist_minigame_input.append(choice)
		var step := journalist_minigame_input.size() - 1
		if journalist_minigame_input[step] != journalist_minigame_sequence[step]:
			journalist_minigame_input.clear()
			var code := " · ".join(PackedStringArray(journalist_minigame_sequence.map(func(value: int) -> String: return str(value))))
			panel_text.text = "PUZLE EN CURSO · %d / %d\n\nLa clave no coincide. La ruta volvió al inicio. Inténtalo otra vez.\n\n%s\n\nClave: %s\nEntrada: —\nContinúa con las teclas 1, 2 y 3." % [journalist_claim_index + 1, journalist_claims.size(), String(claim.get("puzzle_text", "")), code]
			return
		if journalist_minigame_input.size() < journalist_minigame_sequence.size():
			_show_journalist_claim()
			return
		journalist_puzzle_stage = "classify"
		_show_journalist_claim()
		return
	var claim_is_true := bool(claim.is_true)
	var approved := choice == 1
	var correct := approved == claim_is_true
	if correct:
		journalist_correct_classifications += 1
	if claim_is_true and approved:
		journalist_validated_info.append(journalist_claim_index)
	if not claim_is_true and not approved:
		journalist_rejected_false_count += 1
	var result_text := "CORRECTO" if correct else "ERROR DE VERIFICACIÓN"
	var feedback := "Dato verdadero aprobado y listo para difundirse." if claim_is_true and approved else "Dato falso rechazado; no se difundirá." if not claim_is_true and not approved else "Decisión incorrecta: este dato no se compartirá."
	journalist_results.append("Dato %d · %s · %s" % [journalist_claim_index + 1, result_text, "APROBADO" if approved else "RECHAZADO"])
	panel_text.text = "%s\n\n%s\n\nProgreso: %d / %d.\n\nPulsa E para continuar." % [result_text, feedback, journalist_claim_index + 1, journalist_claims.size()]
	journalist_claim_index += 1
	journalist_puzzle_stage = "result"

func _prepare_influencer_deliveries() -> void:
	influencer_delivery_queue.clear()
	influencer_delivery_cursor = 0
	var npc_order: Array[int] = []
	for npc_index in range(npc_targets.size()):
		npc_order.append(npc_index)
	if npc_order.is_empty():
		return
	npc_order.shuffle()
	var verified_facts := journalist_validated_info.duplicate()
	verified_facts.shuffle()
	var delivery_count := maxi(npc_order.size(), verified_facts.size())
	for delivery_index in range(delivery_count):
		var npc_index: int = int(npc_order[delivery_index]) if delivery_index < npc_order.size() else int(npc_order.pick_random())
		var info_index := int(verified_facts[delivery_index]) if delivery_index < verified_facts.size() else -1
		influencer_delivery_queue.append({"npc":npc_index, "info":info_index})

func _share_info_to_npc(npc_index: int) -> void:
	if not influencer_has_information:
		panel_text.text = "Espera a que el Mensajero termine de escanear los diez datos."
		return
	if influencer_delivery_cursor >= influencer_delivery_queue.size():
		panel_text.text = "Ya se completó la difusión de todos los datos verificados."
		return
	var delivery: Dictionary = influencer_delivery_queue[influencer_delivery_cursor]
	var expected_npc := int(delivery.npc)
	if npc_index != expected_npc:
		var next_name := String(npc_targets[expected_npc].name).replace("_", " ")
		panel_text.text = "Sigue el orden aleatorio de difusión. El siguiente vecino es %s." % next_name
		return
	var npc_name: String = String(npc_targets[npc_index].name).replace("_", " ")
	var info_index := int(delivery.info)
	if info_index >= 0:
		var messages: Array = shared_info_by_npc.get(npc_index, [])
		messages.append(info_index)
		shared_info_by_npc[npc_index] = messages
		var fact := String(journalist_claims[info_index].statement)
		panel_text.text = "MENSAJE VERIFICADO · %s\n\nCompartiste un dato verdadero aprobado por el Mensajero:\n“%s”\n\nDifusión: %d / %d." % [npc_name, fact, influencer_delivery_cursor + 1, influencer_delivery_queue.size()]
	else:
		panel_text.text = "ALERTA DE FUENTES · %s\n\nNo se validó otro dato verdadero. Avisaste al vecino que espere una fuente confirmada y no difundiste rumores.\n\nDifusión: %d / %d." % [npc_name, influencer_delivery_cursor + 1, influencer_delivery_queue.size()]
	informed_npcs[npc_index] = true
	influencer_delivery_cursor += 1
	_update_information_hud()
	_broadcast_coop_state()

func _next_npc_to_inform() -> int:
	if influencer_delivery_cursor < 0 or influencer_delivery_cursor >= influencer_delivery_queue.size():
		return -1
	return int(influencer_delivery_queue[influencer_delivery_cursor].npc)

func _open_chest_visual(chest: Node3D) -> void:
	if chest == null:
		return
	var players := chest.find_children("*", "AnimationPlayer", true, false)
	for player_node in players:
		var animator := player_node as AnimationPlayer
		for animation_name in animator.get_animation_list():
			if String(animation_name).to_lower().contains("open"):
				animator.play(String(animation_name))
				return

func _play_chest_open_sound(chest: Node3D) -> void:
	if chest == null or chest_open_stream == null:
		return
	var sound := chest.get_node_or_null("ChestOpenSoundPlayer") as AudioStreamPlayer3D
	if sound == null:
		sound = AudioStreamPlayer3D.new()
		sound.name = "ChestOpenSoundPlayer"
		sound.stream = chest_open_stream
		sound.volume_db = -8.0
		sound.unit_size = 3.0
		sound.max_distance = 14.0
		chest.add_child(sound)
	sound.play()

func _load_chest_open_sound() -> void:
	chest_near_stream = load(CHEST_NEAR_SOUND_PATH) as AudioStreamWAV
	if chest_near_stream == null:
		push_warning("No pude cargar el bucle de proximidad de los cofres.")
	else:
		var channels := 2 if chest_near_stream.stereo else 1
		var frame_count := int(chest_near_stream.data.size() / (channels * 2))
		chest_near_stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
		chest_near_stream.loop_begin = mini(roundi(chest_near_stream.mix_rate * CHEST_NEAR_LOOP_START_SECONDS), frame_count - 1)
		chest_near_stream.loop_end = frame_count
	var file := FileAccess.open(CHEST_OPEN_SOUND_PATH, FileAccess.READ)
	if file == null or file.get_length() <= 44:
		push_warning("No pude cargar el sonido de apertura del cofre.")
		return
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = 22050
	stream.stereo = false
	file.seek(44)
	stream.data = file.get_buffer(file.get_length() - 44)
	chest_open_stream = stream

func _close_chest_visual(chest: Node3D) -> void:
	if chest == null:
		return
	for player_node in chest.find_children("*", "AnimationPlayer", true, false):
		var animator := player_node as AnimationPlayer
		for animation_name in animator.get_animation_list():
			var animation_key := String(animation_name).to_lower()
			if animation_key.contains("close"):
				animator.play(String(animation_name))
				return
			if animation_key.contains("open"):
				animator.play(String(animation_name))
				animator.seek(0.0, true)
				animator.pause()
				return

func _roulette_role_used(wheel_id: String, role_name: String) -> bool:
	var uses: Dictionary = roulette_role_uses.get(wheel_id, {})
	return bool(uses.get(role_name, false))

func _mark_roulette_role_used(wheel_id: String, role_name: String) -> void:
	var uses: Dictionary = roulette_role_uses.get(wheel_id, {})
	uses[role_name] = true
	roulette_role_uses[wheel_id] = uses

func _find_roulette_info(wheel_id: String) -> Dictionary:
	for wheel_info in roulette_wheels:
		if String(wheel_info.get("id", "")) == wheel_id:
			return wheel_info
	return {}

func _use_roulette(wheel_id: String) -> void:
	if bool(roulette_spinning_wheels.get(wheel_id, false)):
		prompt.text = "La ruleta está girando…"
		prompt_panel.visible = true
		return
	if _roulette_role_used(wheel_id, active_role):
		panel_text.text = "Este rol ya giró esta ruleta. Puedes probar la otra ruleta o cambiar de rol."
		panel.visible = true
		return
	var outcome_index := randi_range(0, ROULETTE_OUTCOMES.size() - 1)
	_mark_roulette_role_used(wheel_id, active_role)
	if multiplayer.multiplayer_peer != null:
		rpc("_receive_roulette_spin", wheel_id, active_role, outcome_index)
	prompt.text = "La ruleta está girando…"
	prompt_panel.visible = true
	panel.visible = false
	_animate_roulette_spin(wheel_id, active_role, outcome_index, true)

@rpc("any_peer", "call_remote", "reliable")
func _receive_roulette_spin(wheel_id: String, role_name: String, outcome_index: int) -> void:
	if _roulette_role_used(wheel_id, role_name) or bool(roulette_spinning_wheels.get(wheel_id, false)):
		return
	_mark_roulette_role_used(wheel_id, role_name)
	_animate_roulette_spin(wheel_id, role_name, outcome_index, false)

func _animate_roulette_spin(wheel_id: String, role_name: String, outcome_index: int, show_result: bool) -> void:
	roulette_spinning_wheels[wheel_id] = true
	var wheel_info := _find_roulette_info(wheel_id)
	var spinner := wheel_info.get("node") as Node3D
	var start_rotation := spinner.rotation if is_instance_valid(spinner) else Vector3.ZERO
	var start_scale := spinner.scale if is_instance_valid(spinner) else Vector3.ONE
	var final_angle := TAU * 5.0 + TAU * (float(outcome_index) + 0.5) / float(ROULETTE_OUTCOMES.size())
	var spin_tween: Tween
	if is_instance_valid(spinner):
		spin_tween = create_tween()
		spin_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		spin_tween.tween_method(Callable(self, "_set_roulette_spin_angle").bind(spinner, start_rotation, start_scale), 0.0, final_angle, ROULETTE_SPIN_DURATION)
	var tick_player := AudioStreamPlayer3D.new()
	tick_player.name = "RouletteTickPlayer"
	tick_player.stream = roulette_tick_stream
	tick_player.volume_db = -9.0
	tick_player.unit_size = 4.0
	tick_player.max_distance = 26.0
	add_child(tick_player)
	tick_player.global_position = wheel_info.get("position", global_position)
	_play_roulette_ticks(tick_player)
	await get_tree().create_timer(ROULETTE_SPIN_DURATION).timeout
	if is_instance_valid(spinner):
		if is_instance_valid(spin_tween) and spin_tween.is_running():
			spin_tween.kill()
		_set_roulette_spin_angle(final_angle, spinner, start_rotation, start_scale)
	if is_instance_valid(tick_player):
		tick_player.queue_free()
	roulette_spinning_wheels.erase(wheel_id)
	var result_text := _apply_roulette_outcome(outcome_index)
	if show_result and is_instance_valid(panel_text):
		var result_title := "PREMIO DE LA RULETA" if outcome_index >= 0 and outcome_index < 4 else "DESVENTAJA DE LA RULETA"
		panel_text.text = result_title + " · " + role_name.to_upper() + "\n\n" + result_text + "\n\nPulsa E para cerrar."
		panel.visible = true
		_update_information_hud()
		_broadcast_coop_state()

func _play_roulette_ticks(tick_player: AudioStreamPlayer3D) -> void:
	for tick in range(ROULETTE_TICK_COUNT):
		if not is_instance_valid(tick_player):
			return
		tick_player.play()
		var progress := float(tick) / float(maxi(ROULETTE_TICK_COUNT - 1, 1))
		var interval_scale := lerpf(0.55, 1.45, pow(progress, 1.45))
		await get_tree().create_timer(ROULETTE_SPIN_DURATION / float(ROULETTE_TICK_COUNT) * interval_scale).timeout

func _set_roulette_spin_angle(angle: float, spinner: Node3D, start_rotation: Vector3, start_scale: Vector3) -> void:
	if not is_instance_valid(spinner):
		return
	spinner.transform.basis = Basis.from_euler(start_rotation) * Basis(Vector3.FORWARD, angle) * Basis.IDENTITY.scaled(start_scale)

func _apply_roulette_outcome(outcome_index: int) -> String:
	match outcome_index:
		0:
			speed_boost_time = 60.0
			_refresh_player_speed()
		1:
			game_time_remaining += 60.0
			_update_timer_hud()
		2:
			for index in range(npc_targets.size()):
				var state: Dictionary = npc_targets[index]
				state.mood = 1.0
				state.seconds_left = npc_mood_duration
				state.recharging = false
				state.recharge_elapsed = 0.0
				npc_targets[index] = state
				cheered_npcs[index] = true
				_play_roulette_cheer(index)
		3:
			_roulette_grant_half_cards()
		4:
			game_time_remaining = maxf(0.0, game_time_remaining - 60.0)
			_update_timer_hud()
			if game_time_remaining <= 0.0 and not game_timer_timeout:
				game_timer_timeout = true
				_end_game(false)
		5:
			for index in range(npc_targets.size()):
				var state: Dictionary = npc_targets[index]
				state.mood = 0.5
				state.seconds_left = npc_mood_duration * 0.5
				state.recharging = false
				state.recharge_elapsed = 0.0
				npc_targets[index] = state
		6:
			slow_time = 60.0
			_refresh_player_speed()
		7:
			double_jump_disabled_time = 60.0
			if is_instance_valid(player):
				player.set("max_air_jumps", 0)
				player.set("air_jumps_left", 0)
		8:
			_reset_roulette_card_mission()
	if outcome_index < 0 or outcome_index >= ROULETTE_OUTCOMES.size():
		return "La ruleta se detuvo."
	return ROULETTE_OUTCOMES[outcome_index]

func _play_roulette_cheer(npc_index: int) -> void:
	if npc_index < 0 or npc_index >= npc_targets.size():
		return
	var animator := npc_targets[npc_index].get("animator") as AnimationPlayer
	if not is_instance_valid(animator):
		return
	for animation_name in animator.get_animation_list():
		var animation_key := String(animation_name).to_lower()
		if animation_key.contains("cheer") or animation_key.contains("happy") or animation_key.contains("wave") or animation_key.contains("dance"):
			animator.play(String(animation_name))
			return

func _roulette_grant_half_cards() -> void:
	var clues: Array[String] = [
		"Alerta: un rumor sobre el centro comunitario no incluye un enlace oficial verificable.",
		"El calendario municipal anuncia una jornada de limpieza vecinal.",
		"Una encuesta a tres personas no representa a todo el reino.",
		"El portal electoral confirma fecha y hora del debate municipal.",
		"Una captura recortada no demuestra que el parque vaya a cerrar.",
		"Revisa si la propuesta de reparación presenta responsables y presupuesto.",
		"Compara la cifra del mensaje con el informe público original.",
		"El mensaje sobre fondos proviene de una cuenta anónima sin pruebas.",
		"Comprueba la fecha original de la noticia antes de compartirla.",
		"Consulta el acta electoral para confirmar el sitio y hora de votación."
	]
	var cards_to_grant := maxi(0, ceili(float(REQUIRED_INFO_CHESTS) * 0.5) - collected_info.size())
	if cards_to_grant == 0:
		return
	var granted := 0
	for index in range(REQUIRED_INFO_CHESTS):
		if collected_info.has(index):
			continue
		collected_info[index] = clues[index % clues.size()]
		granted += 1
		if index < info_chests.size():
			var chest := info_chests[index].node as Node3D
			if is_instance_valid(chest):
				_stop_chest_proximity_sound(chest)
				_open_chest_visual(chest)
				chest.set_meta("chest_sound_opened", true)
		if granted >= cards_to_grant:
			break
	answered = collected_info.size()
	var earned_pages := 0
	for threshold in INFORMATION_BOARD_PAGE_THRESHOLDS:
		if answered >= threshold:
			earned_pages += 1
	_set_board_pages_placed(earned_pages)
	info_delivered = earned_pages >= INFORMATION_BOARD_PAGE_THRESHOLDS.size()
	_update_information_hud()
	_broadcast_coop_state()

func _reset_roulette_card_mission() -> void:
	collected_info.clear()
	answered = 0
	hero_is_carrying_card = false
	pending_card_chest_index = -1
	pending_card_clue = ""
	card_carrier_peer_id = 0
	_return_chest_letter_to_spawn()
	info_delivered = false
	_set_board_pages_placed(0)
	for chest_info in info_chests:
		var chest := chest_info.node as Node3D
		if not is_instance_valid(chest):
			continue
		_close_chest_visual(chest)
		chest.set_meta("chest_sound_opened", false)
	_broadcast_coop_state()

func _update_speed_boost(delta: float) -> void:
	var previous_speed := ceili(speed_boost_time)
	var previous_slow := ceili(slow_time)
	var previous_double_jump_lock := ceili(double_jump_disabled_time)
	speed_boost_time = maxf(speed_boost_time - delta, 0.0)
	slow_time = maxf(slow_time - delta, 0.0)
	double_jump_disabled_time = maxf(double_jump_disabled_time - delta, 0.0)
	if double_jump_disabled_time > 0.0:
		if is_instance_valid(player):
			player.set("max_air_jumps", 0)
			player.set("air_jumps_left", 0)
	elif previous_double_jump_lock > 0 and is_instance_valid(player):
		player.set("max_air_jumps", 1)
		player.set("air_jumps_left", 1)
	_refresh_player_speed()
	if ceili(speed_boost_time) != previous_speed or ceili(slow_time) != previous_slow or ceili(double_jump_disabled_time) != previous_double_jump_lock:
		_update_information_hud()

func _refresh_player_speed() -> void:
	if not is_instance_valid(player):
		return
	var current_speed := 3.0 if slow_time > 0.0 else (9.0 if speed_boost_time > 0.0 else 6.0)
	player.set("speed", current_speed)

func _answer(choice: int) -> void:
	var q: Dictionary = questions[question_index]
	var correct: bool = choice == q.correct
	if correct:
		answered += 1
	var outcome := "✓ Buena decisión. " if correct else "✧ Puedes volver a pensar la decisión. "
	panel_text.text = outcome + q.fact + "\n\nProgreso: %d / %d estaciones resueltas.\n\nPulsa E para continuar." % [answered, stations.size()]
	hud.text = "◆ Ciudadanía: %d / 3     ◆ Confianza: %d%%" % [answered, 100 if correct else max(70, 100 - (question_index + 1) * 6)]
	question_index = -1

func _close_question() -> void:
	if revolutionary_rescue_dialogue_stage in ["guard_intro", "guard_wait", "guard_thanks"]:
		revolutionary_rescue_dialogue_stage = ""
		panel.visible = false
		panel_uses_q = false
		if is_instance_valid(player) and game_running and not revolutionary_rescue_animation_active:
			player.controls_enabled = true
		_update_information_hud()
		return
	if guardian8_dialogue_pending:
		guardian8_dialogue_pending = false
		_begin_whale_puzzle()
		return
	if journalist_claim_index >= 0 and journalist_puzzle_stage == "result":
		journalist_puzzle_stage = "minigame"
		if journalist_claim_index < journalist_claims.size():
			_prepare_journalist_minigame()
		_show_journalist_claim()
		return
	panel.visible = false
	panel_uses_q = false
	question_index = -1

func _guardian8_role_allowed() -> bool:
	return active_role in ["Influencer", "Candidato a alcalde"]

func _is_guardian8_event_owner() -> bool:
	return guardian8_owner_peer_id > 0 and guardian8_owner_peer_id == _local_peer_id()

func _local_peer_id() -> int:
	# Solo mode has no MultiplayerPeer assigned; Godot uses peer ID 1 for the local player.
	if multiplayer.multiplayer_peer == null:
		return 1
	return multiplayer.get_unique_id()

func _start_guardian8_interaction() -> void:
	panel_uses_q = true
	_play_npc_interaction_voice(guardian8)
	if guardian8_mission_completed:
		panel_text.text = "GUARDIA 8 · ACOMPAÑAMIENTO COMPLETADO\n\nGuardia 8 decidió quedarse con sus compañeros y pedir apoyo. Gracias por escucharlo y acompañarlo."
		panel.visible = true
		return
	if not _guardian8_role_allowed():
		panel_text.text = "GUARDIA 8 NECESITA APOYO\n\nEsta intervención la pueden realizar el Bardo o el Revolucionario. Cambia de rol con TAB para ayudar."
		panel.visible = true
		return
	if guardian8_owner_peer_id > 0 and not _is_guardian8_event_owner():
		panel_text.text = "OTRO JUGADOR YA ESTÁ ACOMPAÑANDO A GUARDIA 8\n\nContinúa con las demás tareas del equipo."
		panel.visible = true
		return
	if guardian8_owner_peer_id == 0:
		guardian8_owner_peer_id = _local_peer_id()
		_broadcast_coop_state()
	guardian8_dialogue_pending = true
	panel_uses_q = false
	if is_instance_valid(player):
		player.controls_enabled = false
	panel_text.text = "GUARDIA 8\n\n—Esta ballena aparece en los mensajes que me llegaron. Ahora entiendo que el reto es peligroso y no quiero seguirlo.\n\n—No tienes que hacerlo. Me quedo contigo y buscamos apoyo de alguien de confianza. Podemos reconstruir juntos la imagen y dejar ese reto atrás."
	panel.visible = true
	if is_instance_valid(whale_puzzle_panel):
		whale_puzzle_panel.visible = false
	_update_information_hud()

func _build_whale_puzzle_ui(layer: CanvasLayer) -> void:
	whale_puzzle_dim = ColorRect.new()
	whale_puzzle_dim.name = "Guardian8PuzzleBackdrop"
	whale_puzzle_dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	whale_puzzle_dim.color = Color(0.055, 0.075, 0.13, 0.76)
	whale_puzzle_dim.mouse_filter = Control.MOUSE_FILTER_STOP
	whale_puzzle_dim.visible = false
	layer.add_child(whale_puzzle_dim)
	whale_puzzle_panel = PanelContainer.new()
	whale_puzzle_panel.name = "Guardian8SupportPuzzle"
	whale_puzzle_panel.set_anchors_preset(Control.PRESET_CENTER)
	whale_puzzle_panel.custom_minimum_size = Vector2.ZERO
	whale_puzzle_panel.visible = false
	whale_puzzle_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	_style_texture_board(whale_puzzle_panel, Rect2(18, 0, 980, 770), Vector2(1040, 780), Vector4(82, 82, 128, 108))
	var content := VBoxContainer.new()
	content.name = "PuzzleBoardContent"
	content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 14)
	var puzzle_title_plaque := PanelContainer.new()
	puzzle_title_plaque.custom_minimum_size = Vector2(0, 54)
	puzzle_title_plaque.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	puzzle_title_plaque.add_theme_stylebox_override("panel", _dialogue_title_style())
	whale_puzzle_title = Label.new()
	whale_puzzle_title.text = "GUARDIA 08 · ACOMPAÑAMIENTO"
	whale_puzzle_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	whale_puzzle_title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	whale_puzzle_title.custom_minimum_size = Vector2(0, 42)
	_style_cartoon_text(whale_puzzle_title, 24)
	whale_puzzle_title.add_theme_color_override("font_color", Color("fff0bd"))
	puzzle_title_plaque.add_child(whale_puzzle_title)
	content.add_child(puzzle_title_plaque)
	whale_puzzle_instructions = Label.new()
	whale_puzzle_instructions.text = "Flechas: mueve la selección · MAYÚS o BLOQ MAYÚS: gira la pieza 90° · ESPACIO: toma o coloca"
	whale_puzzle_instructions.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	whale_puzzle_instructions.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_style_cartoon_text(whale_puzzle_instructions, 15)
	whale_puzzle_instructions.add_theme_color_override("font_color", Color("f8dfab"))
	content.add_child(whale_puzzle_instructions)
	whale_puzzle_grid = GridContainer.new()
	whale_puzzle_grid.name = "WhalePuzzleGrid"
	whale_puzzle_grid.columns = 3
	whale_puzzle_grid.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	whale_puzzle_grid.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	whale_puzzle_grid.add_theme_constant_override("h_separation", 8)
	whale_puzzle_grid.add_theme_constant_override("v_separation", 8)
	content.add_child(whale_puzzle_grid)
	whale_puzzle_cells.clear()
	for index in range(9):
		var cell := Button.new()
		cell.custom_minimum_size = Vector2(240, 160)
		cell.focus_mode = Control.FOCUS_NONE
		cell.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var tile_style := StyleBoxFlat.new()
		tile_style.bg_color = Color("2b1a12")
		tile_style.border_color = Color("f2c45d")
		tile_style.set_border_width_all(4)
		tile_style.set_corner_radius_all(10)
		cell.add_theme_stylebox_override("normal", tile_style)
		cell.add_theme_stylebox_override("hover", tile_style)
		cell.add_theme_stylebox_override("pressed", tile_style)
		var piece := TextureRect.new()
		piece.name = "Piece"
		piece.set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
		piece.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		piece.stretch_mode = TextureRect.STRETCH_SCALE
		piece.mouse_filter = Control.MOUSE_FILTER_IGNORE
		cell.add_child(piece)
		whale_puzzle_grid.add_child(cell)
		whale_puzzle_cells.append(cell)
	var footer := Label.new()
	footer.text = "Flechas: mover · MAYÚS/BLOQ MAYÚS: girar 90° · ESPACIO: tomar o colocar"
	footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_style_cartoon_text(footer, 13)
	footer.add_theme_color_override("font_color", Color("f8dfab"))
	content.add_child(footer)
	whale_puzzle_panel.add_child(content)
	layer.add_child(whale_puzzle_panel)
	get_viewport().size_changed.connect(_layout_whale_puzzle_ui)
	_layout_whale_puzzle_ui()

func _layout_whale_puzzle_ui() -> void:
	if not is_instance_valid(whale_puzzle_panel) or not is_instance_valid(whale_puzzle_grid):
		return
	var viewport_size := get_viewport().get_visible_rect().size
	var board_height := minf(viewport_size.y * 0.96, 960.0)
	var board_width := minf(minf(viewport_size.x * 0.90, 1400.0), board_height * 1.55)
	var board_size := Vector2(minf(viewport_size.x * 0.98, board_width), minf(viewport_size.y * 0.98, board_height))
	whale_puzzle_panel.custom_minimum_size = board_size
	whale_puzzle_panel.size = board_size
	whale_puzzle_panel.offset_left = -board_size.x * 0.5
	var vertical_shift := viewport_size.y * 0.045
	whale_puzzle_panel.offset_top = -board_size.y * 0.5 - vertical_shift
	whale_puzzle_panel.offset_right = board_size.x * 0.5
	whale_puzzle_panel.offset_bottom = board_size.y * 0.5 - vertical_shift
	var cell_height := maxf(52.0, (board_size.y - 350.0) / 3.0)
	var cell_width := cell_height * 1.5
	var max_cell_width := (board_size.x - 164.0 - 16.0) / 3.0
	if cell_width > max_cell_width:
		cell_width = max_cell_width
		cell_height = cell_width / 1.5
	for cell in whale_puzzle_cells:
		cell.custom_minimum_size = Vector2(cell_width, cell_height)
	_refresh_whale_puzzle_ui()

func _begin_whale_puzzle() -> void:
	if not guardian8_dialogue_pending and not _is_guardian8_event_owner():
		return
	guardian8_dialogue_pending = false
	whale_puzzle_active = true
	whale_puzzle_tiles.clear()
	whale_puzzle_rotations.clear()
	for tile_id in range(9):
		# Keep each crop intact: randomize only its cell and quarter-turn rotation.
		whale_puzzle_tiles.append(tile_id)
		whale_puzzle_rotations.append(0)
	for index in range(whale_puzzle_tiles.size()):
		var swap_index := randi_range(index, whale_puzzle_tiles.size() - 1)
		var tile_id := whale_puzzle_tiles[index]
		whale_puzzle_tiles[index] = whale_puzzle_tiles[swap_index]
		whale_puzzle_tiles[swap_index] = tile_id
		var rotation_code := randi_range(0, 3)
		whale_puzzle_rotations[index] = rotation_code
	whale_puzzle_selected_cell = 0
	whale_puzzle_held_tile = -1
	whale_puzzle_held_rotation = 0
	whale_puzzle_held_origin = -1
	if _is_whale_puzzle_solved():
		var first_tile := whale_puzzle_tiles[0]
		whale_puzzle_tiles[0] = whale_puzzle_tiles[1]
		whale_puzzle_tiles[1] = first_tile
	panel.visible = false
	whale_puzzle_panel.visible = true
	whale_puzzle_dim.visible = true
	if is_instance_valid(player):
		player.controls_enabled = false
	_refresh_whale_puzzle_ui()

func _move_whale_puzzle_cursor(dx: int, dy: int) -> void:
	var col := whale_puzzle_selected_cell % 3
	var row := int(whale_puzzle_selected_cell / 3)
	col = clampi(col + dx, 0, 2)
	row = clampi(row + dy, 0, 2)
	whale_puzzle_selected_cell = row * 3 + col
	_refresh_whale_puzzle_ui()

func _rotate_whale_puzzle_tile(cell_index: int, direction: int) -> void:
	if cell_index < 0 or cell_index >= whale_puzzle_tiles.size():
		return
	if whale_puzzle_held_tile >= 0 and cell_index == whale_puzzle_selected_cell:
		whale_puzzle_held_rotation = posmod(whale_puzzle_held_rotation + direction, 4)
	else:
		if whale_puzzle_tiles[cell_index] < 0:
			return
		whale_puzzle_rotations[cell_index] = posmod(whale_puzzle_rotations[cell_index] + direction, 4)
	_refresh_whale_puzzle_ui()

func _toggle_whale_puzzle_pickup() -> void:
	if not whale_puzzle_active:
		return
	var cell_index := whale_puzzle_selected_cell
	if whale_puzzle_held_tile < 0:
		if whale_puzzle_tiles[cell_index] < 0:
			return
		whale_puzzle_held_tile = whale_puzzle_tiles[cell_index]
		whale_puzzle_held_rotation = whale_puzzle_rotations[cell_index]
		whale_puzzle_held_origin = cell_index
	else:
		if cell_index != whale_puzzle_held_origin:
			var displaced_tile := whale_puzzle_tiles[cell_index]
			var displaced_rotation := whale_puzzle_rotations[cell_index]
			whale_puzzle_tiles[whale_puzzle_held_origin] = displaced_tile
			whale_puzzle_rotations[whale_puzzle_held_origin] = displaced_rotation
			whale_puzzle_tiles[cell_index] = whale_puzzle_held_tile
			whale_puzzle_rotations[cell_index] = whale_puzzle_held_rotation
		whale_puzzle_held_tile = -1
		whale_puzzle_held_rotation = 0
		whale_puzzle_held_origin = -1
	_refresh_whale_puzzle_ui()
	if _is_whale_puzzle_solved():
		_complete_guardian8_mission()

func _refresh_whale_puzzle_ui() -> void:
	if not is_instance_valid(whale_puzzle_grid):
		return
	for index in range(mini(whale_puzzle_cells.size(), whale_puzzle_tiles.size())):
		var tile_id := whale_puzzle_tiles[index]
		var rotation_code := whale_puzzle_rotations[index]
		if whale_puzzle_held_tile >= 0:
			if index == whale_puzzle_selected_cell:
				tile_id = whale_puzzle_held_tile
				rotation_code = whale_puzzle_held_rotation
			elif index == whale_puzzle_held_origin:
				tile_id = -1
				rotation_code = 0
		var cell := whale_puzzle_cells[index]
		var piece := cell.get_node("Piece") as TextureRect
		piece.texture = null
		# Never mirror a crop; only rotation_degrees changes its orientation.
		piece.flip_h = false
		piece.flip_v = false
		var cell_size := cell.custom_minimum_size
		var inner_size := cell_size - Vector2(12, 12)
		var quarter_turn := rotation_code % 2 == 1
		piece.size = Vector2(inner_size.y, inner_size.x) if quarter_turn else inner_size
		piece.position = (cell_size - piece.size) * 0.5
		piece.pivot_offset = piece.size * 0.5
		piece.rotation_degrees = 0.0
		if tile_id >= 0:
			var atlas := AtlasTexture.new()
			atlas.atlas = WHALE_PUZZLE_TEXTURE
			atlas.filter_clip = true
			var image_size := WHALE_PUZZLE_TEXTURE.get_size()
			var tile_size := Vector2(float(image_size.x), float(image_size.y)) / 3.0
			atlas.region = Rect2(Vector2(tile_id % 3, int(tile_id / 3)) * tile_size, tile_size)
			piece.texture = atlas
			piece.rotation_degrees = float(rotation_code) * 90.0
		var style := StyleBoxFlat.new()
		style.bg_color = Color("2b1a12")
		style.border_color = Color("fff0a8") if index == whale_puzzle_selected_cell else Color("e9b84d")
		style.set_border_width_all(5 if index == whale_puzzle_selected_cell else 3)
		style.set_corner_radius_all(8)
		cell.add_theme_stylebox_override("normal", style)
		cell.add_theme_stylebox_override("hover", style)
		cell.add_theme_stylebox_override("pressed", style)

func _is_whale_puzzle_solved() -> bool:
	if whale_puzzle_held_tile >= 0 or whale_puzzle_tiles.size() != 9:
		return false
	for index in range(9):
		if whale_puzzle_tiles[index] != index or whale_puzzle_rotations[index] != 0:
			return false
	return true

func _complete_guardian8_mission() -> void:
	if guardian8_mission_completed:
		return
	whale_puzzle_active = false
	guardian8_mission_completed = true
	whale_puzzle_panel.visible = false
	whale_puzzle_dim.visible = false
	if is_instance_valid(player) and game_running:
		player.controls_enabled = true
	if guardian8 != null and is_instance_valid(guardian8):
		guardian8.global_position = guardian8_home_position
		for candidate in guardian8.find_children("*", "AnimationPlayer", true, false):
			var animator := candidate as AnimationPlayer
			if animator != null:
				for animation_name in animator.get_animation_list():
					if String(animation_name).to_lower().contains("idle"):
						animator.play(String(animation_name))
						break
				if animator.current_animation.to_lower().contains("jump"):
					animator.stop()
	panel_text.text = "GUARDIA 8 · ACOMPAÑAMIENTO COMPLETADO\n\nLa imagen quedó armada. Guardia 8 decide quedarse con sus compañeros y buscar apoyo de alguien de confianza. Gracias por escucharlo y acompañarlo."
	panel.visible = true
	_update_information_hud()
	_broadcast_coop_state()
	_check_game_completion()

func _add_model(path: String, at: Vector3, model_scale: Vector3, parent: Node, collidable := false, rotation_y := 0.0) -> Node3D:
	if not ResourceLoader.exists(path):
		return null
	var node: Node3D = load(path).instantiate()
	node.position = at
	node.scale = model_scale
	node.rotation.y = rotation_y
	parent.add_child(node)
	if collidable:
		_add_mesh_collisions(node)
	return node

func _add_mesh_collisions(root: Node3D) -> void:
	var meshes := root.find_children("*", "MeshInstance3D", true, false)
	if meshes.is_empty():
		return
	var body := StaticBody3D.new()
	body.name = "AssetMeshCollision"
	root.add_child(body)
	var root_inverse := root.global_transform.affine_inverse()
	for node in meshes:
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh == null:
			continue
		var shape := mesh_instance.mesh.create_trimesh_shape()
		if shape == null:
			continue
		var collision := CollisionShape3D.new()
		collision.shape = shape
		collision.transform = root_inverse * mesh_instance.global_transform
		body.add_child(collision)

func _add_box(node_name: String, at: Vector3, size: Vector3, color: Color, solid: bool, visible_mesh := true) -> void:
	var body := StaticBody3D.new() if solid else Node3D.new()
	body.name = node_name
	body.position = at
	if visible_mesh:
		var mesh_instance := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = size
		var material := StandardMaterial3D.new()
		material.albedo_color = color
		material.roughness = 0.82
		box.material = material
		mesh_instance.mesh = box
		body.add_child(mesh_instance)
	if solid:
		var collision := CollisionShape3D.new()
		var shape := BoxShape3D.new()
		shape.size = size
		collision.shape = shape
		body.add_child(collision)
	add_child(body)

func _add_glow_marker(at: Vector3) -> void:
	var marker := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = 0.18
	mesh.height = 0.36
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color("69f0df")
	mat.emission_enabled = true
	mat.emission = Color("20e8d1")
	mat.emission_energy_multiplier = 3.0
	mesh.material = mat
	marker.mesh = mesh
	marker.position = at
	add_child(marker)
	var light := OmniLight3D.new()
	light.position = at
	light.light_color = Color("62e9da")
	light.light_energy = 0.8
	light.omni_range = 5
	add_child(light)

func _game_ui_atlas_region(region: Rect2) -> AtlasTexture:
	var atlas_texture := AtlasTexture.new()
	atlas_texture.atlas = load(GAME_UI_ATLAS_PATH) as Texture2D
	atlas_texture.region = region
	return atlas_texture

func _style_restart_button(target: Button) -> void:
	var plaque := StyleBoxTexture.new()
	plaque.texture = RESTART_BUTTON_MEDALLION
	plaque.content_margin_left = 0
	plaque.content_margin_right = 0
	plaque.content_margin_top = 0
	plaque.content_margin_bottom = 0
	var hover := plaque.duplicate() as StyleBoxTexture
	hover.modulate_color = Color(1.12, 1.08, 0.92, 1.0)
	var pressed := plaque.duplicate() as StyleBoxTexture
	pressed.modulate_color = Color(0.84, 0.72, 0.54, 1.0)
	pressed.content_margin_top = 14
	pressed.content_margin_bottom = 10
	target.add_theme_stylebox_override("normal", plaque)
	target.add_theme_stylebox_override("hover", hover)
	target.add_theme_stylebox_override("pressed", pressed)
	target.add_theme_stylebox_override("focus", hover)
	target.add_theme_color_override("font_color", Color("fff0bd"))
	target.add_theme_color_override("font_hover_color", Color("fff9dd"))
	target.add_theme_color_override("font_pressed_color", Color("ffe39a"))
	target.add_theme_color_override("font_focus_color", Color("fff9dd"))
	target.add_theme_constant_override("outline_size", 2)
	target.add_theme_color_override("font_outline_color", Color("563016"))

func _animate_restart_button(hovered: bool) -> void:
	if not is_instance_valid(restart_button):
		return
	if is_instance_valid(restart_button_tween) and restart_button_tween.is_running():
		restart_button_tween.kill()
	restart_button_tween = create_tween()
	restart_button_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	restart_button_tween.tween_property(restart_button, "scale", Vector2(1.035, 1.035) if hovered else Vector2.ONE, 0.14)

func _press_restart_button(is_pressed: bool) -> void:
	if not is_instance_valid(restart_button):
		return
	if is_instance_valid(restart_button_tween) and restart_button_tween.is_running():
		restart_button_tween.kill()
	restart_button_tween = create_tween()
	restart_button_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	var destination := Vector2(0.98, 0.98) if is_pressed else (Vector2(1.035, 1.035) if restart_button.get_global_rect().has_point(get_viewport().get_mouse_position()) else Vector2.ONE)
	restart_button_tween.tween_property(restart_button, "scale", destination, 0.08)

func _style_atlas_panel(target: PanelContainer, minimum_size: Vector2 = Vector2.ZERO) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0, 0, 0, 0)
	style.border_color = Color(0, 0, 0, 0)
	style.set_border_width_all(0)
	style.content_margin_left = 0
	style.content_margin_right = 0
	style.content_margin_top = 0
	style.content_margin_bottom = 0
	target.add_theme_stylebox_override("panel", style)
	if minimum_size != Vector2.ZERO:
		target.custom_minimum_size = minimum_size

func _style_panel(target: PanelContainer, background: Color, border: Color) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(9)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	target.add_theme_stylebox_override("panel", style)

func _style_wood_panel(target: PanelContainer, background: Color = Color("432a1d"), minimum_size: Vector2 = Vector2.ZERO) -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = Color("e8b44e")
	style.set_border_width_all(3)
	style.set_corner_radius_all(14)
	style.shadow_color = Color(0.08, 0.035, 0.015, 0.58)
	style.shadow_size = 8
	style.shadow_offset = Vector2(0, 4)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	target.add_theme_stylebox_override("panel", style)
	if minimum_size != Vector2.ZERO:
		target.custom_minimum_size = minimum_size

func _style_texture_board(target: PanelContainer, region: Rect2, minimum_size: Vector2, content_margins: Vector4) -> void:
	var board_atlas := AtlasTexture.new()
	board_atlas.atlas = DIALOGUE_BOARDS_ATLAS
	board_atlas.region = region
	board_atlas.filter_clip = true
	var board_style := StyleBoxTexture.new()
	board_style.texture = board_atlas
	board_style.content_margin_left = content_margins.x
	board_style.content_margin_right = content_margins.y
	board_style.content_margin_top = content_margins.z
	board_style.content_margin_bottom = content_margins.w
	target.add_theme_stylebox_override("panel", board_style)
	target.custom_minimum_size = minimum_size

func _dialogue_title_style() -> StyleBoxFlat:
	var title_style := StyleBoxFlat.new()
	title_style.bg_color = Color("58341e")
	title_style.border_color = Color("f4c35b")
	title_style.set_border_width_all(3)
	title_style.set_corner_radius_all(18)
	title_style.shadow_color = Color(0.16, 0.075, 0.02, 0.68)
	title_style.shadow_size = 6
	title_style.shadow_offset = Vector2(0, 3)
	title_style.content_margin_left = 16
	title_style.content_margin_right = 16
	title_style.content_margin_top = 4
	title_style.content_margin_bottom = 4
	return title_style

func _dialogue_keycap_style() -> StyleBoxFlat:
	var keycap_style := StyleBoxFlat.new()
	keycap_style.bg_color = Color("f0d49b")
	keycap_style.border_color = Color("9c5c22")
	keycap_style.set_border_width_all(3)
	keycap_style.set_corner_radius_all(10)
	keycap_style.shadow_color = Color(0.12, 0.055, 0.025, 0.72)
	keycap_style.shadow_size = 4
	keycap_style.shadow_offset = Vector2(0, 2)
	return keycap_style

func _sync_interaction_plaque() -> void:
	if not is_instance_valid(prompt) or not is_instance_valid(prompt_keycap_label) or not is_instance_valid(prompt_action_label):
		return
	var current_text := prompt.text.strip_edges()
	var separator_index := current_text.find("·")
	var key_name := current_text.substr(0, separator_index).strip_edges() if separator_index > 0 else ""
	var has_action_key := key_name in ["E", "Q", "ESPACIO"]
	var keycap_panel := prompt_keycap_label.get_parent() as PanelContainer
	prompt_keycap_label.visible = has_action_key
	if has_action_key:
		prompt_keycap_label.text = key_name
		var is_space_key := key_name == "ESPACIO"
		if is_instance_valid(keycap_panel):
			keycap_panel.visible = true
			keycap_panel.custom_minimum_size = Vector2(112, 56) if is_space_key else Vector2(62, 56)
		prompt_keycap_label.custom_minimum_size = Vector2(104, 48) if is_space_key else Vector2(52, 48)
		prompt_keycap_label.add_theme_font_size_override("font_size", 14 if is_space_key else 22)
		var action_text := current_text.substr(separator_index + 1).strip_edges()
		prompt_action_label.text = "CERRAR" if action_text.to_lower() == "cerrar" else action_text
		prompt_action_label.add_theme_font_size_override("font_size", 17 if action_text.length() > 22 else 19)
	else:
		if is_instance_valid(keycap_panel):
			keycap_panel.visible = false
		prompt_action_label.text = current_text

func _sync_dialogue_board_text() -> void:
	if not is_instance_valid(panel_text) or not is_instance_valid(dialogue_title_label) or not is_instance_valid(dialogue_body_label):
		return
	if dialogue_source_cache == panel_text.text:
		return
	dialogue_source_cache = panel_text.text
	var lines := dialogue_source_cache.split("\n")
	var title_index := -1
	for index in range(lines.size()):
		if not String(lines[index]).strip_edges().is_empty():
			title_index = index
			break
	if title_index < 0:
		dialogue_title_label.text = "MENSAJE DEL REINO"
		dialogue_body_label.text = ""
		return
	var title := String(lines[title_index]).strip_edges()
	var handoff_notice := title.begins_with("El Héroe entrega aquí las cartas")
	var knife_notice := title.begins_with("Oh, un cuchillo") or title.begins_with("Ya tienes el cuchillo") or title.begins_with("Recogiste el cuchillo")
	var displayed_title := title
	if handoff_notice:
		displayed_title = "TABLÓN DE INFORMACIÓN"
	elif title.begins_with("Oh, un cuchillo"):
		displayed_title = "HALLAZGO · CUCHILLO"
	elif title.begins_with("Ya tienes el cuchillo") or title.begins_with("Recogiste el cuchillo"):
		displayed_title = "CUCHILLO RECOGIDO"
	elif title.begins_with("GUARDIA 09 · LIBERADO"):
		displayed_title = "RESCATE COMPLETADO"
	dialogue_title_label.text = "◆   %s   ◆" % displayed_title
	var body_lines: Array[String] = []
	if handoff_notice:
		body_lines.append(title)
	if knife_notice:
		body_lines.append(title)
	var compact_research_puzzle := (title.begins_with("ESCANEO DE DATOS") and dialogue_source_cache.contains("PUZLE DE TRES EN RAYA")) or title.begins_with("PUZLE EN CURSO")
	for index in range(title_index + 1, lines.size()):
		var body_line := String(lines[index])
		var normalized_line := body_line.strip_edges().to_lower()
		if normalized_line.begins_with("pulsa e para cerrar") or normalized_line.begins_with("pulsa q para cerrar") or normalized_line.begins_with("pulsa espacio para abrir el rompecabezas"):
			continue
		if compact_research_puzzle and body_line.strip_edges().is_empty():
			continue
		body_lines.append(body_line)
	dialogue_body_label.text = "\n".join(body_lines).strip_edges()
	_layout_dialogue_board()

func _layout_dialogue_board() -> void:
	if not is_instance_valid(panel) or not is_instance_valid(prompt_panel) or not is_instance_valid(dialogue_title_plaque):
		return
	var viewport_size := get_viewport().get_visible_rect().size
	var knife_notice := is_instance_valid(panel_text) and (panel_text.text.begins_with("Oh, un cuchillo") or panel_text.text.begins_with("Ya tienes el cuchillo") or panel_text.text.begins_with("Recogiste el cuchillo"))
	var rescue_notice := is_instance_valid(panel_text) and panel_text.text.begins_with("GUARDIA 09 · LIBERADO")
	var centered_knife_panel := knife_notice or rescue_notice
	var dialogue_body_font := int(round(clampf(viewport_size.y * 0.028, 16.0, 21.0)))
	var is_research_puzzle := is_instance_valid(panel_text) and panel_text.text.begins_with("ESCANEO DE DATOS") and panel_text.text.contains("PUZLE DE TRES EN RAYA")
	if is_research_puzzle:
		dialogue_body_font = int(round(clampf(viewport_size.y * 0.020, 14.0, 16.0)))
	elif is_instance_valid(panel_text) and (panel_text.text.begins_with("PUZLE EN CURSO") or panel_text.text.begins_with("El Héroe entrega aquí las cartas")):
		dialogue_body_font = int(round(clampf(viewport_size.y * 0.022, 15.0, 18.0)))
	if knife_notice:
		dialogue_body_font = int(round(clampf(viewport_size.y * 0.024, 15.0, 18.0)))
	dialogue_body_label.add_theme_font_size_override("font_size", dialogue_body_font)
	var dialogue_title_font := int(round(clampf(viewport_size.y * 0.026, 16.0, 20.0)))
	if dialogue_title_label.text.length() > 28:
		dialogue_title_font = int(round(dialogue_title_font * 0.82))
	if dialogue_title_label.text.length() > 38:
		dialogue_title_font = int(round(dialogue_title_font * 0.78))
	dialogue_title_label.add_theme_font_size_override("font_size", dialogue_title_font)
	# Standard conversations sit beside the NPC, leaving the mission HUD visible.
	# Only the whale puzzle uses the larger centered layout.
	var board_size := Vector2(minf(viewport_size.x * 0.52, 720.0), minf(viewport_size.y * 0.64, 620.0))
	board_size.x = maxf(440.0, board_size.x)
	board_size.y = maxf(360.0, board_size.y)
	if centered_knife_panel:
		board_size = Vector2(minf(viewport_size.x * 0.62, 760.0), minf(viewport_size.y * 0.50, 390.0))
		board_size.x = maxf(420.0, board_size.x)
		board_size.y = maxf(300.0, board_size.y)
	panel.custom_minimum_size = board_size
	panel.size = board_size
	if centered_knife_panel:
		panel.set_anchors_preset(Control.PRESET_CENTER)
		panel.offset_left = -board_size.x * 0.5
		panel.offset_top = -board_size.y * 0.5
		panel.offset_right = board_size.x * 0.5
		panel.offset_bottom = board_size.y * 0.5
	else:
		panel.set_anchors_preset(Control.PRESET_CENTER_RIGHT)
		var right_margin := viewport_size.x * 0.04
		var vertical_shift := viewport_size.y * 0.11
		panel.offset_left = -board_size.x - right_margin
		panel.offset_top = -board_size.y * 0.5 - vertical_shift
		panel.offset_right = -right_margin
		panel.offset_bottom = board_size.y * 0.5 - vertical_shift
	var board_style := StyleBoxTexture.new()
	var board_atlas := AtlasTexture.new()
	board_atlas.atlas = DIALOGUE_BOARDS_ATLAS
	board_atlas.region = Rect2(18, 0, 980, 770)
	board_atlas.filter_clip = true
	board_style.texture = board_atlas
	board_style.content_margin_left = board_size.x * 0.14
	board_style.content_margin_right = board_size.x * 0.14
	board_style.content_margin_top = board_size.y * 0.17
	board_style.content_margin_bottom = board_size.y * 0.09
	panel.add_theme_stylebox_override("panel", board_style)
	var title_width := board_size.x * (0.78 if centered_knife_panel else 0.80)
	var title_holder_size := Vector2(title_width, 52.0 + board_size.y * 0.05)
	dialogue_title_holder.custom_minimum_size = title_holder_size
	dialogue_title_holder.size = title_holder_size
	dialogue_title_plaque.custom_minimum_size = Vector2(title_width, 52.0)
	dialogue_title_plaque.size = dialogue_title_plaque.custom_minimum_size
	dialogue_title_plaque.position = Vector2(0, board_size.y * (0.025 if centered_knife_panel else 0.04))
	var plaque_width := minf(viewport_size.x * 0.43, 600.0)
	var plaque_height := clampf(viewport_size.y * 0.24, 144.0, 178.0)
	prompt_panel.custom_minimum_size = Vector2(plaque_width, plaque_height)
	prompt_panel.size = Vector2(plaque_width, plaque_height)
	var action_center_offset := 0.0
	prompt_panel.offset_left = action_center_offset - plaque_width * 0.5
	var bottom_margin := maxf(12.0, viewport_size.y * 0.02)
	prompt_panel.offset_top = -plaque_height - bottom_margin
	prompt_panel.offset_right = action_center_offset + plaque_width * 0.5
	prompt_panel.offset_bottom = -bottom_margin
	prompt.custom_minimum_size = Vector2.ZERO
	var action_margin_x := plaque_width * 0.075
	var action_margin_top := plaque_height * 0.10
	var action_margin_bottom := plaque_height * 0.02
	var action_style := StyleBoxTexture.new()
	var action_atlas := AtlasTexture.new()
	action_atlas.atlas = DIALOGUE_BOARDS_ATLAS
	action_atlas.region = Rect2(985, 230, 1015, 280)
	action_atlas.filter_clip = true
	action_style.texture = action_atlas
	action_style.content_margin_left = action_margin_x
	action_style.content_margin_right = action_margin_x
	action_style.content_margin_top = action_margin_top
	action_style.content_margin_bottom = action_margin_bottom
	prompt_panel.add_theme_stylebox_override("panel", action_style)

func _style_wood_button(target: Button) -> void:
	var normal := StyleBoxFlat.new()
	normal.bg_color = Color("663d23")
	normal.border_color = Color("e9b84d")
	normal.set_border_width_all(2)
	normal.set_corner_radius_all(10)
	normal.content_margin_left = 12
	normal.content_margin_right = 12
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color("80502a")
	hover.border_color = Color("fff0ad")
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color("432a1d")
	target.add_theme_stylebox_override("normal", normal)
	target.add_theme_stylebox_override("hover", hover)
	target.add_theme_stylebox_override("pressed", pressed)
	target.add_theme_stylebox_override("focus", hover)
	target.add_theme_color_override("font_color", Color("fff0bd"))
	target.add_theme_color_override("font_hover_color", Color("fff7d7"))
	target.add_theme_color_override("font_pressed_color", Color("fff0bd"))
