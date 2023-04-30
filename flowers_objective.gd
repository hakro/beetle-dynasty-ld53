extends Area2D

# Player gets to deliver flowers here
func _on_body_entered(body: Node2D) -> void:
	body.hide_flowers()
	GameManager.flowers_delivered = true
	GameManager.next_step()
