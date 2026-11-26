extends Node3D
## Guardia suspendido boca abajo: brazos relajados hacia el suelo con un vaivén leve.

const VELOCIDAD_VAIVEN := 1.8
const ANGULO_CAIDA := 1.28
const AMPLITUD := 0.12

var _esqueleto: Skeleton3D
var _brazo_izquierdo := -1
var _brazo_derecho := -1
var _tiempo := 0.0
var _liberado := false
var _mezcla_liberacion := 0.0
var _pose_inicial_izquierda := Quaternion.IDENTITY
var _pose_inicial_derecha := Quaternion.IDENTITY


func _ready() -> void:
	_esqueleto = get_node_or_null("GuardiaOriginal/character-knight/Skeleton3D") as Skeleton3D
	if _esqueleto == null:
		return
	_brazo_izquierdo = _esqueleto.find_bone("arm-left")
	_brazo_derecho = _esqueleto.find_bone("arm-right")
	_actualizar_brazos()


func _process(delta: float) -> void:
	if _esqueleto == null or _brazo_izquierdo < 0 or _brazo_derecho < 0:
		return
	_tiempo += delta
	if _liberado:
		_mezcla_liberacion = minf(_mezcla_liberacion + delta * 1.8, 1.0)
		_actualizar_brazos_liberado()
	else:
		_actualizar_brazos()


func liberar() -> void:
	if _esqueleto == null or _brazo_izquierdo < 0 or _brazo_derecho < 0:
		return
	_pose_inicial_izquierda = _esqueleto.get_bone_pose_rotation(_brazo_izquierdo)
	_pose_inicial_derecha = _esqueleto.get_bone_pose_rotation(_brazo_derecho)
	_mezcla_liberacion = 0.0
	_liberado = true
	set_process(true)


func restaurar_suspension() -> void:
	_liberado = false
	_mezcla_liberacion = 0.0
	_tiempo = 0.0
	if _esqueleto != null and _brazo_izquierdo >= 0 and _brazo_derecho >= 0:
		_actualizar_brazos()
	set_process(true)


func _actualizar_brazos_liberado() -> void:
	# Al quedar de pie, los brazos bajan desde la pose de suspensión y luego
	# mantienen un vaivén corto, relajado, de respiración y recuperación.
	var mezcla := ease(_mezcla_liberacion, 0.65)
	var vaiven_izquierdo := sin(_tiempo * 1.35) * 0.055
	var vaiven_derecho := sin(_tiempo * 1.35 + 0.55) * 0.055
	var destino_izquierdo := Quaternion(Vector3.BACK, -1.04 + vaiven_izquierdo)
	var destino_derecho := Quaternion(Vector3.BACK, 1.04 + vaiven_derecho)
	_esqueleto.set_bone_pose_rotation(_brazo_izquierdo, _pose_inicial_izquierda.slerp(destino_izquierdo, mezcla))
	_esqueleto.set_bone_pose_rotation(_brazo_derecho, _pose_inicial_derecha.slerp(destino_derecho, mezcla))


func _actualizar_brazos() -> void:
	# El modelo está invertido en la escena; +Y local apunta hacia abajo en el mundo.
	# Rotamos los hombros hacia +Y y añadimos un balanceo pequeño y desfasado.
	var vaiven_izquierdo := sin(_tiempo * VELOCIDAD_VAIVEN) * AMPLITUD
	var vaiven_derecho := sin(_tiempo * VELOCIDAD_VAIVEN + 0.8) * AMPLITUD
	_esqueleto.set_bone_pose_rotation(_brazo_izquierdo, Quaternion(Vector3.BACK, ANGULO_CAIDA + vaiven_izquierdo))
	_esqueleto.set_bone_pose_rotation(_brazo_derecho, Quaternion(Vector3.BACK, -ANGULO_CAIDA - vaiven_derecho))
