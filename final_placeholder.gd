extends Control

func _ready() -> void:
	_construir_ui()

func _construir_ui() -> void:
	var fondo := ColorRect.new()
	fondo.set_anchors_preset(Control.PRESET_FULL_RECT)
	fondo.color = Color("0d1220")
	add_child(fondo)

	var acusado: String = Estado.acusado_elegido
	var nombres := {"ernesto": "Ernesto", "gaspar": "Gaspar", "hijo_marta": "El Hijo de Marta"}
	var nombre_elegido: String = nombres.get(acusado, "???")

	var label := Label.new()
	label.text = "Acusaste a:\n%s\n\nAqui debe conectarse con las pantallas de final" % nombre_elegido
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.add_theme_color_override("font_color", Color("e8d8b0"))
	add_child(label)
