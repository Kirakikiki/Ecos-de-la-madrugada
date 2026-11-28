extends Node2D

signal contestado
signal pensamiento_avanzado
signal caminata_ventana_terminada

const PENSAMIENTOS_NOCHE := {
	1: "¡Wow! Este caso es grande, conecta muchas cosas… ¡Vamos a averiguarlo!",
}
const VELOCIDAD_VENTANA := 54.0
const VELOCIDAD_ENTRADA_VENTANA := 68.0
const PASO_FRAME_VENTANA := 0.095
const TEX_LOCUTOR_DERECHA := preload("res://Personajes/Sprits/Aurelio/right.png")
const TEX_LOCUTOR_IZQUIERDA := preload("res://Personajes/Sprits/Aurelio/left.png")

var esperando = false
var mostrando_pensamiento = false
var caminando_ventana = false
var _direccion_ventana: int = 1
var _tiempo_paso_ventana = 0.0
var tutorial = load("res://dialogos/tutorial.dialogue")
var murmullos = load("res://dialogos/murmullos.dialogue")

func _ready():
	var viene_de_calle: bool = Estado.regresando_de_calle
	Estado.regresando_de_calle = false
	$Interfaz/NubePensamiento.hide()
	$LocutorVentana.hide()
	$Interfaz/BotonContestar.pressed.connect(contestar)
	$Interfaz/BotonContestar.hide()	
	$Timbre.stream = load("res://audio/sonido_llamada.mp3")
	Estado.musica_cambio.connect(_on_musica)
	Estado.estatica_cambio.connect(_on_estatica)
	Estado.llamada_cortada.connect(_on_llamada_cortada)
	if viene_de_calle:
		apagar_on_air()
		_secuencia_regreso_cabina()
	else:
		encender_on_air()
		Estado.cambiar_musica("calma")
		transmitir()

func _secuencia_regreso_cabina() -> void:
	# Esperar a que termine el fundido desde negro de "Noche X" para que se vea pasar por fuera
	await get_tree().create_timer(0.55).timeout
	iniciar_entrada_ventana()
	await caminata_ventana_terminada
	Estado.detener_efecto("pasos")
	await get_tree().create_timer(0.2).timeout
	Estado.reproducir_efecto("puerta", -11.0)
	await get_tree().create_timer(0.35).timeout
	encender_on_air()
	Estado.cambiar_musica("calma")
	await get_tree().create_timer(0.4).timeout
	transmitir()

func _process(delta: float) -> void:
	if not caminando_ventana:
		return
	var locutor: Sprite2D = $LocutorVentana
	var velocidad: float = VELOCIDAD_VENTANA if _direccion_ventana > 0 else VELOCIDAD_ENTRADA_VENTANA
	locutor.position.x += float(_direccion_ventana) * velocidad * delta
	_tiempo_paso_ventana += delta
	if _tiempo_paso_ventana >= PASO_FRAME_VENTANA:
		_tiempo_paso_ventana -= PASO_FRAME_VENTANA
		if _direccion_ventana > 0:
			locutor.frame = 1 + (locutor.frame % 10)
		else:
			locutor.frame = (locutor.frame + 1) % 10
	if (_direccion_ventana > 0 and locutor.position.x >= 268.0) or (_direccion_ventana < 0 and locutor.position.x <= 77.5):
		caminando_ventana = false
		locutor.hide()
		caminata_ventana_terminada.emit()

func _input(event: InputEvent) -> void:
	if not mostrando_pensamiento or get_tree().paused:
		return
	var avanzar: bool = false
	if event is InputEventKey:
		var ev_key: InputEventKey = event
		if ev_key.pressed and not ev_key.echo:
			var k: int = ev_key.keycode
			var pk: int = ev_key.physical_keycode
			avanzar = (k == KEY_E or pk == KEY_E or k == KEY_ENTER or k == KEY_KP_ENTER or k == KEY_SPACE or pk == KEY_SPACE)
	elif event is InputEventMouseButton:
		var ev_mouse: InputEventMouseButton = event
		avanzar = ev_mouse.pressed and ev_mouse.button_index == MOUSE_BUTTON_LEFT
	if avanzar:
		get_viewport().set_input_as_handled()
		pensamiento_avanzado.emit()

func _unhandled_input(event: InputEvent) -> void:
	if esperando and event.is_action_pressed("interactuar"):
		contestar()

func contestar():
	if not esperando:
		return
		
	esperando = false
	$Interfaz/BotonContestar.hide()
	$Timbre.stop()
	contestado.emit()

func esperar_llamada():
	$Timbre.play()
	# La primera vez, el locutor explica qué hacer
	if not Estado.tutorial_visto:
		Estado.tutorial_visto = true
		await get_tree().create_timer(1.5).timeout
		DialogueManager.show_dialogue_balloon(tutorial, "primer_timbre")
		await DialogueManager.dialogue_ended
	esperando = true
	$Interfaz/BotonContestar.show()
	await contestado

