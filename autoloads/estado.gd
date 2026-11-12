extends Node

signal musica_cambio(nombre)

var noche = 1
var diario: Array[String] = []
var credibilidad = 3
var lugares = {}
var tutorial_visto = false


const ORDEN = {
	1: ["ernesto", "rosa", "gaspar"],
	2: ["marta", "hortensia", "nino", "voz", "grabada"],
}

func siguiente_noche():
	noche += 1

func sumar_credibilidad(n):
	credibilidad += n

func marcar_lugar(id, peligroso = false):
	lugares[id] = peligroso

func cambiar_musica(nombre):
	musica_cambio.emit(nombre)

func guardar_palabra(palabra: String):
	if palabra not in diario:
		diario.append(palabra)

func tiene_palabra(palabra: String) -> bool:
	return palabra in diario
