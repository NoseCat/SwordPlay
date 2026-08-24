extends Marker3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


var player_rotation #angle to +y, inditcating where player is looking
var swing_angle # angle to horizon from which the swing comes
var swing_state_angle = 0 #how far are we into the swing 

var swing: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	var y_axis_q = Quaternion(Vector3.UP, $"../Camera".rotation.y)
	var x_axis_q = Quaternion(Vector3.RIGHT, $"../Camera".rotation.x)
	
	swing_angle = $"../Crosshair".get_direction().angle_to(Vector2.RIGHT)
	var swing_axis_q = Quaternion(Vector3.FORWARD, -swing_angle)
	
	var swing_state_q = Quaternion(Vector3.UP, swing_state_angle)
	
	quaternion = y_axis_q * x_axis_q# * swing_axis_q #* swing_state_q
	
	if Input.is_action_just_pressed("LMB"):
		$"../AnimationPlayer".play("wind")
	
	if swing:
		quaternion *= swing_axis_q * swing_state_q
		swing_state_angle += 5.0 * delta
		if swing_state_angle >= 5.0 * delta * 100:
			swing_state_angle = 0
			swing = false


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	swing = true