func murmullo():
	if randf() < 0.5:
		var titulos = ["murmullo_1", "murmullo_2", "murmullo_3"]
		DialogueManager.show_dialogue_balloon(murmullos, titulos.pick_random())
		await DialogueManager.dialogue_ended
	await get_tree().create_timer(2.0).timeout

func transmitir():
	var recurso = load("res://dialogos/noche_%d.dialogue" % Estado.noche)
	for oyente in Estado.ORDEN[Estado.noche]:
		await murmullo()
		await esperar_llamada()
		DialogueManager.show_dialogue_balloon(recurso, "llamada_" + oyente)
		await DialogueManager.dialogue_ended
	await terminar_noche()

func encender_on_air() -> void:
	$Aviso.modulate = Color.WHITE
	$Aviso.play("Aviso")
	$LedRojo1.encender()

func apagar_on_air() -> void:
	$Aviso.stop()
	$Aviso.frame = 0
	$Aviso.modulate = Color(0.55, 0.75, 0.75, 1.0)
	$LedRojo1.apagar()

func mostrar_pensamiento_noche() -> void:
	var mensaje: String = PENSAMIENTOS_NOCHE.get(Estado.noche, "")
	if mensaje == "":
		await get_tree().create_timer(0.5).timeout
		return

	var nube: Control = $Interfaz/NubePensamiento
	var etiqueta: Label = $Interfaz/NubePensamiento/Texto
	etiqueta.text = mensaje
	nube.modulate.a = 0.0
	nube.scale = Vector2(0.88, 0.88)
	nube.show()

	var t := create_tween().set_parallel(true)
	t.tween_property(nube, "modulate:a", 1.0, 0.3)
	t.tween_property(nube, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await t.finished

	await get_tree().create_timer(0.3).timeout
	mostrando_pensamiento = true
	await pensamiento_avanzado
	mostrando_pensamiento = false

	# Desvanecimiento suave y más pausado de la nube al pulsar tecla o clic
	var t_salida := create_tween()
	t_salida.tween_property(nube, "modulate:a", 0.0, 0.9).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	t_salida.tween_callback(nube.hide)

func iniciar_caminata_ventana() -> void:
	var locutor: Sprite2D = $LocutorVentana
	_direccion_ventana = 1
	locutor.texture = TEX_LOCUTOR_DERECHA
	locutor.position = Vector2(77.5, 53.6)
	locutor.frame = 1
	_tiempo_paso_ventana = 0.0
	locutor.show()
	caminando_ventana = true
	Estado.reproducir_efecto("pasos", -11.0)

func iniciar_entrada_ventana() -> void:
	var locutor: Sprite2D = $LocutorVentana
	_direccion_ventana = -1
	locutor.texture = TEX_LOCUTOR_IZQUIERDA
	locutor.position = Vector2(262.0, 53.6)
	locutor.frame = 0
	_tiempo_paso_ventana = 0.0
	locutor.show()
	caminando_ventana = true
	Estado.reproducir_efecto("pasos", -11.0)

func terminar_noche():
	apagar_on_air()
	Estado.detener_efecto("estatica")
	$Timbre.stop()
	$Musica.stop()
	Estado.reproducir_efecto("apagado", -8.0)

	# Justo al apagarse el ON AIR aparece la nubecita y espera clic o cualquier tecla
	await mostrar_pensamiento_noche()
	
	if Estado.noche >= 6:
		await get_tree().create_timer(0.9).timeout
		Transicion.cambiar_escena("res://pantalla_acusacion.tscn", "", 1.5)
	else:
		# Mientras la nube se desvanece, el locutor pasa caminando tras la ventana de la Mona Lisa
		iniciar_caminata_ventana()
		await get_tree().create_timer(1.3).timeout
		Estado.ir_a_exploracion(1.6)
	
func _on_estatica(intensidad: float) -> void:
	Estado.reproducir_efecto("estatica", intensidad)
	
func _on_llamada_cortada() -> void:
	$Timbre.stop()
	Estado.detener_efecto("estatica")
	
# Aquí: pasar a la investigación, y luego Estado.siguiente_noche()
func _on_musica(nombre: String) -> void:
	var ruta := ""
	
	match nombre:
		"calma":
			ruta = "res://audio/calma.mp3"
			
		"tension":
			ruta = "res://audio/tension.mp3"
			
		_: 
			push_warning("No existe una música para: " + nombre)
			return
			
	var audio = load(ruta)
	if audio == null:
		push_error("No se pudo cargar el audio: " + ruta)
		return
	
	$Musica.stream = audio
	$Musica.play()
	
