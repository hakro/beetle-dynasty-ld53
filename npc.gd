extends Node2D

@onready var interct_area : Area2D = $InteractionArea
@onready var dialog_bubble : Node2D = $DialogBubble
@onready var dialog_label : Label = $DialogBubble/Label

func _ready() -> void:
	# Player gets here
	interct_area.connect("body_entered", _show_dialog_bubble)
	# Player leaves
	interct_area.connect("body_exited", _hide_dialog_bubble)

func _show_dialog_bubble(_player: Node2D) -> void:
	dialog_bubble.scale = Vector2.ZERO
	dialog_bubble.show()
	var tween = create_tween()
	tween.tween_property(dialog_bubble, "scale", Vector2(1,1), 0.5).set_trans(Tween.TRANS_ELASTIC)
	set_bubble_text()

func _hide_dialog_bubble(_player: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(dialog_bubble, "scale", Vector2(0,0), 0.5).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(dialog_bubble.hide)

# This function shows text in the dialog bubble depending on the situation
func set_bubble_text() -> void:
	var text_array : Array = GameManager.get_npc_text()
	for text in text_array :
		dialog_label.text = text
		dialog_label.visible_ratio = 0
		var tween = create_tween()
		tween.tween_property(dialog_label, "visible_ratio", 1, 1.5)
		await tween.finished
		await GameManager.interaction_triggered
	GameManager.next_step()
