extends Node

signal interaction_triggered

enum Steps {
	DELIVER_FLOWERS_PENDING,
	DELIVER_MUSHROOMS
}

var current_step := Steps.DELIVER_FLOWERS_PENDING

func get_npc_text() -> Array:
	match current_step:
		Steps.DELIVER_FLOWERS_PENDING:
			return [
				"Hey Georgio !\nCan you help me?\nI need to make a delivery",
				"I have some flowers\nI want to send up.\nIt's a gift !",
				"You're great !\nThanks a lot\nfor your help !"
			]
		Steps.DELIVER_MUSHROOMS:
			return ["pending"]
		_:
			return ["You shouldn't be here!\nError"]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		#print("event interaction_triggered emitted")
		emit_signal("interaction_triggered")
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
