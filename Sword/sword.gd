extends Marker3D

#stats
@export var windup_time := 0.5
@export var winddown_time := 1.0
@export var swing_speed := 5.0
@export var max_swing_angle := deg_to_rad(150)

#parts
@onready var camera := $"../Camera"
@onready var crosshair := $"../Crosshair"
@onready var sword := $SwordGrip

#anim
@export var idle_pos: Node 
@export var idle_q: Quaternion = Quaternion()
@export var swing_pos: Node 
@onready var anim_player = $AnimationPlayer

var local_q := Quaternion()
@onready var sword_transform = sword.transform

var state: StateMachine

var swing_dir_q := Quaternion() # swing axis
var swing_angle := 0.0

func _ready() -> void:
	state = StateMachine.new(self) #creating state machine with this object as a host
	state.add(SwordIdle.new())
	state.add(SwordWindup.new())
	state.add(SwordSwing.new())
	state.add(SwordWinddown.new())
	state.change("SwordIdle")

func _process(delta: float) -> void:
	state.process(delta)

	var camera_q = (Quaternion(Vector3.UP, camera.rotation.y) * Quaternion(Vector3.RIGHT, camera.rotation.x))
	quaternion = camera_q * local_q
	sword.transform = sword_transform

func attack() -> void:
	state.change("SwordWindup")

func stop_swing() -> void:
	state.change("SwordWinddown") #temporary

func _on_blade_area_entered(area: Area3D) -> void:
	if area.get_collision_layer_value(2):
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
