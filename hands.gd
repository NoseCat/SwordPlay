extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


@onready var desired_shoulder_position = $ShoulderCenter.position
@onready var desired_shoulder_rotation = $ShoulderCenter.quaternion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation.y = $"../Camera".rotation.y
	
	$Shoulders.position = $Shoulders.position.lerp(desired_shoulder_position, delta * 5)
	$Shoulders.quaternion = $Shoulders.quaternion.slerp(desired_shoulder_rotation, delta * 5)
	
	desired_shoulder_position = $ShoulderCenter.position
	desired_shoulder_rotation = $ShoulderCenter.quaternion
	var swing_dir = $"../SwordCenter".swing_dir
	var factor = swing_dir.dot(Vector2.DOWN)
	if factor > 0 and ($"../SwordCenter".wind or $"../SwordCenter".swing):
		var sign = sign(swing_dir.x)
		if sign == 0:
			sign = 1
		var leanpos = Vector3(sign * $ShoulderLean.position.x, $ShoulderLean.position.y, $ShoulderLean.position.z)
		var leanrot = Quaternion(sign * $ShoulderLean.quaternion.x, $ShoulderLean.quaternion.y, $ShoulderLean.quaternion.z, sign * $ShoulderLean.quaternion.w).normalized() 
		desired_shoulder_position= $ShoulderCenter.position + (leanpos - $ShoulderCenter.position) * factor
		desired_shoulder_rotation = $ShoulderCenter.quaternion.slerp(leanrot, factor)
