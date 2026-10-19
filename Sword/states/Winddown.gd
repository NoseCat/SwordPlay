class_name Winddown
extends State

#func init() -> void:

func enter():
	host.tween_pivot(host.pivot_idle_q, host.winddown_time).finished.connect(_on_winddown_done)
	host.tween_sword(host.sword_idle_t, host.winddown_time)

#func process(delta: float):

#func exit() -> void:

func _on_winddown_done():
	change("Idle")
