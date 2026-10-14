class_name SwordSwing
extends State

func enter():
	host.pivot_q = host.pivot_swing_q
	host.sword_t = host.sword_swing_t #need guarantee proper transform
	host.swing_angle = 0.0
	host.stop_anims()

func process(delta: float):
	host.swing_angle += host.swing_speed * delta
	
	host.pivot_q = host.pivot_swing_q * Quaternion(Vector3.UP, host.swing_angle)
	
	if host.swing_angle >= host.max_swing_angle:
		machine.change("SwordWinddown")
		
