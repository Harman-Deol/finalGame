extends AnimatedSprite

func _ready():
	connect("animation_finished", self, "animSprite_Finished")
	frame = 0
	play("Animate")
	
func animSprite_Finished():
	queue_free()
