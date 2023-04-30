extends Node

signal interaction_triggered
signal deliver_flowers_activated

enum Steps {
	DELIVER_FLOWERS_PENDING,
	DELIVER_FLOWERS_ACTIVE,
	DELIVER_MUSHROOMS_PENDING
}

var current_step := Steps.DELIVER_FLOWERS_PENDING

func get_npc_text() -> Array:
	match current_step:
		Steps.DELIVER_FLOWERS_PENDING:
			return [
				"Hey Georgio !\nCan you help me?\nI need to make a delivery",
				"I have some flowers\nI want to send up.\nIt's a gift !",
				"You just need to\nclimb up to\nthe third floor",
				"You're great !\nThanks a lot\nfor your help !"
			]
		Steps.DELIVER_FLOWERS_ACTIVE:
			return [
				"Go ahead Georgio !\nTake the flowers up!"
			]
		Steps.DELIVER_MUSHROOMS_PENDING:
			return ["pending"]
		_:
			return ["You shouldn't be here!\nError"]

func next_step() -> void:
	match current_step:
		Steps.DELIVER_FLOWERS_PENDING:
			current_step = Steps.DELIVER_FLOWERS_ACTIVE
			emit_signal("deliver_flowers_activated")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		#print("event interaction_triggered emitted")
		emit_signal("interaction_triggered")
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
