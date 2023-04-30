extends Node

signal interaction_triggered
signal deliver_flowers_activated
signal deliver_mushrooms_pending
signal deliver_mushrooms_activated
signal game_over

enum Steps {
	DELIVER_FLOWERS_PENDING,
	DELIVER_FLOWERS_ACTIVE,
	DELIVER_MUSHROOMS_PENDING,
	DELIVER_MUSHROOMS_ACTIVE,
	GAME_OVER
}

var current_step := Steps.DELIVER_FLOWERS_PENDING
var flowers_delivered : bool = false
var mushrooms_delivered : bool = false

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
			return [
				"Congrats, you passed",
				"I wanted to see if\nyou're trustworthy.",
				"And you are ...",
				"So now I can trust\nyou to deliver some\nMagic Mushrooms",
				"It's straight ahead.\nDON'T EAT THEM"
			]
		Steps.DELIVER_MUSHROOMS_ACTIVE:
			return [
				"Go ahead Georgio !\nDeliver the mushrooms\nto the client!"
			]
		_:
			return [
				"This is an ERROR"
			]

func next_step() -> void:
	match current_step:
		Steps.DELIVER_FLOWERS_PENDING:
			# Enable first mission : delivering flowers
			current_step = Steps.DELIVER_FLOWERS_ACTIVE
			emit_signal("deliver_flowers_activated")
		Steps.DELIVER_FLOWERS_ACTIVE:
			if not flowers_delivered:
				return
			# Flowers have been delivered. Move to next mission. Mushrooms
			current_step = Steps.DELIVER_MUSHROOMS_PENDING
			emit_signal("deliver_mushrooms_pending")
		Steps.DELIVER_MUSHROOMS_PENDING:
			if not flowers_delivered:
				return
			# Flowers have been delivered. Move to next mission. Mushrooms
			current_step = Steps.DELIVER_MUSHROOMS_ACTIVE
			emit_signal("deliver_mushrooms_activated")
		Steps.DELIVER_MUSHROOMS_ACTIVE:
			if not mushrooms_delivered:
				return
			# Flowers have been delivered. Move to next mission. Mushrooms
			current_step = Steps.GAME_OVER
			emit_signal("game_over")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		print("current_step:")
		print(current_step)
		emit_signal("interaction_triggered")
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
