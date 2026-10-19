class_name Stab
extends State

func enter():
	var dist = (host.sword_stab_strike_t.origin - host.sword_stab_t.origin).length()
	host.tween_sword(host.sword_stab_strike_t, dist/host.stab_speed).finished.connect(_on_strike_done)

#func process(delta: float):
	
func _on_strike_done():
	change("Winddown")
