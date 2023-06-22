extends Area2D

var player = null


func playerSeen():
	return player != null

func _on_PawnSense_body_entered(body):
	player = body


func _on_PawnSense_body_exited(body):
	player = null
