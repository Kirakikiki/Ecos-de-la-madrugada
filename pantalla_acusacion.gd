extends Control

# Paleta extraida de los assets del juego
const C_AMBAR       := Color("c8933a")
const C_AMBAR_CLARO := Color("e8b86a")
const C_AMBAR_OSCURO:= Color("5a3a0a")
const C_FONDO_CARD  := Color("0c0a06")
const C_BORDE_CARD  := Color("3a2a10")
const C_FOTO_MARCO  := Color("cfc0a0")
const C_ROJO        := Color("6e1212")
const C_ROJO_HOVER  := Color("941e1e")
const C_TEXTO       := Color("d4c8a0")
const C_TENUE       := Color("6a5e42")
const C_LINEA       := Color("2a1e08")

const SOSPECHOSOS := [
	{
		"id":     "ernesto",
		"nombre": "Ernesto",
		"oficio": "Panadero · Plaza Mayor",
		"pistas": "",
		"imagen": "res://assets/sospechosos/ernesto.jpg"
	},
	{
		"id":     "gaspar",
		"nombre": "Gaspar",
		"oficio": "Farolero · Callejon Norte",
		"pistas": "",
		"imagen": "res://assets/sospechosos/gaspar.jpg"
	},
	{
		"id":     "hijo_marta",
		"nombre": "Hijo de Marta",
		"oficio": "Sospechoso · Casa Vieja",
		"pistas": "",
		"imagen": "res://assets/sospechosos/hijo_marta.jpg"
	}
]

var _confirmacion:      Control
var _lbl_confirmacion:  Label
var _pendiente_id:      String = ""
var _pendiente_nombre:  String = ""


func _ready() -> void:
	_build_ui()


# Construccion de la UI
func _build_ui() -> void:
	# Fondo de la cabina de radio
	if ResourceLoader.exists("res://assets/cabina/imagen de fondo.jpg"):
		var bg := TextureRect.new()
		bg.set_anchors_preset(Control.PRESET_FULL_RECT)
		bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		bg.texture = load("res://assets/cabina/imagen de fondo.jpg")
		add_child(bg)

	# Velo oscuro sobre el fondo
	var velo := ColorRect.new()
	velo.set_anchors_preset(Control.PRESET_FULL_RECT)
	velo.color = Color(0.03, 0.04, 0.07, 0.86)
	add_child(velo)

	# Titulo
	var titulo := Label.new()
	titulo.text = "¿A quien vas a acusar?"
	titulo.set_anchors_preset(Control.PRESET_TOP_WIDE)
	titulo.offset_top    =  5
	titulo.offset_bottom = 23
	titulo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	titulo.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	titulo.add_theme_color_override("font_color", C_AMBAR)
	titulo.add_theme_font_size_override("font_size", 12)
	add_child(titulo)

	# Linea bajo el titulo
	var sep_titulo := ColorRect.new()
	sep_titulo.set_anchors_preset(Control.PRESET_TOP_WIDE)
	sep_titulo.offset_top    = 23
	sep_titulo.offset_bottom = 24
	sep_titulo.offset_left   =  8
	sep_titulo.offset_right  = -8
	sep_titulo.color = C_AMBAR_OSCURO
	add_child(sep_titulo)

	# Fila de tarjetas
	var hbox := HBoxContainer.new()
	hbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	hbox.offset_top    =  26
	hbox.offset_bottom =  -4
	hbox.offset_left   =   5
	hbox.offset_right  =  -5
	hbox.add_theme_constant_override("separation", 4)
	add_child(hbox)

	for datos in SOSPECHOSOS:
		hbox.add_child(_make_card(datos))

	# Modal de confirmacion (oculto al inicio)
	_confirmacion = _make_confirmation()
	_confirmacion.hide()
	add_child(_confirmacion)


