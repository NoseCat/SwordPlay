class_name Idle
extends State

func enter():
	pass

func process(_delta: float):
	if Input.is_action_just_pressed("LMB"):
		host.attack()

	if Input.is_action_just_pressed("RMB"):
		host.parry()

	if Input.is_action_just_pressed("F"):
		host.stab()
