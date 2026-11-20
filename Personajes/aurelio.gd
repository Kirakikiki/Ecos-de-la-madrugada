extends CharacterBody2D


@export var velocidad = 50.0
@export var velocidad_correr = 90.0

@onready var animationPlayer = $AnimationPlayer


# Nombre de las animaciones
const CAMINAR={
	"arriba" :"up",
	"abajo" : "down",
	"derecha" : "rigth",
	"izquierda" : "left"
}

var mirando = "abajo"

func _ready():
	add_to_group("jugador") #esto es para que las pistas decten al personaje
	animationPlayer.play("abajo")

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("move_left", "move_right", "move_up","move_down")
	var corriendo = Input.is_action_pressed("correr")
	
	velocity = dir * (velocidad_correr if corriendo else velocidad)
	move_and_slide()
	
	if dir == Vector2.ZERO:
		animationPlayer.speed_scale = 1.0
		animationPlayer.play("idle")
		return
	
	
	#elije la direccion dominante
	if abs(dir.x) > abs(dir.y):
		mirando = "derecha" if dir.x > 0 else "izquierda"
	else:
		mirando= "abajo" if dir.y > 0 else "arriba"
	animationPlayer.speed_scale = 1.6 if corriendo else 1.0
	animationPlayer.play(CAMINAR[mirando])
