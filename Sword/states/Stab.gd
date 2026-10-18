class_name Stab
extends State

func enter():
	host.pivot_q = host.pivot_swing_q # pivot_swing_q is just neutral
	host.sword_t = host.sword_stab_t
	host.stop_anims()
	
	var dist = (host.sword_stab_strike_t.origin - host.sword_stab_t.origin).length()
	host.tween_sword(host.sword_stab_strike_t, dist/host.stab_speed).finished.connect(_on_strike_done)

func process(delta: float):
	pass
	
func _on_strike_done():
	machine.change("SwordWinddown")
