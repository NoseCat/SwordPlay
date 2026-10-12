class_name Hands
extends Node3D

@export var camera: Node3D
@onready var shoulders : Node3D = $Shoulders
@onready var shoulder_center : Node3D = $ShoulderCenter
@onready var right_hand = $Shoulders/ShoulderRight
@onready var left_hand = $Shoulders/ShoulderLeft
@onready var shoulder_lean : Node3D = $ShoulderLean
@export var follow_speed := 5.0

var _lean_dir := Vector2.ZERO
var _lean_active := false

@export var weapon: Sword

func _ready() -> void:
	right_hand.hand_rest = weapon.right_hand_rest_pos
	left_hand.hand_rest = weapon.left_hand_rest_pos

## Call with the current swing direction (2D, screen space) and whether a
## wind-up / swing is in progress. Call with active = false to relax.
func set_lean(dir: Vector2, active: bool) -> void:
	_lean_dir = dir
	_lean_active = active


func _process(delta: float) -> void:
	if camera:
		rotation.y = camera.rotation.y

	var target_pos := shoulder_center.position
	var target_rot := shoulder_center.quaternion

	var factor := _lean_dir.dot(Vector2.DOWN)
	if _lean_active and factor > 0.0:
		var side := signf(_lean_dir.x)
		if side == 0.0:
			side = 1.0
		# Mirror the lean pose across the YZ plane when swinging to the other side.
		var lp := shoulder_lean.position
		var lq := shoulder_lean.quaternion
		var lean_pos := Vector3(side * lp.x, lp.y, lp.z)
		var lean_rot := Quaternion(side * lq.x, lq.y, lq.z, side * lq.w).normalized()
		target_pos = target_pos.lerp(lean_pos, factor)
		target_rot = target_rot.slerp(lean_rot, factor)

	var t := 1.0 - exp(-follow_speed * delta)  # frame-rate independent smoothing
	shoulders.position = shoulders.position.lerp(target_pos, t)
	shoulders.quaternion = shoulders.quaternion.slerp(target_rot, t)
