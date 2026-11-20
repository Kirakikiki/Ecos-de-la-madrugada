extends Node

# Una entrada por pista. "requisitos": basta UNO de ellos (palabra, pista de diálogo o lugar).
const PISTAS = {
	"canasta_pan": {
		"titulo": "Canasta de pan",
		"imagen": "res://imagenes/pistas/canasta_pan.png",
		"texto": "Junto a la puerta, con un paño limpio. Las migas son de hoy.",
		"requisitos": ["panes", "panes_desaparecidos"],
	},
	"soga_campana": {
		"titulo": "Soga de la campana",
		"imagen": "res://imagenes/pistas/soga_campana.png",
		"texto": "Cuelga quieta. Esta noche no hay viento.",
		"requisitos": ["campanas"],
	},
	"reloj_torre": {
		"titulo": "Reloj de la torre",
		"imagen": "res://imagenes/pistas/reloj_torre.png",
		"texto": "Las agujas marcan las 3:12. Hay una silla puesta para mirarlo.",
		"requisitos": ["reloj_3_12", "luz"],
	},
	"poste_farola_7":{
		"titulo": "Poste de la farola siete",
		"imagen": "res://imagenes/pistas/poste_farola_7.png",
		"texto": "Una marca de metal en la pistura, a la altura de una mano. Debajo, una lampara de aceite con la inscripcion 'G'. Aun huele a humo",
		"requisitos": ["farolas", "mano", "figura_farola_7", "marca_poste"]
	},
	"dibujo_nino":{
		"titulo": "Dibujo de crayón",
		"imagen": "res://imagenes/pistas/",
		"texto": "Una casa, una escalera, una figura muy alta. En una ventana diminuta, alguien escribió: 'estoy aqui'. ",
		"requisitos": ["ventana_pequena", "humedad_escalera", "sombra_alta"]
	},
	"foto_apagon": {
		"titulo": "Fotografía del apagón",
		"imagen":"",
		"texto": "Dañada por la humedad. Al fondo, alguien junto a una casa abandonada. Atrás, una fecha y dos inciales casi borradas.",
		"requisitos": ["foto_apagon", "gente"]
	},
	"zapato_barro": {
		"titulo": "Zapato infantil",
		"imagen": "",
		"texto": "Solo uno, con los cordones desatados. El barro rojizo es el mismo del camino viejo.",
		"requisitos": ["bolsa_grande", "puerta_cerrada"]
	},
	"llavero": {
		"titulo": "Llavero con tres llaves",
		"imagen": "",
		"texto": "Suena fuerte al moverse. Una llave es muy vieja y tiene una estrella torcida grabada.",
		"requisitos": ["llavero", "hombre_alto_farola"]
	},
	"tabla_estrella":{
		"titulo": "Tabla con una estrella",
		"imagen": "",
		"texto": "Tallada a mano, torcida a propósito. Por detrás, con letra de adulto: 'no abrir'. La madera está más fresca de lo que debería",
		"requisitos":["estrella_torcida", "marta_casa_vieja"]
	},
	"carta_marta":{
		"titulo": "Carta sin enviar",
		"imagen": "",
		"texto": "Sin sello ni destinatario. 'No me preguntes por qué, solo no salgas esta noche'. La tinta está corrida",
		"requisitos":["marta_contradice", "marta_se_delata"]
	},
	"foto_rota":{
		"titulo": "Fotografía rota",
		"imagen": "",
		"texto": "Una mujer joven y un niño frente a la casa vieja. La otra mitad fue arrancada con cuidado. queda una mano grande sobre su hombro",
		"requisitos":["hijo_conoce_casa", "foto_apagon"]
	},
	"llave_sotano":{
		"titulo": "Llave con cinta roja",
		"imagen": "",
		"texto": "Llegó en el buzón de la emisora. La nota dice: 'Atrás, por la puerta baja'. No está firmada.",
		"requisitos":["hijo_de_marta", "testigo_crimen"]
	}
}
