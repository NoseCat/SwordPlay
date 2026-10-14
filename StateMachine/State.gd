class_name State
extends RefCounted

var name: String
func init() -> void: pass
func enter() -> void: pass
func exit() -> void: pass
func process(delta: float) -> void: pass

var machine: StateMachine
var host

func change_state(next: Variant) -> void:
	machine.change_state(next)

func change(_name: String):
	machine.change_state(machine.states.get(_name))
