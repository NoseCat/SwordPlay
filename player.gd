extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	var camera = $Camera
	# Get camera's forward and right directions (projected onto horizontal plane)
	var forward = -camera.global_transform.basis.z
	var right = camera.global_transform.basis.x
	
	# Flatten to horizontal plane and normalize
	forward.y = 0
	right.y = 0
	forward = -forward.normalized()
	right = right.normalized()
	
	# Calculate movement direction relative to camera
	var direction = (forward * input_dir.y + right * input_dir.x).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	move_and_slide()
	
	$Sprite2D.position = DisplayServer.window_get_size()/2
	
