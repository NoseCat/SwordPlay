class_name StabWindup
extends State

func init() -> void:
	host.stab_windup_timer.timeout.connect(_on_windup_done)

func enter():
	#anims
	host.tween_pivot(host.pivot_swing_q, host.stab_windup_anim_time)
	host.tween_sword(host.sword_stab_t, host.stab_windup_anim_time)

	#logic
	host.stab_windup_timer.start(host.stab_windup_time)

func process(delta: float):
	pass

func exit() -> void:
	host.stab_windup_timer.stop()

func _on_windup_done():
	machine.change("Stab")
