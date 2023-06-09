extends Node2D

@onready var interct_area : Area2D = $InteractionArea
@onready var dialog_bubble : Node2D = $DialogBubble
@onready var dialog_label : Label = $DialogBubble/Label
@onready var limit_wall : StaticBody2D = $LimitWall
@onready var audio_dialog : AudioStreamPlayer = $AudioDialog

func _ready() -> void:
	# Player gets here
	interct_area.connect("body_entered", _show_dialog_bubble)
	# Player leaves
	interct_area.connect("body_exited", _hide_dialog_bubble)
	
	GameManager.connect("deliver_mushrooms_pending", _on_deliver_mushrooms_pending)

func _show_dialog_bubble(_player: Node2D) -> void:
	dialog_bubble.scale = Vector2.ZERO
	dialog_bubble.show()
	var tween = create_tween()
	tween.tween_property(dialog_bubble, "scale", Vector2(1,1), 0.5).set_trans(Tween.TRANS_ELASTIC)
	set_bubble_text()
	
	# Lock until mission activated
	if GameManager.current_step == GameManager.Steps.DELIVER_FLOWERS_PENDING or \
		GameManager.current_step == GameManager.Steps.DELIVER_MUSHROOMS_PENDING:
		limit_wall.process_mode = Node.PROCESS_MODE_INHERIT
		limit_wall.show()
	else:
		limit_wall.process_mode = Node.PROCESS_MODE_DISABLED
		limit_wall.hide()

func _hide_dialog_bubble(_player: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(dialog_bubble, "scale", Vector2(0,0), 0.5).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(dialog_bubble.hide)
	
	# Lock until mission activated
	if GameManager.current_step == GameManager.Steps.DELIVER_FLOWERS_PENDING or \
		GameManager.current_step == GameManager.Steps.DELIVER_MUSHROOMS_PENDING:
		limit_wall.process_mode = Node.PROCESS_MODE_INHERIT
		limit_wall.show()
	else:
		limit_wall.process_mode = Node.PROCESS_MODE_DISABLED
		limit_wall.hide()

# This function shows text in the dialog bubble depending on the situation
func set_bubble_text() -> void:
	var text_array : Array = GameManager.get_npc_text()
	for text in text_array :
		dialog_label.text = text
		dialog_label.visible_ratio = 0
		var tween = create_tween()
		tween.tween_property(dialog_label, "visible_ratio", 1, 1.5)
		if !audio_dialog.playing:
			audio_dialog.play()
		await tween.finished
		await GameManager.interaction_triggered
	GameManager.next_step()

func _on_deliver_mushrooms_pending() -> void:
	# Flowers mission finished. Move NPC to next location
	position = Vector2(10800, 245)
