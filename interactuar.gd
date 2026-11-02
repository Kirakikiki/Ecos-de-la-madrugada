extends Node

@export var tecla = "interactuar"
@export var alcance = 1.5
@export var tiempo_necesario = 1.5
@export var intentos_max = 2 
@onready var pj = get_parent()

var progreso = 0.0
var actual = null
var intentos_usados = 0

func _physics_process(delta):
	var obj = mas_cercano()
	if not Input.is_action_pressed(tecla) or obj == null:
		progreso = 0.0
		actual = null
		return
	if obj != actual:
		actual = obj
		progreso = 0.0	
	var antes = progreso
	progreso += delta / tiempo_necesario
	if int(progreso * 4) > int (antes * 4) and progreso < 0.999:		
		print(obj.name, ": ", int(progreso * 4) * 25, " %")
	if progreso >= 0.999:
		print("completado: ", obj.name)
		if intentos_usados < intentos_max:
			if obj.has_method("usar"):
				obj.usar()
			intentos_usados += 1
		else:
			print("sin intentos")
		progreso = 0.0
			
func  mas_cercano():
	var mejor = null
	for obj in get_tree().get_nodes_in_group("interactivos"):
		var d = distancia_a(obj)
		if d <= alcance and (mejor == null or d < distancia_a(mejor)):
			mejor = obj
	return mejor 
	
func distancia_a(obj):
	var a = Vector2(pj.global_position.x, pj.global_position.z)
	var b = Vector2(obj.global_position.x, obj.global_position.z)
	return a.distance_to(b)

func nueva_visita():
	intentos_usados = 0
