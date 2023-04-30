extends Node

enum Steps {
	DELIVER_FLOWERS,
	DELIVER_MUSHROOMS
}

var current_step := Steps.DELIVER_FLOWERS

func get_npc_text() -> Array:
	match current_step:
		Steps.DELIVER_FLOWERS:
			return [
				"Hey Georgio !\nCan you help me?\nI need to make a delivery",
				"I have some flowers\n I want to send up.\n It's a gift !"
			]
		Steps.DELIVER_MUSHROOMS:
			return ["pending"]
		_:
			return ["You shouldn't be here"]
