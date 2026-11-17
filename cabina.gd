extends Node2D

signal contestado

var esperando = false
var tutorial = load("res://dialogos/tutorial.dialogue")
var murmullos = load("res://dialogos/murmullos.dialogue")

func _ready():
	$Interfaz/BotonContestar.pressed.connect(contestar)
	$Interfaz/BotonContestar.hide()
	Estado.musica_cambio.connect(_on_musica)
	transmitir()

func _unhandled_input(event):
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
	print("Fin de la transmisión")
	await terminar_noche(recurso)
	
func terminar_noche(recurso):
	if Estado.noche >= 6:
		DialogueManager.show_dialogue_balloon(recurso, "resolver_final")
		await DialogueManager.dialogue_ended
		return
	get_tree().change_scene_to_file("res://investigacion.tscn")
	
# Aquí: pasar a la investigación, y luego Estado.siguiente_noche()
	
func _on_musica(nombre):
	$Musica.stream = load("res://audio/%s.ogg" % nombre)
	$Musica.play()
	
