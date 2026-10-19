class_name Parry
extends State

func enter():
	#host.sword_t = host.parry_t
	#host.stop_anims()
	
	host.tween_sword(host.parry_t, host.parry_time).finished.connect(_on_parry_done)

#func process(delta: float):
	
func _on_parry_done():
	change("Winddown")
