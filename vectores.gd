class_name Vectores
extends RefCounted

static func normalizar(v: Vector3) -> Vector3:
	var largo := v.length()
	if largo == 0.0:
		return Vector3.ZERO
	return v / largo
