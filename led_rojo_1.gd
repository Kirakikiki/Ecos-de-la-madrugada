extends PointLight2D

@export var tamano = 128              
@export var suavidad = 2.0           
@export var parpadea = true       
@export var energia_encendida = 1.2
@export var tiempo_subida = 0.3   
@export var tiempo_encendido = 0.7
@export var tiempo_apagado = 0.8   

func _ready():
	crear_textura()
	if parpadea:
		parpadear()

func crear_textura():
	var img = Image.create(tamano, tamano, false, Image.FORMAT_RGBA8)
	var centro = tamano / 2.0
	for y in tamano:
		for x in tamano:
			var brillo = 1 - Vector2(x, y).distance_to(Vector2(centro, centro)) / centro
			brillo = pow(clamp(brillo, 0, 1), suavidad)
			img.set_pixel(x, y, Color(brillo, brillo, brillo))
	texture = ImageTexture.create_from_image(img)

func parpadear():
	var tween = create_tween().set_loops()
	tween.tween_property(self, "energy", energia_encendida, tiempo_subida)
	tween.tween_interval(tiempo_encendido)
	tween.tween_property(self, "energy", 0.0, tiempo_subida)
	tween.tween_interval(tiempo_apagado)
