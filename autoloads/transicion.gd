extends CanvasLayer

# Autoload: Transicion
# Fundido a negro al cambiar de escena.

const DURACION := 0.6        # segundos del fundido (entrada y salida)
const TEXTO_PAUSA := 0.3     # tiempo que se queda en negro

var _rect: ColorRect
var _label: Label
var _ocupado := false


func _ready() -> void:
	layer = 100                                  # por encima de todo
	process_mode = Node.PROCESS_MODE_ALWAYS

	_rect = ColorRect.new()
	_rect.color = Color.BLACK
	_rect.modulate.a = 0.0
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_rect)

	_label = Label.new()
	_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_size_override("font_size", 32)
	_rect.add_child(_label)


# texto: mensaje opcional mientras la pantalla esta en negro
func cambiar_escena(ruta: String, texto: String = "", duracion: float = DURACION) -> void:
	if _ocupado:
		return
	_ocupado = true

	_label.text = texto
	_rect.mouse_filter = Control.MOUSE_FILTER_STOP   # bloquea clics durante el fundido

	# Fundido a negro
	var t := create_tween()
	t.tween_property(_rect, "modulate:a", 1.0, duracion)
	await t.finished

	Estado.detener_todos_los_efectos()
	get_tree().change_scene_to_file(ruta)
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().create_timer(TEXTO_PAUSA).timeout

	# Fundido de vuelta
	var t2 := create_tween()
	t2.tween_property(_rect, "modulate:a", 0.0, DURACION)
	await t2.finished

	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label.text = ""
	_ocupado = false
