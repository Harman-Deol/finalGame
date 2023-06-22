extends Area2D

func isOverlap():
	var areas = get_overlapping_areas()
	return areas.size() > 0
	
func pushAway():
	var areas = get_overlapping_areas()
	var push_vector = Vector2.ZERO
	
	if isOverlap():
		var area = areas[0]
		push_vector = area.global_position.direction_to(global_position)
		push_vector = push_vector.normalized()
	return push_vector



