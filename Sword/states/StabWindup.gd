class_name StabWindup
extends State

#func init() -> void:

func enter():
	host.tween_pivot(host.pivot_swing_q, host.stab_windup_time).finished.connect(_on_windup_done)
	host.tween_sword(host.sword_stab_t, host.stab_windup_time)

#func process(delta: float):

#func exit() -> void:

func _on_windup_done():
	change("Stab")
