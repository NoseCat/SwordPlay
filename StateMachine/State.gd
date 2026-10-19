class_name State
extends RefCounted

var name: String
func init() -> void: pass
func enter() -> void: pass
func exit() -> void: pass
func process(delta: float) -> void: pass

var state: StateMachine
var host

func change_state(next: Variant) -> void:
	state.change_state(next)

func change(_name: String):
	state.change_state(state.states.get(_name))
