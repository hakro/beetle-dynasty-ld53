extends Node2D

@onready var psych_canvas : CanvasModulate = $PsychCanvasModulate
@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	GameManager.connect("pyschedelic_show", _on_pyschedelic_show)

func _on_pyschedelic_show():
	psych_canvas.show()
	$Player.process_mode = Node.PROCESS_MODE_DISABLED
	anim_player.play("psych_show")
