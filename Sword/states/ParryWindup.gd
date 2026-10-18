class_name ParryWindup
extends State

func init() -> void:
	host.parry_windup_timer.timeout.connect(_on_windup_done)

func enter():
	#anims
	host.tween_sword(host.parry_t, host.parry_windup_anim_time)

	#logic
	host.parry_windup_timer.start(host.parry_windup_time)

func process(delta: float):
	pass

func exit() -> void:
	host.parry_windup_timer.stop()

func _on_windup_done():
	machine.change("Parry")
