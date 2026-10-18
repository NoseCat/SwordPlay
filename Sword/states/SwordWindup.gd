class_name SwordWindup
extends State

func init() -> void:
	host.windup_timer.timeout.connect(_on_windup_done)

func enter():
	#anims
	host.tween_pivot(host.pivot_swing_q, host.windup_anim_time)
	host.tween_sword(host.sword_swing_t, host.windup_anim_time)
	host.animate("wind", host.windup_time)

	#logic
	host.windup_timer.start(host.windup_time)

func process(delta: float):
	pass

func exit() -> void:
	host.windup_timer.stop()

func _on_windup_done():
	machine.change("SwordSwing")
