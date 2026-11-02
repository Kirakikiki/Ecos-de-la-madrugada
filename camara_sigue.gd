extends Camera3D
@export var limite_min = Vector2(-14, -14) # x y z mínimas
@export var limite_max = Vector2(14, 14) # x y z máximas
@export var objetivo: Node3D
@export var distancia = Vector3(0, 10, 5)
@export var suavizado = 4.0

func _ready():
	top_level = true
	# Se orienta UNA vez, mirando al objetivo.
	look_at_from_position(objetivo.global_position + distancia,
		objetivo.global_position)


func _physics_process(delta):
	var foco = objetivo.global_position
	foco.x = clamp(foco.x, limite_min.x, limite_max.x)
	foco.z = clamp(foco.z, limite_min.y, limite_max.y)
	var destino = objetivo.global_position + distancia
	global_position = global_position.lerp(destino, suavizado * delta)
	# Medida (bórrenla al terminar):
	if Engine.get_physics_frames() % 30 == 0:
		print("cámara ", global_position.snappedf(0.01))
