extends Area2D

@export_file("*.tscn") var destino = ""
@export var peligroso = false
@export var palabra_requerida = "" 

var jugador_cerca = false

func _ready():
	body_entered.connect(_on_entra)
	body_exited.connect(_on_sale)
	if palabra_requerida != "" and not Estado.tiene_palabra(palabra_requerida):
		hide()
		monitoring = false

func _on_entra(body):
	if body.is_in_group("jugador"):
		jugador_cerca = true
		$Aviso.show()

func _on_sale(body):
	if body.is_in_group("jugador"):
		jugador_cerca = false
		$Aviso.hide()

func _unhandled_input(event):
	if jugador_cerca and event.is_action_pressed("interactuar"):
		var costo = 2 if peligroso else 1
		if Estado.pa >= costo:
			Estado.gastar_pa(costo)
			get_tree().change_scene_to_file(destino)
