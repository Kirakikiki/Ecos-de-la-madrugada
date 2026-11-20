extends CanvasLayer

@onready var imagen = $Centro/VBox/Imagen
@onready var titulo = $Centro/VBox/Titulo
@onready var texto = $Centro/VBox/Texto

func _ready():
	layer = 80    # por debajo del diario (110) y del aviso de palabras (120)
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()

func mostrar(id: String):
	var datos = Catalogo.PISTAS.get(id)
	if datos == null:
		push_warning("Pista sin datos: " + id)
		return
	titulo.text = datos["titulo"]
	texto.text = datos["texto"]
	imagen.texture = load(datos["imagen"])
	Estado.registrar_hallazgo(id)

	$Centro.modulate.a = 0.0
	show()
	get_tree().paused = true
	create_tween().tween_property($Centro, "modulate:a", 1.0, 0.25)

func _unhandled_input(event):
	if visible and (event.is_action_pressed("interactuar") or event.is_action_pressed("ui_cancel")):
		get_viewport().set_input_as_handled()
		hide()
		get_tree().paused = false
