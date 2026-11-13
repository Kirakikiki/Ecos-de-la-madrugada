@tool
extends PointLight2D

@export var ancho_arriba := 10
@export var ancho_abajo := 120
@export var alto := 130
@export_range(0.0, 1.0) var suavidad := 0.9   

func _ready():
	texture = crear_cono()

func crear_cono() -> ImageTexture:
	var ancho_img := ancho_abajo + 40           
	var img := Image.create(ancho_img, alto, false, Image.FORMAT_RGBA8)
	for y in range(alto):
		var t := float(y) / float(alto - 1)
		var mitad := lerpf(ancho_arriba, ancho_abajo, t) / 2.0
		var vertical := 1.0 - smoothstep(0.0, 1.0, t)  
		for x in range(ancho_img):
			var dx: float = abs(x - (ancho_img - 1) / 2.0)
			var lateral := 1.0 - smoothstep(mitad * (1.0 - suavidad), mitad, dx)
			var v := clampf(lateral * vertical, 0.0, 1.0)
			img.set_pixel(x, y, Color(v, v, v, 1.0))
	return ImageTexture.create_from_image(img)
