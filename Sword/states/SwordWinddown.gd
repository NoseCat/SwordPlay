class_name SwordWinddown
extends State

func init() -> void:
	host.winddown_timer.timeout.connect(_on_winddown_done)

func enter():
	host.tween_pivot(host.pivot_idle_q, host.winddown_anim_time)
	host.tween_sword(host.sword_idle_t, host.winddown_anim_time)

	host.swing_angle = 0.0
	host.winddown_timer.start()


func process(delta: float):
	pass

func exit() -> void:
	host.winddown_timer.stop()

func _on_winddown_done():
	change("SwordIdle")
