class_name StateMachine 
extends RefCounted

signal state_changed(from: State, to: State)

var states: Dictionary = {}
var current: State = null

var host

func _init(_host):
	host = _host

func add_state(state: State, _name: String):
	state.machine = self
	state.name = _name
	states[state.name] = state
	state.host = host

func add(state: State):
	add_state(state, state.get_script().get_global_name())

func has(state_name: StringName):
	return states.has(state_name)

func change_state(next: State):
	if next == null or next == current:
		return
	if not states.values().has(next):
		push_error("StateMachine: state not registered: %s" % next)
		return

	var from := current
	if current:
		current.exit()
	current = next
	current.enter()
	state_changed.emit(from, current)
	
func change(name: String):
	change_state(states.get(name))

func process(delta: float):
	if current: current.process(delta)

func name():
	if current: return current.name
