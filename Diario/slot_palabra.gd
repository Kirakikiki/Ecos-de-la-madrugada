extends PanelContainer

class_name SlotPalabra

@onready var palabra: Label = %palabra

#aca se guarda la palabra de la casilla
var clave = ""

# Vacia la casilla al cargar la escena
func _ready() -> void:
	vaciar()

func llenar(c: String):
	clave = c
	palabra.text = c.capitalize()

func vaciar():
	clave = ""
	palabra.text = ""

# Revisa que casilla esta vacia
func estaVacio () -> bool:
	return clave == ""
