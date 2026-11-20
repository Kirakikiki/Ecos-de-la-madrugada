extends PointLight2D

@export var tamano = 32            
@export var suavidad = 2.0           
@export var parpadea = true       
@export var energia_encendida = 0.8
@export var tiempo_subida = 1.2 
@export var tiempo_encendido = 0.4
@export var tiempo_apagado = 0.4 

var tween_parpadeo: Tween

func _ready():
	crear_textura()

	if parpadea:
		parpadear()

func crear_textura() -> void:
	#var img = Image.create(tamano, tamano, false, Image.FORMAT_RGBA8)
	if tamano < 2:
		push_error("El tamaño del LED debe ser como mínimo 2.")
		return
		
	var img := Image.create(tamano, tamano, false, Image.FORMAT_RGBA8)
	
	if img == null or img.is_empty():
		push_error("No se pudo crear la imagen del LED.")
		return
	
	var centro: float = tamano / 2.0
	
	for y in range(tamano):
		for x in range(tamano):
			var distancia := Vector2(x, y).distance_to(
				Vector2(centro, centro)
				)

			var brillo := 1.0 - distancia / centro
			brillo = pow(clampf(brillo, 0.0, 1.0), suavidad)
			
			img.set_pixel(x, y, Color(1.0, 1.0, 1.0, brillo))
	
	var nueva_textura := ImageTexture.create_from_image(img)
	
	if nueva_textura == null: 
		push_error("No se pudo generar la textura del LED.")
		return
	
	set_deferred("texture", nueva_textura)
	
func parpadear() -> void:
	if tween_parpadeo and tween_parpadeo.is_running():
		tween_parpadeo.kill()
		
	tween_parpadeo = create_tween().set_loops()
	tween_parpadeo.tween_property(self, "energy", energia_encendida, tiempo_subida)
	tween_parpadeo.tween_interval(tiempo_encendido)
	tween_parpadeo.tween_property(self, "energy", 0.0, tiempo_subida)
	
	tween_parpadeo.tween_interval(tiempo_apagado)
