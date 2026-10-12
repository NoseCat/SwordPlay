extends MeshInstance3D

# Must match the array size in the shader exactly!
const MAX_POINTS := 64

@export_group("Point Generation")
@export var randomize_count: bool = true
@export var point_count: int = 20
@export var min_points: int = 5
@export var max_points: int = MAX_POINTS

@export var skew_towards: Vector2 = Vector2.ZERO
@export var skew_strength: float = 3.0

@export_group("Circle Growth")
@export var min_grow_speed: float = 0.05
@export var max_grow_speed: float = 0.25

@export_group("Appearance")
@export var base_color: Color = Color(0.12, 0.58, 0.95)

var _elapsed: float = 0.0

func _ready():
	generate_points()

func _process(delta):
	_elapsed += delta
	var mat := get_surface_override_material(0)
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("time", _elapsed)
		mat.set_shader_parameter("bottomLeft", $BottomLeft.position)
		mat.set_shader_parameter("bottomRight", $"BottomRight".position)
		mat.set_shader_parameter("topLeft", $"TopLeft".position)
		mat.set_shader_parameter("topRight", $"TopRight".position)
		$BottomLeft.position.z -= delta * 0.5
		$BottomLeft.position.x -= delta * 0.25
		$TopLeft.position.x += delta * 0.5
		$TopLeft.position.z -= delta * 0.25
		

func generate_points():
	var mat := get_surface_override_material(0)
	if mat == null or not (mat is ShaderMaterial):
		mat = ShaderMaterial.new()
		mat.shader = preload("res://blood.gdshader") 
		set_surface_override_material(0, mat)

	var count := randi_range(min_points, max_points) if randomize_count else point_count
	count = clamp(count, 1, MAX_POINTS)

	var pts := PackedVector3Array()

	for i in range(count):
		var x := biased_random(0.0, 1.0, skew_towards.x, skew_strength)
		var y := biased_random(0.0, 1.0, skew_towards.y, skew_strength)
		var speed := randf_range(min_grow_speed, max_grow_speed)
		pts.append(Vector3(x, y, speed))

	# Pad to match the shader's fixed array size
	while pts.size() < MAX_POINTS:
		pts.append(Vector3(-1.0, -1.0, 0.0))

	mat.set_shader_parameter("points", pts)
	mat.set_shader_parameter("point_count", count)
	mat.set_shader_parameter("color", base_color)
	
	
	

func biased_random(min_val: float, max_val: float, target: float, strength: float) -> float:
	if strength < 0.0 or strength > 1.0:
		push_error("strength must be in [0, 1]")
		return 0.0
	
	if strength == 0.0:
		return randf_range(min_val, max_val)
	
	var range_size: float = max_val - min_val
	var std_dev: float = range_size * (1.0 - strength) / (strength * 10.0 + 0.5) #Tuning
	
	while true:
		var value: float = randfn(target, std_dev)
		if value >= min_val and value <= max_val:
			return value
	
	return target # unreachable
