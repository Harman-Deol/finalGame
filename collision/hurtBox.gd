extends Area2D

var iFrame = false setget set_iFrame

signal iFrameBegin
signal iFrameEnd

onready var timer = $Timer

func set_iFrame(value):
	iFrame = value
	if iFrame == true:
		emit_signal("iFrameBegin")
	else:
		emit_signal("iFrameEnd")


func iFrameActive(duration):
	self.iFrame = true
	timer.start(duration)


func _on_Timer_timeout():
	self.iFrame = false


func _on_hurtBox_iFrameBegin():
	set_deferred("monitoring", false)


func _on_hurtBox_iFrameEnd():
	monitoring = true
