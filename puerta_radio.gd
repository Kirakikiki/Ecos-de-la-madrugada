extends Area2D

var jugador: CharacterBody2D = null
var jugador_cerca: bool = false
var entrando: bool = false
var _salio_inicial: bool = false
var _tiempo_escena: float = 0.0
var _aviso_tween: Tween = null

@onready var aviso: Label = $Aviso


func _ready() -> void:
	body_entered.connect(_on_entra)
	body_exited.connect(_on_sale)
	aviso.hide()


func _physics_process(delta: float) -> void:
	_tiempo_escena += delta
	if entrando:
		return

	if jugador != null and not _salio_inicial:
		if jugador.global_position.distance_to(Vector2(127.0, 146.0)) > 9.0:
			_salio_inicial = true

	if jugador_cerca and jugador != null and _tiempo_escena > 0.45:
		if _puede_volver() and _salio_inicial and not aviso.visible:
			_mostrar_prompt_entrar()

		# Permite entrar caminando directo hacia la puerta (arriba) o con la tecla E
		var caminando_hacia_puerta: bool = (
			Input.is_action_pressed("move_up")
			and jugador.global_position.y <= 141.0
			and absf(jugador.global_position.x - global_position.x) <= 10.5
		)
		if caminando_hacia_puerta:
			if _puede_volver():
				_entrar_a_radio()
			elif _salio_inicial:
				_mostrar_aviso_temporal("Investiga la calle primero")


func _unhandled_input(event: InputEvent) -> void:
	if entrando or not jugador_cerca or _tiempo_escena <= 0.35:
		return
	if event.is_action_pressed("interactuar"):
		get_viewport().set_input_as_handled()
		if _puede_volver():
			_entrar_a_radio()
		else:
			_mostrar_aviso_temporal("Investiga la calle primero")


func _on_entra(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador = body as CharacterBody2D
		jugador_cerca = true
		if _puede_volver() and (_salio_inicial or _tiempo_escena > 0.6):
			_mostrar_prompt_entrar()


func _on_sale(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador_cerca = false
		_salio_inicial = true
		if _aviso_tween != null and _aviso_tween.is_running():
			_aviso_tween.kill()
		aviso.hide()


func _puede_volver() -> bool:
	if Estado.interactuo_en_calle:
		return true
	# Respaldo anti-bloqueo: si no hay ninguna pista nueva alcanzable con los PA actuales, permite volver tras salir de la puerta
	return _salio_inicial and not _hay_pistas_disponibles()


func _hay_pistas_disponibles() -> bool:
	var escena: Node = get_tree().current_scene
	if escena == null:
		return false
	for nodo in escena.get_children():
		if "id" in nodo and nodo is Area2D:
			var area: Area2D = nodo
			var pid: String = str(nodo.get("id"))
			if area.visible and pid != "" and not Estado.tiene_hallazgo(pid):
				var datos: Dictionary = Catalogo.PISTAS.get(pid, {})
				var costo: int = int(datos.get("costo", 1))
				if Estado.tiene_pa(costo):
					return true
	return false


func _mostrar_prompt_entrar() -> void:
	if _aviso_tween != null and _aviso_tween.is_running():
		return
	aviso.text = "[E] Entrar"
	aviso.modulate.a = 1.0
	aviso.show()


func _mostrar_aviso_temporal(mensaje: String) -> void:
	if _aviso_tween != null and _aviso_tween.is_running():
		if aviso.text == mensaje:
			return
		_aviso_tween.kill()
	aviso.text = mensaje
	aviso.modulate.a = 1.0
	aviso.show()
	_aviso_tween = create_tween()
	_aviso_tween.tween_interval(1.1)
	_aviso_tween.tween_property(aviso, "modulate:a", 0.0, 0.35)
	_aviso_tween.tween_callback(aviso.hide)


func _entrar_a_radio() -> void:
	if entrando:
		return
	entrando = true
	if _aviso_tween != null and _aviso_tween.is_running():
		_aviso_tween.kill()
	aviso.hide()

	Estado.reproducir_efecto("puerta", -6.0)

	if jugador != null:
		jugador.velocity = Vector2.ZERO
		jugador.set_physics_process(false)
		var col: CollisionShape2D = jugador.get_node_or_null("CollisionShape2D") as CollisionShape2D
		if col != null:
			col.set_deferred("disabled", true)
		var anim: AnimationPlayer = jugador.get_node_or_null("AnimationPlayer") as AnimationPlayer
		if anim != null and anim.has_animation("up"):
			anim.play("up")

		var t: Tween = create_tween().set_parallel(true)
		t.tween_property(jugador, "global_position", Vector2(127.0, 134.0), 0.42).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		t.tween_property(jugador, "modulate:a", 0.0, 0.42).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		await t.finished

	Estado.terminar_investigacion()
