extends stateClass


func enterState():
	player = stateMachine.stateMachineOwner
	print("Slam")

func updatePhysics(delta):
	Transitioned.emit(self, "playerMoveState")
