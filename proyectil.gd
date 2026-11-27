extends Area2D

signal golpeo #avisa al reto que la piedra toco al jugador

@export var velocidad = 90.0 #pixeles por segundo hacia la izquierda

func _ready():
	body_entered.connect(_on_body) # al entrar a un cuerpo, llama a _on_body

func _physics_process(delta):
	position.x -= velocidad * delta # mueve la piedra a la izquierda

func _on_body(body):
	if body.is_in_group("jugador"):    #solo reacciona al jugador
		golpeo.emit()  # avisa del golpe
		queue_free()   # elimina la piedra
