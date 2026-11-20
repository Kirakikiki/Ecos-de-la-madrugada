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

@onready var grid: GridContainer = %Grid
@onready var hoja: VBoxContainer = %Hoja
@onready var titulo_pista: Label = %TituloPista
@onready var imagen: TextureRect = %Imagen
@onready var texto: Label = %Texto
@onready var anterior: Button = %Anterior
@onready var siguiente: Button = %Siguiente

var seleccionada = ""
var indice = 0

func _ready():
	layer = 110
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	anterior.pressed.connect(func(): _pasarHoja(-1))
	siguiente.pressed.connect(func(): _pasarHoja(1))
	Estado.palabra_guardada.connect(func(_p): if visible: actualizar())
	Estado.hallazgo_registrado.connect(func(_i): if visible: actualizar())
	
func _input(event):
	if event.is_action_pressed("diario"):
		get_viewport().set_input_as_handled()
		if visible: 
			cerrar()
		else :
			abrir()
	elif visible and event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		cerrar()
	elif visible and event.is_action_pressed("hoja_anterior"):
		get_viewport().set_input_as_handled()
		_pasarHoja(-1)
	elif visible and event.is_action_pressed("hoja_siguiente"):
		get_viewport().set_input_as_handled()
		_pasarHoja(1)

func abrir():
	if get_tree().paused:
		return
	#abrir en la ultima pista encontrada
	indice = maxi(Estado.hallazgos.size() -1, 0)
	actualizar()
	show()
	get_tree().paused = true
	enfocar()

func cerrar():
	hide()
	get_tree().paused = false

func enfocar():
	for slot in grid.get_children():
		if slot.has_method("estaVacio") and not slot.estaVacio():
			slot.grab_focus()
			return
	siguiente.grab_focus()

func actualizar():
	_llenarPalabra()
	_mostrarHoja(indice)

func _llenarPalabra():
	var claves : Array = Estado.diario
	var slots = grid.get_children()
	
	if claves.size() > slots.size():
		push_warning("Hay %d palabras y solo %d casillas." % [claves.size(), slots.size()])
	
	for i in slots.size():
		var slot = slots[i]
		if not slot.has_method("llenar"):
			push_warning("Un hijo del Grid no tiene llenar(): " + str(slot.name))
			continue
		if i < claves.size():
			slot.llenar(claves[i])
		else:
			slot.vaciar()



func _mostrarHoja(i : int):
	var total: int = Estado.hallazgos.size()
	if total == 0:
		titulo_pista.text = ""
		imagen.texture = null
		texto.text = "Aun no has examinado ninguna pista"
		anterior.disabled = true
		siguiente.disabled = true
		return
	
	indice = clampi(i, 0, total -1)
	var id = Estado.hallazgos[indice]
	var datos = Catalogo.PISTAS.get(id, {})
	
	titulo_pista.text = datos.get("titulo", "")
	var ruta: String = datos.get("imagen", "")
	imagen.texture = load(ruta) if ruta != "" and ResourceLoader.exists(ruta) else null
	texto.text = datos.get("texto", "")
	
	anterior.disabled = indice == 0
	siguiente.disabled = indice >= total -1

func _pasarHoja(direccion :int):
	var nuevo = indice + direccion
	if nuevo < 0 or nuevo >= Estado.hallazgos.size():
		return
	_mostrarHoja(nuevo)
	hoja.modulate.a = 0.0
	create_tween().tween_property(hoja, "modulate:a", 1.0, 0.2)
