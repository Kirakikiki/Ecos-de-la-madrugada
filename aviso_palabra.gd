extends CanvasLayer

var pendientes: Array[String] = []
var agrupando = false
var tween: Tween

@onready var etiqueta = $Etiqueta

func _ready():
	layer = 120    # por encima del globo (100) y del diario (110)
	process_mode = Node.PROCESS_MODE_ALWAYS
	etiqueta.modulate.a = 0.0
	Estado.palabra_guardada.connect(_on_palabra)

func _on_palabra(palabra):
	pendientes.append(palabra)
	if agrupando:
		return
	# Espera un cuadro por si llegan varias palabras de la misma línea
	agrupando = true
	await get_tree().process_frame
	agrupando = false
	mostrar("Anotado: " + ", ".join(pendientes))
	pendientes.clear()

func mostrar(texto):
	etiqueta.text = texto
	if tween and tween.is_valid():
		tween.kill()
	tween = create_tween()
	tween.tween_property(etiqueta, "modulate:a", 1.0, 0.2)   # aparece
	tween.tween_interval(1.6)                                 # se queda
	tween.tween_property(etiqueta, "modulate:a", 0.0, 0.2)   # se desvanece
