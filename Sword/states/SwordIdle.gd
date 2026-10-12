class_name SwordIdle
extends State

func enter():
	host.swing_angle = 0.0
	
	host.local_q = host.idle_q
	host.sword_transform = host.idle_pos.transform

func process(_delta: float):
	if Input.is_action_just_pressed("LMB"):
		host.attack()
