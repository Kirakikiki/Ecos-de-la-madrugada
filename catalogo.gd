extends Node

# Una entrada por pista. "requisitos": basta UNO de ellos (palabra, pista de diálogo o lugar).
const PISTAS = {
	"canasta_pan": {
		"titulo": "Canasta de pan",
		"imagen": "res://imagenes/pistas/canasta_pan.png",
		"texto": "Junto a la puerta, con un paño limpio. Las migas son de hoy.",
		"requisitos": ["panes", "panes_desaparecidos"],
		"costo" : 2
	},
	"soga_campana": {
		"titulo": "Soga de la campana",
		"imagen": "res://imagenes/pistas/soga_campana.png",
		"texto": "Cuelga quieta. Esta noche no hay viento.",
		"requisitos": ["campanas"],
	},
	# Noche 2
	"dibujo_nino":{
		"titulo": "Dibujo de crayón",
		"imagen": "res://imagenes/pistas/dibujo_nino.png",
		"texto": "Una casa, una escalera, una figura muy alta. En una ventana diminuta, alguien escribió: 'estoy aqui'. ",
		"requisitos": ["puerta"]
	},
	
	"poste_farola_7":{
		"titulo": "Poste de la farola siete",
		"imagen": "res://imagenes/pistas/poste_farola_7.png",
		"texto": "Una marca de metal en la pistura, a la altura de una mano. Debajo, una lampara de aceite con la inscripcion 'G'. Aun huele a humo",
		"requisitos": ["farola"],
		"costo" : 2
	},
	# Noche 3
	"zapato_barro": {
		"titulo": "Zapato infantil",
		"imagen": "res://imagenes/pistas/zapato_barro.png",
		"texto": "Solo uno, con los cordones desatados. El barro rojizo es el mismo del camino viejo.",
		"requisitos": ["barro"],
		"costo" : 2
	},
	"foto_apagon": {
		"titulo": "Fotografía del apagón",
		"imagen":"res://imagenes/pistas/foto_apagon.png",
		"texto": "Dañada por la humedad. Al fondo, alguien junto a una casa abandonada. Atrás, una fecha y dos inciales casi borradas.",
		"requisitos": ["fotografia"]
	},
	# Noche 4
	"reloj_torre": {
		"titulo": "Reloj de la torre",
		"imagen": "res://imagenes/pistas/reloj_torre.png",
		"texto": "Las agujas marcan las 3:12. Hay una silla puesta para mirarlo.",
		"requisitos": ["torre"]
	},
	
	"llavero": {
		"titulo": "Llavero con tres llaves",
		"imagen": "res://imagenes/pistas/llavero.png",
		"texto": "Suena fuerte al moverse. Una llave es muy vieja y tiene una estrella torcida grabada.",
		"requisitos": ["rendija"]
	},
	"tabla_estrella":{
		"titulo": "Tabla con una estrella",
		"imagen": "res://imagenes/pistas/tabla_estrella.png",
		"texto": "Tallada a mano, torcida a propósito. Por detrás, con letra de adulto: 'no abrir'. La madera está más fresca de lo que debería",
		"requisitos":["rendija"]
	},
	# Noche 5
	"carta_marta":{
		"titulo": "Carta sin enviar",
		"imagen": "res://imagenes/pistas/carta_marta.png",
		"texto": "Sin sello ni destinatario. 'No me preguntes por qué, solo no salgas esta noche'. La tinta está corrida",
		"requisitos":["errores"],
		"costo" : 2
	},
	"foto_rota":{
		"titulo": "Fotografía rota",
		"imagen": "res://imagenes/pistas/foto_rota.png",
		"texto": "Una mujer joven y un niño frente a la casa vieja. La otra mitad fue arrancada con cuidado. queda una mano grande sobre su hombro",
		"requisitos":["casa"]
	},
	"llave_sotano":{
		"titulo": "Llave con cinta roja",
		"imagen": "res://imagenes/pistas/llave_sotano.png",
		"texto": "Llegó en el buzón de la emisora. La nota dice: 'Atrás, por la puerta baja'. No está firmada.",
		"requisitos":["casa"],
		"costo" : 2
	}
}
