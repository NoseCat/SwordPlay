# SwordSwing.gd
class_name SwordSwing
extends State

func enter():
	host.sword_transform = host.swing_pos.transform
	host.swing_angle = 0.0

func process(delta: float):
	host.local_q = host.swing_dir_q * Quaternion(Vector3.UP, host.swing_angle)
	
	host.swing_angle += host.swing_speed * delta
	if host.swing_angle >= host.max_swing_angle:
		machine.change("SwordWinddown")
