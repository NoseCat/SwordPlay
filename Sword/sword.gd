class_name Sword
extends Marker3D

#stats
@export var swing_windup_time := 0.5
@export var stab_windup_time := 0.25
@export var parry_windup_time := 0.1
@export var winddown_time := 1.0 #maybe per action
@export var swing_speed := 5.0
@export_custom(PROPERTY_HINT_NONE, "radians_as_degrees") var max_swing_angle := deg_to_rad(150)
@export var stab_speed := 5.0
@export var parry_time := 0.5

#const parts
@export var sword : Node3D
@export var right_hand_rest_pos : Marker3D
@export var left_hand_rest_pos : Marker3D
@export var anim_player: AnimationPlayer

#interaction nodes
@export var camera: Node3D 
@export var crosshair: Control

#poses
@onready var pivot_idle_q: Quaternion = self.quaternion
@onready var sword_idle_t: Transform3D = $IdleTransform.transform
@onready var sword_swing_t: Transform3D = $SwingTransform.transform
@onready var sword_stab_t: Transform3D = $StabTransform.transform
@onready var sword_stab_strike_t: Transform3D = $StabStrikeTransform.transform
@onready var parry_t: Transform3D = $ParryTransform.transform

#variables
@onready var pivot_q := pivot_idle_q
@onready var sword_t = sword_idle_t
var state: StateMachine
var pivot_tween: Tween
var sword_tween: Tween

#?
var pivot_swing_q := Quaternion()
var swing_angle := 0.0 # how far are we into swing 


func _ready() -> void:
	state = StateMachine.new(self) #creating state machine with this object as a host
	state.add(Idle.new())
	state.add(SwingWindup.new())
	state.add(Swing.new())
	state.add(Winddown.new())
	state.add(StabWindup.new())
	state.add(Stab.new())
	state.add(ParryWindup.new())
	state.add(Parry.new())
	state.change("Idle")


func _process(delta: float) -> void:
	state.process(delta)
	apply_pose()

func apply_pose() -> void:
	var camera_q = (Quaternion(Vector3.UP, camera.rotation.y) * Quaternion(Vector3.RIGHT, camera.rotation.x))
	quaternion = camera_q * pivot_q
	sword.transform = sword_t


func attack() -> void:
	var crosshair_angle = crosshair.get_direction().angle_to(Vector2.RIGHT)
	pivot_swing_q = Quaternion(Vector3.FORWARD, -crosshair_angle).normalized()

	state.change("SwingWindup")
	
func stab() -> void:
	var crosshair_angle = crosshair.get_direction().angle_to(Vector2.RIGHT)
	pivot_swing_q = Quaternion(Vector3.FORWARD, -crosshair_angle).normalized()

	state.change("StabWindup")

func parry() -> void:
	var crosshair_angle = crosshair.get_direction().angle_to(Vector2.RIGHT)
	pivot_swing_q = Quaternion(Vector3.FORWARD, -crosshair_angle).normalized()

	state.change("ParryWindup")


func stop_swing() -> void:
	pass
	#state.change("Winddown") #temporary


#pose
func tween_pivot(target: Quaternion,time: float, trans := Tween.TRANS_LINEAR, tween_ease := Tween.EASE_IN_OUT):
	if pivot_tween: pivot_tween.kill()
	pivot_tween = create_tween()
	pivot_tween.tween_property(self, "pivot_q", target, time).set_trans(trans).set_ease(tween_ease)
	return pivot_tween

func tween_sword(target: Transform3D, time: float, trans := Tween.TRANS_LINEAR, tween_ease := Tween.EASE_IN_OUT):
	if sword_tween: sword_tween.kill()
	sword_tween = create_tween()
	sword_tween.tween_property(self, "sword_t", target, time).set_trans(trans).set_ease(tween_ease)
	return sword_tween

# func animate(anim_name: StringName, time := 1.0, blend := 0.0):
# 	var speed := 1.0
# 	speed = anim_player.get_animation(anim_name).length / time

# 	anim_player.play(anim_name, blend, speed)

func stop_anims() -> void:
	if pivot_tween: pivot_tween.kill()
	if sword_tween: sword_tween.kill()
	#if anim_player.is_playing(): anim_player.stop(true)


#signals
func _on_blade_area_entered(area: Area3D) -> void:
	if area.get_collision_layer_value(2):
		var packed_scene = preload("res://Blood/blood_spatter.tscn")
		var instance = packed_scene.instantiate()
		add_child(instance)
		var col = $SwordGrip/Blade/RayCast3D.get_collision_point()
		instance.top_level = true
		instance.global_position = col
		instance.quaternion = quaternion

func _on_blade_body_entered(body: Node3D) -> void:
	if body.get_collision_layer_value(1):
		stop_swing()
