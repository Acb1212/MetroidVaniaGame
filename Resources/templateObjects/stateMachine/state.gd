extends Node2D
class_name stateClass

var stateMachine: stateMachineClass;
var player: CharacterBody2D;

signal Transitioned

func enterState():
	pass;

func exitState():
	pass;

func update(_delta):
	pass;

func updatePhysics(_delta):
	pass;
