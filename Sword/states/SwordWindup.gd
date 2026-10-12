# SwordWindup.gd
class_name SwordWindup
extends State

var interp_t := 0.0

func enter():
	var crosshair_angle = host.crosshair.get_direction().angle_to(Vector2.RIGHT)
	host.swing_dir_q = Quaternion(Vector3.FORWARD, -crosshair_angle).normalized()
	
	interp_t = 0.0 #starting pos, drop to idle
	host.local_q = Quaternion.IDENTITY
	host.sword_transform = host.idle_pos.transform
	
	#anim takes priority over code driven changes
	var anim = host.anim_player.get_animation("wind")
	var speed = anim.length / host.windup_time
	host.anim_player.play("wind", -1.0, speed, false)

func process(delta: float):
	interp_t += delta 
	var k = clamp(interp_t / host.windup_time, 0.0, 1.0) #interp gets normalized with time
	host.local_q = Quaternion.IDENTITY.slerp(host.swing_dir_q, k)
	host.sword_transform = host.idle_pos.transform.interpolate_with(host.swing_pos.transform, k)

	if interp_t >= host.windup_time:
		machine.change("SwordSwing")
