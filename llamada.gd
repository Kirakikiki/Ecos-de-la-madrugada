extends Node

enum Estado { HABLA, CALLADO, CONFIESA, CUELGA }

@export var ritmo = 2.0
@export var tecla = "silencio"
@export var tiempo_silencio = 1.0
@export var oculta_algo = true
@export var lineas: Array[String] = [
	"Línea 1", "Línea 2", "Línea 3", "Línea 4", "Línea 5", "Línea 6"]
@export var confesion: Array[String] = [
	"Secreto 1", "Secreto 2", "Secreto 3"]
	
var estado = Estado.HABLA
var indice = 0
var reloj = 0.0
var silencio = 0.0
var usado = false
var resaltables = 0

func _ready():
	decir()

func _physics_process(delta):
	reloj -= delta
	var nuevo = decidir()
	if nuevo != estado:
		estado = nuevo
		print(name, " -> ", Estado.keys()[estado], " cuadro ",
			Engine.get_physics_frames())
	match estado:
		Estado.HABLA:
			if reloj <= 0.001:
				decir()
		Estado.CALLADO:
			silencio += delta
			if silencio >= tiempo_silencio - 0.001:
				reaccionar()
		Estado.CONFIESA:
			if reloj <= 0.001 and indice < lineas.size():
				decir()
		Estado.CUELGA:
			pass

func decidir():
	if estado == Estado.CUELGA or estado == Estado.CONFIESA:
		if indice >= lineas.size() and reloj <= 0.001:
			return Estado.CUELGA
		return estado
	if indice >= lineas.size() and reloj <= 0.001:
		return Estado.CUELGA
	if Input.is_action_pressed(tecla) and not usado:
		return Estado.CALLADO
	return Estado.HABLA

func reaccionar():
	usado = true
	if oculta_algo:
		lineas.append_array(confesion)
		resaltables += 1
		estado = Estado.CONFIESA
		print(name, " se quiebra: +", confesion.size(),
			" líneas y +1 palabra")
		reloj = 0.0
	else:
		estado = Estado.CUELGA
		print(name, " cuelga")
		
func decir():
	print("cuadro ", Engine.get_physics_frames(), ": ", lineas[indice])
	indice += 1
	reloj = ritmo
