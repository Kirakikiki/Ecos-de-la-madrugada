
extends Node

signal musica_cambio(nombre)
signal estatica_cambio(intensidad)
signal llamada_cortada
signal juego_terminado(final)
signal pa_cambio(valor)

var noche = 1
var diario: Array[String] = []
var credibilidad = 0
var confianza_nino: int = 0
var pistas: Array = []
var lugares: Dictionary = {}
var autoridades_avisadas: bool = false
var marta_confrontada: bool = false
var tutorial_visto = false

const PA_MAXIMO = 3
var pa = PA_MAXIMO

# Reproductores de efectos de sonido
var reproductores_efectos: Dictionary = {}
var acusado_elegido: String = ""

const ORDEN = {
	1: ["ernesto", "rosa", "gaspar", "marta", "nino"],
	2: ["nino", "gaspar"],
	3: ["ernesto", "rosa", "marta"],
	4: ["nino", "gaspar"],
	5: ["marta", "nino"],
	6: ["final_marta", "final_nino"]
}


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

func culpar(sospechoso: String) -> void:
	var sospechosos_validos = ["ernesto", "gaspar", "hijo_marta"]
	
	if sospechoso not in sospechosos_validos:
		push_warning("Sospechoso no válido: " + sospechoso)
		return
		
	acusado_elegido = sospechoso
	print("El jugador ha culpado a: ", acusado_elegido)
	juego_terminado.emit(acusado_elegido)
	get_tree().change_scene_to_file("res://final_placeholder.tscn")

func terminar_investigacion():
	reiniciar_pa()
	siguiente_noche()
	get_tree().change_scene_to_file("res://radio.tscn")


# REPRODUCIR EFECTOS DE SONIDO

func reproducir_efecto(nombre: String, volumen_db: float = 0.0) -> void:
	var ruta := "res://audio/efectos_dialogos/" + nombre + ".mp3"

	if not ResourceLoader.exists(ruta):
		push_warning("No se encontró el efecto: " + ruta)
		return

	if not reproductores_efectos.has(nombre):
		var reproductor := AudioStreamPlayer.new()
		reproductor.name = "Efecto_" + nombre
		add_child(reproductor)
		reproductores_efectos[nombre] = reproductor

	var reproductor: AudioStreamPlayer = reproductores_efectos[nombre]

	reproductor.stream = load(ruta)
	reproductor.volume_db = volumen_db
	reproductor.play()


# DETENER UN EFECTO

func detener_efecto(nombre: String) -> void:
	if reproductores_efectos.has(nombre):
		var reproductor: AudioStreamPlayer = reproductores_efectos[nombre]
		reproductor.stop()


# DETENER TODOS LOS EFECTOS

func detener_todos_los_efectos() -> void:
	for nombre in reproductores_efectos:
		detener_efecto(nombre)
