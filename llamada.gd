extends Node

enum Estado { HABLA, CUELGA }

@export var ritmo = 2.0
@export var lineas: Array[String] = [
	"Línea 1", "Línea 2", "Línea 3", "Línea 4", "Línea 5", "Línea 6"]

var estado = Estado.HABLA
var indice = 0
var reloj = 0.0

func _ready():
	decir()

func _physics_process(delta):
	reloj -= delta
	var nuevo = decidir()
	if nuevo != estado:
		estado = nuevo
		print(name, " -> ", Estado.keys()[estado])
	match estado:
		Estado.HABLA:
			if reloj <= 0:
				decir()
		Estado.CUELGA:
			pass

func decidir():
	if indice >= lineas.size() and reloj <= 0.001:
		return Estado.CUELGA
	return estado

func decir():
	print("cuadro ", Engine.get_physics_frames(), ": ", lineas[indice])
	indice += 1
	reloj = ritmo
