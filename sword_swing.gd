extends Marker3D

func _ready() -> void:
	pass # Replace with function body.


var player_rotation #angle to +y, inditcating where player is looking
var swing_dir = Vector2(0,1) # direction from which the swing comes
var swing_state = 0 #how far are we into the swing 

var swing: bool = false
var wind: bool = false

var windup_accum = 0
var windup_time = 1.0

var winddown_time = 1.0
var winddown_accum = winddown_time

var swing_dir_q = Quaternion(Vector3.FORWARD, 0)

func _process(delta: float) -> void:
	
	var y_axis_q = Quaternion(Vector3.UP, $"../Camera".rotation.y)
	var x_axis_q = Quaternion(Vector3.RIGHT, $"../Camera".rotation.x)
	
	quaternion = y_axis_q * x_axis_q
	#winddown_accum += delta
	#winddown_accum = min(winddown_accum, winddown_time)
	#quaternion *= swing_dir_q.slerp(Quaternion(Vector3.FORWARD, 0), winddown_accum/winddown_time)
	#needs pos interpoliation instead
	
	if Input.is_action_just_pressed("LMB"):
		swing_dir = $"../Crosshair".get_direction()
		swing_dir_q = Quaternion(Vector3.FORWARD, -swing_dir.angle_to(Vector2.RIGHT)).normalized()
		$"../AnimationPlayer".play("wind")
		wind = true
		windup_accum = 0
	
	if wind:
		windup_accum += delta;
		quaternion *= Quaternion(Vector3.FORWARD, 0).slerp(swing_dir_q, windup_accum/windup_time)
		#needs pos interpoliation instead
		
	
	if swing:
		var swing_state_q = Quaternion(Vector3.UP, swing_state)
		quaternion *= swing_dir_q * swing_state_q
		swing_state += 5.0 * delta
		if swing_state >= deg_to_rad(150):
			stop_swing()
			

func stop_swing():
	#swing_dir_q = Quaternion(Vector3.FORWARD, 0).normalized()
	swing_state = 0
	swing = false
	winddown_accum = 0
	$"../AnimationPlayer".play("RESET")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "wind"):
		swing = true
		wind = false


func _on_blade_area_entered(area: Area3D) -> void:
	if area.get_collision_layer_value(2): # Flesh. Cringe magic number check
		var packed_scene = preload("res://blood_spatter.tscn")
		var instance = packed_scene.instantiate()
		add_child(instance)
		var col = $SwordGrip/Blade/RayCast3D.get_collision_point()
		instance.top_level = true
		instance.global_position = col
		instance.quaternion = quaternion

func _on_blade_body_entered(body: Node3D) -> void:
	if body.get_collision_layer_value(1):
		stop_swing()
