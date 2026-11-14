class_name SistemaEventos
extends Node
@export var luz_variable: OmniLight3D
@export var color_bajo := Color("C2413B")
@export var color_alto := Color("E39B3B")
@export var k_variable := 4.0
@export var luz_evento: OmniLight3D
@export var pico_destello := 4.0
@export var k_destello := 6.0 # 1/s: qué tan rápido se apaga

var variable := 1.0 # PA / 3: empieza con 3 PA

func _ready() -> void:
	for d in get_tree().get_nodes_in_group("disparadores"):
		d.evento.connect(_on_evento) # la función que escucha, sin paréntesis
	luz_evento.light_energy = 0.0
	
func _process(delta: float) -> void:
	luz_evento.light_energy = decaer(luz_evento.light_energy, 0.0,
		k_destello, delta)
	#print(snappedf(luz_evento.light_energy, 0.001))
	if Input.is_key_pressed(KEY_UP):
		variable = minf(1.0, variable + delta * 0.5)
	if Input.is_key_pressed(KEY_DOWN):
		variable = maxf(0.0, variable - delta * 0.5)
	if luz_variable != null:
		var v := clampf(variable, 0.0, 1.0)
		luz_variable.light_color = color_bajo.lerp(color_alto, v)
		var deseada := 1.0 + 3.0 * v
		luz_variable.light_energy = decaer(luz_variable.light_energy, deseada, k_variable, delta)
	print(snappedf(luz_variable.light_energy, 0.001))
		
func _on_evento(posicion: Vector3) -> void:
	luz_evento.global_position = posicion + Vector3.UP * 1.5
	luz_evento.light_energy = pico_destello
	
static func decaer(actual: float, base: float, k: float, dt: float) -> float:
	var alpha := 1.0 - exp(-k * dt)
	return actual + (base - actual) * alpha
