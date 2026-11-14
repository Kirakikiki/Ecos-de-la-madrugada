extends Node

signal musica_cambio(nombre)
signal estatica_cambio(intensidad)
signal llamada_cortada
signal juego_terminado(final)

var noche = 1
var diario: Array[String] = []
var credibilidad = 0
var confianza_nino: int = 0
var pistas: Array = []
var lugares: Dictionary = {}
var autoridades_avisadas: bool = false
var marta_confrontada: bool = false
var tutorial_visto = false


const ORDEN = {
	1: ["ernesto", "rosa", "gaspar", "marta", "nino"],
	2: ["nino", "gaspar"],
	3: ["ernesto", "rosa", "marta"],
	4: ["nino", "gaspar"],
	5: ["marta", "nino"],
	6: ["final_marta", "final_nino"]
}

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

func marcar_lugar(id, peligroso = false):
	if peligroso is String:
		peligroso = (peligroso == "peligroso")
	lugares[id] = peligroso
	
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

func guardar_palabra(palabra: String):
	if palabra not in diario:
		diario.append(palabra)

func tiene_palabra(palabra: String) -> bool:
	return palabra in diario

func terminar_investigacion():
	siguiente_noche()
	get_tree().change_scene_to_file("res://radio.tscn") 
