extends Area2D

# Player gets to deliver flowers here
func _on_body_entered(body: Node2D) -> void:
	body.hide_mushrooms()
	GameManager.mushrooms_delivered = true
	GameManager.next_step()
	$AudioObjective.play()
	await $AudioObjective.finished
	queue_free()