# Tarjeta individual de sospechoso
func _make_card(data: Dictionary) -> Panel:
	var card := Panel.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var sbox := StyleBoxFlat.new()
	sbox.bg_color = C_FONDO_CARD
	sbox.border_color = C_BORDE_CARD
	sbox.set_border_width_all(1)
	sbox.border_width_top = 2
	card.add_theme_stylebox_override("panel", sbox)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.offset_left   =  4
	vbox.offset_right  = -4
	vbox.offset_top    =  4
	vbox.offset_bottom = -3
	vbox.add_theme_constant_override("separation", 2)
	card.add_child(vbox)

	# Foto con marco
	var foto_marco := ColorRect.new()
	foto_marco.color = C_FOTO_MARCO
	foto_marco.custom_minimum_size     = Vector2(0, 74)
	foto_marco.size_flags_horizontal   = Control.SIZE_EXPAND_FILL
	foto_marco.size_flags_vertical     = Control.SIZE_EXPAND_FILL
	vbox.add_child(foto_marco)

	var foto := TextureRect.new()
	foto.set_anchors_preset(Control.PRESET_FULL_RECT)
	foto.offset_left   =  2
	foto.offset_right  = -2
	foto.offset_top    =  2
	foto.offset_bottom = -3
	foto.expand_mode   = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	foto.stretch_mode  = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	if ResourceLoader.exists(data["imagen"]):
		foto.texture = load(data["imagen"])
	foto_marco.add_child(foto)

	# Nombre
	var nombre_lbl := Label.new()
	nombre_lbl.text = data["nombre"]
	nombre_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	nombre_lbl.add_theme_color_override("font_color", C_AMBAR_CLARO)
	nombre_lbl.add_theme_font_size_override("font_size", 9)
	vbox.add_child(nombre_lbl)

	# Oficio
	var oficio_lbl := Label.new()
	oficio_lbl.text = data["oficio"]
	oficio_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	oficio_lbl.add_theme_color_override("font_color", C_TENUE)
	oficio_lbl.add_theme_font_size_override("font_size", 7)
	oficio_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(oficio_lbl)

	# Separador
	var sep := ColorRect.new()
	sep.color = C_LINEA
	sep.custom_minimum_size = Vector2(0, 1)
	vbox.add_child(sep)

	# Pistas (Valentina llena el texto en SOSPECHOSOS)
	var pistas_lbl := Label.new()
	pistas_lbl.text = data["pistas"]
	pistas_lbl.size_flags_vertical  = Control.SIZE_EXPAND_FILL
	pistas_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	pistas_lbl.add_theme_color_override("font_color", C_TEXTO)
	pistas_lbl.add_theme_font_size_override("font_size", 7)
	pistas_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(pistas_lbl)

	# Boton ACUSAR
	var btn := Button.new()
	btn.text    = "🔨  ACUSAR"
	btn.focus_mode = Control.FOCUS_NONE
	btn.add_theme_color_override("font_color", C_AMBAR_CLARO)
	btn.add_theme_font_size_override("font_size", 8)

	var sn := StyleBoxFlat.new()
	sn.bg_color = C_ROJO
	sn.border_color = C_AMBAR_OSCURO
	sn.border_width_top = 1
	btn.add_theme_stylebox_override("normal",  sn)

	var sh := sn.duplicate() as StyleBoxFlat
	sh.bg_color = C_ROJO_HOVER
	btn.add_theme_stylebox_override("hover",   sh)
	btn.add_theme_stylebox_override("pressed", sh)

	btn.pressed.connect(_on_acusar.bind(data["id"], data["nombre"]))
	vbox.add_child(btn)

	return card


