# estado.gd (Autoload "Estado")
extends Node

var noche := 1
var llamada := 1
var pistas := 0

func ir_a_cabina() -> void:
	get_tree().change_scene_to_file("res://zona_a.tscn")

func ir_a_exploracion() -> void:
	get_tree().change_scene_to_file("res://exploracion.tscn")
