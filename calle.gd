extends Node2D

func _ready() -> void:
	_iniciar_viento_ambiente()

func _iniciar_viento_ambiente() -> void:
	if ResourceLoader.exists("res://audio/efectos_dialogos/viento.mp3"):
		var viento := AudioStreamPlayer.new()
		viento.name = "VientoAmbiente"
		var st = load("res://audio/efectos_dialogos/viento.mp3")
		if st is AudioStreamMP3:
			st.loop = true
		viento.stream = st
		viento.volume_db = -11.0  # Nivel claro y atmosferico, sin saturar
		viento.finished.connect(viento.play)
		add_child(viento)
		viento.play()
