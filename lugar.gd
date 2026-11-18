extends Node2D

@export_file("*.tscn") var escena_calle = "res://escenas/calle.tscn"

var cerca_de_salida = false

func _ready():
	$Salida.body_entered.connect(_on_entra)
	$Salida.body_exited.connect(_on_sale)
	$Salida/Aviso.hide()

func _on_entra(body):
	if body.is_in_group("jugador"):
		cerca_de_salida = true
		$Salida/Aviso.show()

func _on_sale(body):
	if body.is_in_group("jugador"):
		cerca_de_salida = false
		$Salida/Aviso.hide()

func _unhandled_input(event):
	if cerca_de_salida and event.is_action_pressed("interactuar"):
		salir()

func salir():
	if Estado.pa <= 0:
		Estado.terminar_investigacion()
	else:
		get_tree().change_scene_to_file(escena_calle)
