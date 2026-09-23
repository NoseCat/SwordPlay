class_name SwordWinddown
extends State

var interp_t := 0.0

var swing_left_q: Quaternion = Quaternion()
var swing_left_sword_t: Transform3D = Transform3D()

func enter():
	interp_t = 0.0
	host.sword_transform = host.swing_pos.transform
	swing_left_q = host.local_q #not exactly
	swing_left_sword_t = host.sword_transform

func process(delta: float):
	interp_t += delta
	var k = clamp(interp_t / host.winddown_time, 0.0, 1.0)
	host.local_q = swing_left_q.slerp(host.idle_q, k)
	host.sword_transform = swing_left_sword_t.interpolate_with(host.idle_pos.transform, k)

	if interp_t >= host.winddown_time:
		machine.change("SwordIdle")
