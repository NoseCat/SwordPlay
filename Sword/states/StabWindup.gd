class_name StabWindup
extends State

#func init() -> void:

func enter():
	host.tween_sword_mult(host.pivot_swing_q, host.sword_stab_t, host.stab_windup_time).finished.connect(_on_windup_done)


#func process(delta: float):

#func exit() -> void:

func _on_windup_done():
	change("Stab")
