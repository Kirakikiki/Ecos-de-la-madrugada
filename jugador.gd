extends CharacterBody2D

@export var velocidad = 50.0
@export var velocidad_correr = 90.0

var mirando = "abajo"

var quieto = {
	"abajo": "quieto_abajo",
	"arriba": "quieto_arriba",
	"derecha": "derecha_quieto",
	"izquierda": "izquierda_quieto",
}

func _physics_process(_delta):
	var dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var corriendo = Input.is_action_pressed("correr")

	velocity = dir * (velocidad_correr if corriendo else velocidad)
	move_and_slide()

	if dir == Vector2.ZERO:
		$Sprite.play(quieto[mirando])
		return

	# Elige la dirección dominante
	if abs(dir.x) > abs(dir.y):
		mirando = "derecha" if dir.x > 0 else "izquierda"
	else:
		mirando = "abajo" if dir.y > 0 else "arriba"

	$Sprite.speed_scale = 1.6 if corriendo else 1.0
	$Sprite.play(mirando)
