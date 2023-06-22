extends Node2D


onready var beginPoint = global_position
onready var endPoint = global_position

onready var timer = $Timer


func updatePosition():
	var endVector = Vector2(rand_range(-48, 48), rand_range(-48, 48))
	endPoint = beginPoint + endVector

func timeLeft():
	return timer.time_left
	
func beginTimer(duration):
	timer.start(duration)

func _on_Timer_timeout():
	updatePosition()
