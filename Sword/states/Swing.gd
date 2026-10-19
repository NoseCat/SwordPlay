class_name Swing
extends State

func enter():
	var pivot = host.pivot_swing_q * Quaternion(Vector3.UP, host.max_swing_angle)
	var tween = host.tween_pivot(pivot, host.max_swing_angle/host.swing_speed)
	tween.finished.connect(_on_strike_done)

# func process(delta: float):
	
func _on_strike_done():
	change("Winddown")
