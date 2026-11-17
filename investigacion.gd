extends Node2D

func _ready() -> void:
	var boton = get_node_or_null("CanvasLayer/BotonVolver")
	if boton:
		boton.pressed.connect(Estado.terminar_investigacion)
	else:
		push_warning("Falta CanvasLayer/BotonVolver en esta escena")
