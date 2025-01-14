extends SubViewport

var frame_counter : int = 0

func _process(delta: float) -> void:
	frame_counter += 1
	if frame_counter % 5 == 0:
		render_target_update_mode = SubViewport.UPDATE_ONCE
