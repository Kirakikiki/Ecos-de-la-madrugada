extends CanvasLayer

@onready var imagen = $Centro/VBox/Imagen
@onready var titulo = $Centro/VBox/Titulo
@onready var texto = $Centro/VBox/Texto

func _ready():
	layer = 80
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func mostrar(id: String):
	print("Visor: abriendo ", id)
	var datos = Catalogo.PISTAS.get(id)
	if datos == null:
		push_warning("Pista sin datos en Catalogo: " + id)
		return

	titulo.text = datos["titulo"]
	texto.text = datos["texto"]

	var ruta = datos["imagen"]
	if ruta != "" and ResourceLoader.exists(ruta):
		imagen.texture = load(ruta)
	else:
		imagen.texture = null
		push_warning("Falta la imagen de '%s': %s" % [id, ruta])

	$Centro.modulate.a = 0.0
	show()
	get_tree().paused = true
	create_tween().tween_property($Centro, "modulate:a", 1.0, 0.25)

	if Estado.has_method("registrar_hallazgo"):
		Estado.registrar_hallazgo(id)
	else:
		push_warning("Estado no tiene registrar_hallazgo()")

func _unhandled_input(event):
	if visible and (event.is_action_pressed("interactuar") or event.is_action_pressed("ui_cancel")):
		get_viewport().set_input_as_handled()
		hide()
		get_tree().paused = false
