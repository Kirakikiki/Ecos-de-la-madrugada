
extends Node

signal musica_cambio(nombre)
signal estatica_cambio(intensidad)
signal llamada_cortada
signal juego_terminado(final)
signal pa_cambio(valor)
signal palabra_guardada(palabra)
signal hallazgo_registrado(id)

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
var hallazgos: Array[String] = []    # pistas ya examinadas en la calle

# Reproductores de efectos de sonido
var reproductores_efectos: Dictionary = {}
var acusado_elegido: String = ""

# 
func registrar_hallazgo(id: String):
	if id not in hallazgos:
		hallazgos.append(id)
		hallazgo_registrado.emit(id)

func tiene_hallazgo(id: String) -> bool:
	return id in hallazgos
	
#Cambio de escena 
func ir_a_cabina():
	detener_todos_los_efectos()
	get_tree().change_scene_to_file(ESCENA_CABINA)

func ir_a_exploracion():
	detener_todos_los_efectos()
	get_tree().change_scene_to_file(ESCENA_EXPLORACION)

func terminar_investigacion():
	reiniciar_pa()
	siguiente_noche()
	ir_a_cabina()

#Puntos de accion
func tiene_pa(n: int = 1) -> bool:
	return n > 0 and pa >= n

func gastar_pa(n: int = 1) -> bool:
	if not tiene_pa(n):
		return false

	pa -= n
	print("PA restantes: ", pa)
	pa_cambio.emit(pa)
	return true

func reiniciar_pa():
	pa = PA_MAXIMO
	pa_cambio.emit(pa)


#aqui esta la noche 
func siguiente_noche():
	noche += 1

#aqui esta la credibilidad 
func sumar_credibilidad(n):
	credibilidad += n

func cambiar_credibilidad(n):
	sumar_credibilidad(n)

#aqui esta la confianza 
func cambiar_confianza_nino(n: int):
	confianza_nino += n

#
func agregar_pista(id: String):
	if id not in pistas:
		pistas.append(id)
		
func guardar_palabra(palabra: String):
	if palabra not in diario:
		diario.append(palabra)
		palabra_guardada.emit(palabra)

func tiene_palabra(palabra: String) -> bool:
	return palabra in diario
func marcar_lugar(id, peligroso = false):
	if peligroso is String:
		peligroso = (peligroso == "peligroso")
	lugares[id] = peligroso
	

# Una sola pregunta para puertas y objetos:
func desbloqueado(id: String) -> bool:
	return id in diario or id in pistas or lugares.has(id)

#verdadero si cumple uno de los requisitos de la lista
func desbloqueado_alguno(lista: Array) -> bool:
	for r in lista:
		if desbloqueado(r):
			return true
	return false

#eventos de la historia 
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

func culpar(sospechoso: String) -> void:
	var sospechosos_validos = ["ernesto", "gaspar", "hijo_marta"]

	if sospechoso not in sospechosos_validos:
		push_warning("Sospechoso no válido: " + sospechoso)
		return

	acusado_elegido = sospechoso
	print("El jugador ha culpado a: ", acusado_elegido)
	juego_terminado.emit(acusado_elegido)
	get_tree().change_scene_to_file("res://final_placeholder.tscn")

# REPRODUCIR EFECTOS DE SONIDO
func reproducir_efecto(nombre: String, volumen_db: float = 0.0) -> void:
	var ruta := "res://audio/efectos_dialogos/" + nombre + ".mp3"
	if not ResourceLoader.exists(ruta):
		push_warning("No se encontró el efecto: " + ruta)
		return

	var reproductor: AudioStreamPlayer

	if not reproductores_efectos.has(nombre):
		reproductor = AudioStreamPlayer.new()
		reproductor.name = "Efecto_" + nombre
		add_child(reproductor)
		reproductores_efectos[nombre] = reproductor
	else:
		reproductor = reproductores_efectos[nombre]
		
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