# Modal de confirmacion
func _make_confirmation() -> Control:
	# Velo oscuro detras del modal
	var overlay := ColorRect.new()
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.color = Color(0, 0, 0, 0.80)

	# Caja del modal
	var modal := Panel.new()
	modal.set_anchors_preset(Control.PRESET_CENTER)
	modal.offset_left   = -78
	modal.offset_right  =  78
	modal.offset_top    = -38
	modal.offset_bottom =  38

	var msb := StyleBoxFlat.new()
	msb.bg_color = Color("0d0a05")
	msb.border_color = C_AMBAR_OSCURO
	msb.set_border_width_all(1)
	msb.border_width_top = 2
	modal.add_theme_stylebox_override("panel", msb)
	overlay.add_child(modal)

	# Banda roja superior
	var header := ColorRect.new()
	header.color = C_ROJO
	header.set_anchors_preset(Control.PRESET_TOP_WIDE)
	header.offset_bottom = 11
	modal.add_child(header)

	var header_lbl := Label.new()
	header_lbl.text = "ACUSACION OFICIAL"
	header_lbl.set_anchors_preset(Control.PRESET_TOP_WIDE)
	header_lbl.offset_bottom = 11
	header_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header_lbl.vertical_alignment   = VERTICAL_ALIGNMENT_CENTER
	header_lbl.add_theme_color_override("font_color", C_AMBAR_CLARO)
	header_lbl.add_theme_font_size_override("font_size", 7)
	modal.add_child(header_lbl)

	# Contenido
	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.offset_top    = 13
	vbox.offset_left   = 10
	vbox.offset_right  = -10
	vbox.offset_bottom = -6
	vbox.alignment     = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 10)
	modal.add_child(vbox)

	_lbl_confirmacion = Label.new()
	_lbl_confirmacion.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_lbl_confirmacion.add_theme_color_override("font_color", C_TEXTO)
	_lbl_confirmacion.add_theme_font_size_override("font_size", 8)
	_lbl_confirmacion.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(_lbl_confirmacion)

	# Botones SI / NO
	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	hbox.add_theme_constant_override("separation", 14)
	vbox.add_child(hbox)

	var btn_si := Button.new()
	btn_si.text = "SI"
	btn_si.focus_mode = Control.FOCUS_NONE
	btn_si.custom_minimum_size = Vector2(38, 0)
	btn_si.add_theme_color_override("font_color", C_AMBAR_CLARO)
	btn_si.add_theme_font_size_override("font_size", 9)
	var ssi := StyleBoxFlat.new()
	ssi.bg_color = C_ROJO
	ssi.border_color = C_AMBAR_OSCURO
	ssi.border_width_top = 1
	btn_si.add_theme_stylebox_override("normal", ssi)
	var ssi_h := ssi.duplicate() as StyleBoxFlat
	ssi_h.bg_color = C_ROJO_HOVER
	btn_si.add_theme_stylebox_override("hover",   ssi_h)
	btn_si.add_theme_stylebox_override("pressed", ssi_h)
	btn_si.pressed.connect(_on_confirmar)
	hbox.add_child(btn_si)

	var btn_no := Button.new()
	btn_no.text = "NO"
	btn_no.focus_mode = Control.FOCUS_NONE
	btn_no.custom_minimum_size = Vector2(38, 0)
	btn_no.add_theme_color_override("font_color", C_TENUE)
	btn_no.add_theme_font_size_override("font_size", 9)
	var sno := StyleBoxFlat.new()
	sno.bg_color = Color("1a1510")
	sno.border_color = C_LINEA
	sno.border_width_top = 1
	btn_no.add_theme_stylebox_override("normal", sno)
	btn_no.pressed.connect(_on_volver)
	hbox.add_child(btn_no)

	return overlay


# Logica de interaccion
func _on_acusar(id: String, nombre: String) -> void:
	_pendiente_id     = id
	_pendiente_nombre = nombre
	_lbl_confirmacion.text = "¿Acusar a\n%s?" % nombre
	_confirmacion.show()


func _on_confirmar() -> void:
	Estado.culpar(_pendiente_id)


func _on_volver() -> void:
	_pendiente_id     = ""
	_pendiente_nombre = ""
	_confirmacion.hide()
