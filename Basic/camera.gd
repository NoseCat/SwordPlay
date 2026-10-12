extends Camera3D

@export var sensitivity := 0.003 #radians per pixel

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation.y += (-event.relative.x * sensitivity)
		rotation.x += (-event.relative.y * sensitivity)
		rotation.x = clamp(rotation.x, deg_to_rad(-90.0), deg_to_rad(90.0))
