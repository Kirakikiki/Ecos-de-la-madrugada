extends Area2D

@export var palabra_requerida = ""    # la palabra que lo hace aparecer
@export var palabra_que_da = ""       # la palabra que guarda al examinarlo
@export_multiline var texto = ""

var cerca = false

func _ready():
	body_entered.connect(func(b): if b.is_in_group("jugador"): cerca = true)
	body_exited.connect(func(b): if b.is_in_group("jugador"): cerca = false)
	if palabra_requerida != "" and not Estado.tiene_palabra(palabra_requerida):
		hide()
		monitoring = false

func _unhandled_input(event):
	if cerca and event.is_action_pressed("interactuar"):
		print(texto)    # de momento solo en la Salida; luego irá al globo de diálogo
		if palabra_que_da != "":
			Estado.guardar_palabra(palabra_que_da)
