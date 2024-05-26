extends Node2D
class_name stateMachineClass

@export var stateMachineOwner: CharacterBody2D
@export var initialState : stateClass

var currentState : stateClass
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is stateClass:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
			child.stateMachine = self
	if initialState:
		initialState.enterState()
		currentState = initialState

func _process(delta):
	if currentState:
		currentState.update(delta)

func _physics_process(delta):
	if currentState:
		currentState.updatePhysics(delta)

func on_child_transition(state, newStateName):
	if state != currentState:
		return
	
	var newState = states.get(newStateName.to_lower())
	if !newState:
		return
	
	if currentState:
		currentState.exitState()
	
	newState.enterState()
	
	currentState = newState
