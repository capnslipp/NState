## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
import UnityEngine


class NStateMap (ScriptableObject):
	private struct Node:
		state as NState
		transitions as (NStateTransition)
	
	public nodes as (Node) = array(Node, 0)
	
	
	def HasState(stateName as string) as bool:
		for node as Node in nodes:
			if node.state.name == stateName:
				return true
		
		return false
	
	def GetState(stateName as string) as NState:
		for node as Node in nodes:
			if node.state.name == stateName:
				return node.state
		
		return null
	
	def AddState(stateNameToAdd as string) as NState:
		state = ScriptableObject.CreateInstance('NState')
		state.name = stateNameToAdd
		return AddState(state)
	
	def AddState(stateToAdd as NState) as NState:
		assert not HasState(stateToAdd.name)
		nodes += (Node(state: stateToAdd),)
		return stateToAdd
	
	stateCount as int:
		get:
			# there should be one and only one node for each state
			return nodes.Length
	
	
	
	def HasTransitionForState(stateName as string, transitionName as string) as bool:
		assert HasState(stateName)
		node as Node = GetNodeForState(stateName)
		
		for transition as NStateTransition in node.transitions:
			if transition.name == transitionName:
				return true
		
		return false
	
	def GetTransitionForState(stateName as string, transitionName as string) as NStateTransition:
		for transition as NStateTransition in GetTransitionsForState(stateName):
			if transition.name == transitionName:
				return transition
		
		return null
	
	def GetTransitionsForState(stateName as string) as (NStateTransition):
		assert HasState(stateName)
		node as Node = GetNodeForState(stateName)
		
		return node.transitions
	
	def AddTransition(fromStateName as string, transitionNameToAdd as string) as NStateTransition:
		transition = ScriptableObject.CreateInstance('NStateTransition')
		transition.name = transitionNameToAdd
		return AddTransition(fromStateName, transition)
	
	def AddTransition(fromStateName as string, transitionToAdd as NStateTransition) as NStateTransition:
		assert HasState(fromStateName)
		node as Node = GetNodeForState(fromStateName)
		
		node.transitions = array(NStateTransition, 0) if node.transitions is null
		assert not HasTransitionForState(fromStateName, transitionToAdd.name)
		node.transitions += (transitionToAdd,)
		
		return transitionToAdd
	
	
	
	private def GetNodeForState(stateName as string) as Node:
		for node as Node in nodes:
			if node.state.name == stateName:
				return node
		assert false, "node for State ${stateName} could not be found"
	
	#private def GetNodeForState(state as NState) as Node:
	#	for node as Node in nodes:
	#		if node.state is state:
	#			return node
	#	assert false, "node for State ${state.name} could not be found"
