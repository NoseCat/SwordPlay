class_name ParryWindup
extends State

#func init() -> void:

func enter():
	host.tween_sword(host.parry_t, host.parry_windup_time).finished.connect(_on_windup_done)

#func process(delta: float):

#func exit() -> void:

func _on_windup_done():
	change("Parry")
