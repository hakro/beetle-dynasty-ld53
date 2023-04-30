extends Node2D


@onready
var interct_area : Area2D = $InteractionArea

@onready
var dialog_bubble : Node2D = $DialogBubble

func _ready() -> void:
	# Player gets here
	interct_area.connect("body_entered", _show_dialog_bubble)
	# Player leaves
	interct_area.connect("body_exited", _hide_dialog_bubble)

func _show_dialog_bubble(_player: Node2D) -> void:
	dialog_bubble.show()

func _hide_dialog_bubble(_player: Node2D) -> void:
	dialog_bubble.hide()
