extends Node

signal musica_cambio(nombre)
signal estatica_cambio(intensidad)
signal llamada_cortada
signal juego_terminado(final)
signal pa_cambio(valor)

const ESCENA_CABINA = "res://radio.tscn"        
const ESCENA_EXPLORACION = "res://calle.tscn"  
const PA_MAXIMO = 3

const ORDEN = {
	1: ["ernesto", "rosa", "gaspar", "marta", "nino"],
	2: ["nino", "gaspar"],
	3: ["ernesto", "rosa", "marta"],
	4: ["nino", "gaspar"],
	5: ["marta", "nino"],
	6: ["final_marta", "final_nino"]
}

var noche = 1
var diario: Array[String] = []
var credibilidad = 0
var confianza_nino: int = 0
var pistas: Array = []
var lugares: Dictionary = {}
var autoridades_avisadas: bool = false
var marta_confrontada: bool = false
var tutorial_visto = false
var pa = PA_MAXIMO


func ir_a_cabina():
	get_tree().change_scene_to_file(ESCENA_CABINA)

func ir_a_exploracion():
	get_tree().change_scene_to_file(ESCENA_EXPLORACION)

func terminar_investigacion():
	reiniciar_pa()
	siguiente_noche()
	ir_a_cabina()
	

func gastar_pa(n):
	pa -= n
	pa_cambio.emit(pa)

func reiniciar_pa():
	pa = PA_MAXIMO
	pa_cambio.emit(pa)



func siguiente_noche():
	noche += 1

func sumar_credibilidad(n):
	credibilidad += n
	
func cambiar_credibilidad(n):
	sumar_credibilidad(n)

func cambiar_confianza_nino(n: int):
	confianza_nino += n
	
	
	
func agregar_pista(id: String):
	if id not in pistas:
		pistas.append(id)
		
func guardar_palabra(palabra: String):
	if palabra not in diario:
		diario.append(palabra)

func tiene_palabra(palabra: String) -> bool:
	return palabra in diario
	
func marcar_lugar(id, peligroso = false):
	if peligroso is String:
		peligroso = (peligroso == "peligroso")
	lugares[id] = peligroso
	
	
# Una sola pregunta para puertas y objetos:
func desbloqueado(id: String) -> bool:
	return id in diario or id in pistas or lugares.has(id)
	
	
#eventos para la historia 
func avisar_autoridades():
	autoridades_avisadas = true

func cambiar_musica(nombre):
	musica_cambio.emit(nombre)
	
func estatica(intensidad: float):
	estatica_cambio.emit(intensidad)

func cortar_llamada():
	llamada_cortada.emit()
	
func terminar_juego(final: String):
	juego_terminado.emit(final)
