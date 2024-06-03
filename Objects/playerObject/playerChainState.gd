extends stateClass


func enterState():
	player = stateMachine.stateMachineOwner
	print("Chain")

func updatePhysics(delta):
	Transitioned.emit(self, "playerMoveState")
