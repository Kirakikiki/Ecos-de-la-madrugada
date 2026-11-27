
extends Control

@onready var puntos = [
	$BarraPuntosAccion/VBoxContainer/HBoxContainer/Punto1,
	$BarraPuntosAccion/VBoxContainer/HBoxContainer/Punto2,
	$BarraPuntosAccion/VBoxContainer/HBoxContainer/Punto3
]

func _ready() -> void:
	Estado.pa_cambio.connect(actualizar_puntos)
	actualizar_puntos(Estado.pa)


func actualizar_puntos(valor: int) -> void:
	for i in range(puntos.size()):
		var material = puntos[i].material as ShaderMaterial

		if material == null:
			continue

		if i < valor:
			material.set_shader_parameter(
				"color_circulo",
				Color("#FFFFFF")
			)
		else:
			material.set_shader_parameter(
				"color_circulo",
				Color("#454545")
			)
