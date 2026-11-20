extends Area2D

@export var id = "canasta_pan"    # debe coincidir con una clave de Catalogo.PISTAS

var cerca = false

func _ready():
	body_entered.connect(_on_entra)
	body_exited.connect(_on_sale)

	var datos = Catalogo.PISTAS.get(id)
	if datos == null:
		push_warning("Pista sin datos en el catálogo: " + id)
		hide()
		monitoring = false
		return

	# Solo aparece si el jugador tiene alguna de las palabras o pistas requeridas
	if not Estado.desbloqueado_alguno(datos["requisitos"]):
		hide()
		monitoring = false
		return

	# Si ya la examinó, el brillo se apaga
	if Estado.tiene_hallazgo(id):
		$Brillo.hide()

func _on_entra(body):
	if body.is_in_group("jugador"):
		cerca = true

func _on_sale(body):
	if body.is_in_group("jugador"):
		cerca = false

func _unhandled_input(event):
	if cerca and event.is_action_pressed("interactuar"):
		get_viewport().set_input_as_handled()
		
		var esNueva = not Estado.tiene_hallazgo(id)
		
		# 1 pista nueva cuesta 1PA; las que ya estan examindas no cuestan
		if esNueva:
			if not Estado.tiene_pa(1):
				print("Sin puntos de acción")
				return
			Estado.gastar_pa(1)
			Estado.registrar_hallazgo(id)
		
		$Brillo.hide()
		
		print("Pista: E pulsada en ", id)
		var visor = get_tree().get_first_node_in_group("visor")
		if visor:
			visor.mostrar(id)
			# espera a que el juagador cierre la tarjeta
			if esNueva and Estado.pa <= 0:
				await visor.cerrado
				Estado.terminar_investigacion()
		elif esNueva and Estado.pa <= 0:
			Estado.terminar_investigacion()
		
		
		
