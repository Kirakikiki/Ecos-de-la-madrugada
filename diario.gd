extends CanvasLayer

# Lo que se lee al elegir una palabra. Agrega las de cada noche.
const NOTAS = {
	"panes": "Ernesto hornea cuarenta panes que nadie compra. Cada mañana desaparecen.",
	"campanas": "Ernesto oye campanas a las seis. Dice que será el viento.",
	"luz": "La noche del apagón no solo se fue la luz.",
	"gente": "También desapareció gente, y nadie preguntó.",
	"farolas": "Una farola de la calle de las Farolas, la número 7, se apagó primero.",
	"mano": "Gaspar vio a alguien bajo la farola 7 con una mano levantada.",
}

@onready var pestanas = $Panel/VBox/Pestanas
@onready var lista = $Panel/VBox/Pestanas/Palabras/Lista
@onready var nota = $Panel/VBox/Pestanas/Palabras/Nota
@onready var lista_pistas = $Panel/VBox/Pestanas/Pistas/ListaPistas
@onready var imagen_pista = $Panel/VBox/Pestanas/Pistas/Detalle/Imagen
@onready var texto_pista = $Panel/VBox/Pestanas/Pistas/Detalle/Texto

func _ready():
	layer = 110
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	lista.item_selected.connect(_on_palabra)
	lista_pistas.item_selected.connect(_on_pista)
	pestanas.tab_changed.connect(func(_i): enfocar())
	Estado.palabra_guardada.connect(func(_p): if visible: actualizar())
	Estado.hallazgo_registrado.connect(func(_i): if visible: actualizar())

func _input(event):
	if event.is_action_pressed("diario"):
		get_viewport().set_input_as_handled()
		if visible:
			cerrar()
		else:
			abrir()
	elif visible and event.is_action_pressed("move_left"):
		get_viewport().set_input_as_handled()
		pestanas.current_tab = maxi(pestanas.current_tab - 1, 0)
	elif visible and event.is_action_pressed("move_right"):
		get_viewport().set_input_as_handled()
		pestanas.current_tab = mini(pestanas.current_tab + 1, pestanas.get_tab_count() - 1)

func abrir():
	if get_tree().paused:
		return    # no abre si otra cosa ya pausó el juego (por ejemplo el visor)
	actualizar()
	show()
	get_tree().paused = true
	enfocar()

func cerrar():
	hide()
	get_tree().paused = false

func enfocar():
	if pestanas.current_tab == 0:
		lista.grab_focus()
	else:
		lista_pistas.grab_focus()

func actualizar():
	lista.clear()
	for palabra in Estado.diario:
		lista.add_item(palabra)
	if Estado.diario.is_empty():
		nota.text = "Todavía no has anotado nada."
	else:
		lista.select(0)
		_on_palabra(0)
		
	lista_pistas.clear()
	for id in Estado.hallazgos:
		var datos = Catalogo.PISTAS.get(id)
		if datos:
			lista_pistas.add_item(datos["titulo"])
			lista_pistas.set_item_metadata(lista_pistas.item_count - 1, id)
	if lista_pistas.item_count == 0:
		imagen_pista.texture = null
		texto_pista.text = "Aún no has examinado ninguna pista."
	else:
		lista_pistas.select(0)
		_on_pista(0)
		
func _on_palabra(i):
	nota.text = NOTAS.get(lista.get_item_text(i), "Sin nota todavía.")

func _on_pista(i):
	var id = lista_pistas.get_item_metadata(i)
	var datos = Catalogo.PISTAS[id]
	imagen_pista.texture = load(datos["imagen"])
	texto_pista.text = datos["texto"]
