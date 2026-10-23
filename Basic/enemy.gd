extends Node3D

@export var weapon: Sword
@export var target: Node3D

@export_group("Movement")
@export var move_speed := 2.5
@export var near_distance := 3.0   # closer than this = combat mode
@export var min_distance := 1.2    # push never goes closer than this
@export_group("Combat timing")
@export var action_interval := Vector2(0.6, 1.8) # random seconds between attacks
@export var move_interval := Vector2(0.3, 0.9)   # random seconds per movement choice

enum Move { IDLE, BACK, SIDESTEP_LEFT, SIDESTEP_RIGHT, PUSH }

var _move: Move = Move.IDLE
var _move_timer := 0.0
var _action_timer := 1.0


func _process(delta: float) -> void:
	if target == null or weapon == null:
		return

	var to_target := target.global_position - global_position
	to_target.y = 0.0
	var distance := to_target.length()
	if distance < 0.01:
		return
	var dir := to_target / distance

	# Always face the player (-Z points at the target)
	look_at(global_position + dir, Vector3.UP)

	if distance > near_distance:
		# Far: walk towards the player
		global_position += dir * move_speed * delta
		_move = Move.IDLE
		_move_timer = 0.0
		return

	# Near: random movement + random attacks
	_update_movement(delta, dir, distance)
	_update_actions(delta)


func _update_movement(delta: float, dir: Vector3, distance: float) -> void:
	_move_timer -= delta
	if _move_timer <= 0.0:
		_move = [Move.IDLE, Move.BACK, Move.SIDESTEP_LEFT, Move.SIDESTEP_RIGHT, Move.PUSH].pick_random()
		_move_timer = randf_range(move_interval.x, move_interval.y)

	var right := dir.cross(Vector3.UP) # right-hand side relative to facing
	var velocity := Vector3.ZERO

	match _move:
		Move.BACK:
			velocity = -dir
		Move.SIDESTEP_LEFT:
			velocity = -right
		Move.SIDESTEP_RIGHT:
			velocity = right
		Move.PUSH:
			if distance > min_distance:
				velocity = dir * 1.5 # pushes in a bit faster

	global_position += velocity * move_speed * delta


func _update_actions(delta: float) -> void:
	_action_timer -= delta
	if _action_timer > 0.0:
		return
	_action_timer = randf_range(action_interval.x, action_interval.y)

	# Random direction (normalized Vec2) -> angle, same as the crosshair code
	var random_dir := Vector2.from_angle(randf_range(0.0, TAU))
	var angle := random_dir.angle_to(Vector2.RIGHT)

	match randi() % 3:
		0: weapon.attack(angle)
		1: weapon.parry()
		2: weapon.stab(angle)
