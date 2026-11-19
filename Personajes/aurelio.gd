extends CharacterBody2D


@export var velocidad = 50.0
@export var velocidad_correr = 90.0

@onready var animationPlayer = $AnimationPlayer
@onready var sprite2D = $Sprite2D

func _ready():
	animationPlayer.play("abajo")

func _physics_process(delta: float) -> void:
	var dir = Input.get_vector("move_left", "move_down", "move_right", "move_up")
	var corriendo = Input.is_action_just_pressed("correr")
	
	velocity = dir * (velocidad_correr if corriendo else velocidad)
	move_and_slide()
	
	if dir == Vector2.ZERO:
		animationPlayer.speed_scale = 1.0
		animationPlayer.play("idle")
		return
	
	var anim = ""
	#elije la direccion dominante
	if abs(dir.x) > abs(dir.y):
		anim = "derecha" if dir.x > 0 else "izquierda"
	else:
		anim = "arriba" if dir.y > 0 else "abajo"
	animationPlayer.speed_scale = 1.6 if corriendo else 1.0
	print("dir: ", dir, " -> anim: ", anim)
	animationPlayer.play(anim)
	print(anim)
