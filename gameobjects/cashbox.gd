extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.name == "Coin":
		print("metes una moneda en la hucha, GANAS")
		if not body.is_queued_for_deletion():
			body.queue_free()
		
	pass # Replace with function body.
