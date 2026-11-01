extends Node

enum Estado {LISTA, ACTIVA, RECARGA}

@export var tecla = "silencio"
@export var duracion = 1.0
@export var recarga = 0.0
@onready var pj = get_parent()

var estado = Estado.LISTA
var tiempo = 0.0
var usada = false

func _physics_process(delta):
	tiempo -= delta
	match estado:
		Estado.LISTA:
			if Input.is_action_pressed(tecla) and puede():
				empezar()
		Estado.ACTIVA:
			if not Input.is_action_pressed(tecla):
				cortar()
			elif tiempo <= 0.001: # 0.001 y no 0: restar 1/60 no da exacto
				terminar()
		Estado.RECARGA:
			if tiempo <= 0.001:
				estado = Estado.LISTA
				
func puede():
	return pj.is_on_floor() #la regla del ejemplo: solo en el suelo
				
func nueva_llamada():
	pj.is_floor = false

func empezar():
	estado = Estado.ACTIVA
	tiempo = duracion
	pj.multiplicador = 0
	pj.accion = "emote-no"
	print("empieza: ", tecla)
	
func cortar():
	estado = Estado.LISTA
	pj.multiplicador = 1
	pj.accion = ""
	print("cortado: ", tecla)
	
func terminar():
	usada = true
	estado = Estado.RECARGA
	tiempo = recarga
	pj.multiplicador = 1
	pj.accion = ""
	print("termina: ", tecla)
