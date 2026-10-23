class_name SwingWindup
extends State

#func init() -> void:

func enter():
	#host.tween_pivot(host.pivot_swing_q, host.swing_windup_time)
	host.tween_sword_mult(host.pivot_swing_q, host.sword_swing_t, host.swing_windup_time).finished.connect(_on_windup_done)

#func process(delta: float):

#func exit() -> void:

func _on_windup_done():
	change("Swing")
