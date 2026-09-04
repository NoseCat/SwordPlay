extends Node3D

var target: Vector3
var preferred_elbow_pos: Vector3

var UpperarmLength: float
var ForearmLength: float

@export var hand_rest_path: NodePath

@onready var hand_rest: Node3D = get_node(hand_rest_path)

func _ready():
	UpperarmLength = $Upperarm.mesh.height
	ForearmLength = $Upperarm/Elbow/Forearm.mesh.height
	

func _process(_delta):
	target = hand_rest.global_position
	#preferred_elbow_pos = $PrefferedElbow.global_position
	$Upperarm/Elbow.quaternion = Quaternion(0,0,0,1)
	quaternion = Quaternion(0,0,0,1)
	
	look_at(target)
	quaternion *= Quaternion(Vector3(0,0,-1), 0)
	var to_target = target - global_position
	var max_distance = ForearmLength + UpperarmLength
	var x = (square(UpperarmLength) + square(to_target.length()) - square(ForearmLength)) / (2 * to_target.length())
	var y = sqrt(max(0.0, square(UpperarmLength) - square(x)))
	#var y = UpperarmLength * cos(clamp(to_target.length() / max_distance, 0, 1.0) * PI/2)
	#var x = sqrt(UpperarmLength * UpperarmLength - y * y)
	var elbow_pos = to_target.normalized() * x + ($Upperarm/Elbow/PrefferedElbow.global_position - $Upperarm/Elbow.global_position).normalized() * y
	look_at(global_position + elbow_pos)
	$Upperarm/Elbow.look_at(target)

func square(value: float):
	return value * value
