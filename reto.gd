extends Node2D

@export var ESCENA_PROYECTIL: PackedScene
@export var duracion = 15.0                 # segundos que hay que sobrevivir
@export var vidas = 3                       # golpes que aguanta el jugador
@export var distancia = 140.0               # distancia en X del villano al jugador


@onready var encapuchado: Node2D = $Encapuchado    # el villano
@onready var boca: Marker2D = $Encapuchado/Boca    # punto de salida para las piedras
@onready var lanzar: Timer = $Lanzar               # temporizador entre lanzamientos
@onready var etiqueta: Label = %Etiqueta           # texto de vidas y tiempo


var jugador : CharacterBody2D  # Aurelio se busca por grupo
var linterna : PointLight2D    # luz dentro de Aurelio
var tiempo = 0.0               # segundos trancuridos
var terminado = false          # evita terminar dos veces

func _ready():
	get_tree().paused = false   # por si nos redirige desde una pausa como diario o visor
	
	jugador = get_tree().get_first_node_in_group("jugador") as CharacterBody2D   # Busca a Aurelio por el grupo
	if jugador == null:  # si no lo encuentra
		push_error("Reto: no hay ningun nodo en el grupo'jugador'") # avisa en la consola
		return # no sigue para evitar mas errores
	
	linterna = jugador.get_node_or_null("Linterna") as PointLight2D # busca la linterna dentro de Aurelio
	if linterna: # si existe
		linterna.enabled = true # la enciende
	else:
		push_warning("Aurelio no tiene un nodo 'Linterna'") # Avisa en caso de que falle
	
	encapuchado.global_position.x = jugador.global_position.x + distancia  # villano a la derecha de aurelio
	
	lanzar.timeout.connect(_lanzar_piedra) #cada ciclo del timer tira una piedra
	lanzar.start() # arranca el timer
	Estado.reproducir_efecto("amenaza", -14.0) # ambiente tenso

func _process(delta): 
	if terminado or jugador == null: # si acabo o no esta aurelio, no hace nada
		return
	tiempo += delta # suma el tiempo
	
	etiqueta.text = "Vidas: %d    Tiempo: %d" % [vidas, ceili(duracion - tiempo)]  # Actualiza el texto
	
	var y_actual = encapuchado.global_position.y #altura actual del villano
	encapuchado.global_position.y = lerpf(y_actual, jugador.global_position.y, 0.03) # sigue despacio a aurelio
	
	if tiempo >= duracion: #si aguanto todo el tiempo
		_terminar(true) # gana

func _lanzar_piedra():
	if terminado:   # no lanza si se acabo
		return
	var p = ESCENA_PROYECTIL.instantiate() # crea una piedra
	p.global_position = boca.global_position # nace en la boca del villano
	p.golpeo.connect(_on_golpe) # al golpear, llama la funcion _on_golpe
	add_child(p) # la añade al reto

func _on_golpe():
	if terminado:
		return
	vidas -= 1 # pierde una vida
	if vidas <= 0: #sin vidas
		_terminar(false) # pierde

func _terminar(superado: bool):
	if terminado:
		return
	terminado = true  # marca que acabo
	lanzar.stop() # deja de lanzar
	
	if linterna: # si hay linterna
		linterna.enabled = false # apaga la linterna
	
	Estado.detener_efecto("amenaza") #corta el ambiente
	
	etiqueta.text = "¡Lo lograste!" if superado else "Te golpearon..."
	await get_tree().create_timer(1.2).timeout #tiempo para leer
	Estado.terminar_reto(superado) # vuelve a la calle
