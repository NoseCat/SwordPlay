extends Control

@export var body_diameter: float = 10.0
@export var outline_thickness: float = 2.0 # in pixels
@export var body_color: Color = Color.WHITE
@export var outline_color: Color = Color.BLACK

@export var arrow_length: float = 20.0

@onready var arrow = $Arrow

var direction: Vector2 = Vector2.ZERO

func _ready():
	var body = $CrosshairBody
	body.size = Vector2(body_diameter, body_diameter)
	body.position = Vector2(-body.size.x/2, -body.size.y/2)
	var material = ShaderMaterial.new()
	material.shader = load("res://crosshair_body.gdshader")
	var uv_outline = outline_thickness / body_diameter
	material.set_shader_parameter("fill_color", body_color)
	material.set_shader_parameter("outline_color", outline_color)
	material.set_shader_parameter("outline_thickness", uv_outline)
	body.material = material
	
	arrow.size = Vector2(body_diameter, arrow_length)
	arrow.position = Vector2(-arrow.size.x/2, -arrow.size.y)
	arrow.pivot_offset = -arrow.position

func _physics_process(delta: float) -> void:
	var mouse_vel = Input.get_last_mouse_velocity()
	if mouse_vel.length() > 0.1:  # ignore tiny movements/jitter
		mouse_vel = mouse_vel.normalized()
		arrow.rotation = -mouse_vel.angle_to(Vector2(0,-1))
		direction = mouse_vel
	# maybe it only moves a certain value toward that position dependent on how much mouse moved?
	get_direction_clamp()

func get_direction():
	return direction

var set_dirs = {
	"UP": Vector2(0,-1), 
	"UP_RIGHT": Vector2(1,-1).normalized(),
	"RIGHT": Vector2(1, 0),
	"DOWN_RIGHT": Vector2(1, 1).normalized(),
	"DOWN": Vector2(0,1),
	"DOWN_LEFT": Vector2(-1,1).normalized(),
	"LEFT": Vector2(-1, 0),
	"UP_LEFT": Vector2(-1, -1).normalized(),
	}

func get_direction_clamp():
	var dir = direction
	var max_allign = -1 #>2PI
	var dir_name = "UP"
	for key in set_dirs.keys():
		var set_dir = set_dirs[key]
		var allign = direction.dot(set_dir)
		if(allign > max_allign):
			max_allign = allign
			dir = set_dir
			dir_name = key
	return {"dir": dir, "name": dir_name}
