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
	# ... agrega las demás con el mismo formato
}
