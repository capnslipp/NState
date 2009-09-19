## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
#import UnityEngine


[Serializable]
class NStateMap:
	[Serializable]
	class Node:
		public state as NState
		public transitions as (NStateTransition)
	
	# must be public to be serialized
	public nodes as (Node) = array(Node, 0)
	
	
	stateCount as int:
		get:
			# there should be one and only one node for each state
			return nodes.Length
	
	
	
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
	
	
	def AddState(stateName as string) as NState:
		assert not HasState(stateName)
		
		state = NState(name: stateName)
		nodes += (Node(state: state, transitions: array(NStateTransition, 0)),)
		
		return state
	
	
	def RemoveState(stateName as string) as NState:
		# find the state object that has the same name as stateName
		stateNodeIndex as int = Array.FindIndex(
			nodes,
			{ n as Node | n.state.name == stateName }
		)
		assert stateNodeIndex >= 0, "NState '${stateName}' couldn't be removed because it couldn't be found."
		
		state as NState = nodes[stateNodeIndex].state
		
		# slice off everything before and everything after the element we want to remove and put that back as the new array
		nodes = nodes[:stateNodeIndex] + nodes[(stateNodeIndex + 1):]
		# the node we just sliced out should be garbage collected at this point
		
		return state
	
	
	
	def HasTransition(forStateName as string, transitionName as string) as bool:
		node as Node = GetNode(forStateName)
		
		for nodeTransition as NStateTransition in node.transitions:
			if nodeTransition.name == transitionName:
				return true
		
		return false
	
	
	def GetTransition(forStateName as string, transitionName as string) as NStateTransition:
		for transition as NStateTransition in GetTransitions(forStateName):
			if transition.name == transitionName:
				return transition
		
		return null
	
	def GetTransitions(forStateName as string) as (NStateTransition):
		node as Node = GetNode(forStateName)
		
		return node.transitions
	
	
	def AddTransition(forStateName as string, transitionName as string) as NStateTransition:
		assert not HasTransition(forStateName, transitionName)
		
		node as Node = GetNode(forStateName)
		
		transition = NStateTransition(name: transitionName)
		node.transitions += (transition,)
		
		return transition
	
	
	def RemoveTransition(forStateName as string, transitionName as string) as NStateTransition:
		node as Node = GetNode(forStateName)
		
		# find the transition object that has the same name as transitionName
		transitionIndex as int = Array.FindIndex(
			node.transitions,
			{ t as NStateTransition | t.name == transitionName }
		)
		assert transitionIndex >= 0, "NStateTransition '${transitionName}' couldn't be removed because it couldn't be found in NState '${forStateName}'."
		
		transition as NStateTransition = node.transitions[transitionIndex]
		
		# slice off everything before and everything after the element we want to remove and put that back as the new array
		node.transitions = node.transitions[:transitionIndex] + node.transitions[(transitionIndex + 1):]
		# the transition we just sliced out should be garbage collected at this point
		
		return transition
	
	
	
	private def GetNode(stateName as string) as Node:
		for node as Node in nodes:
			if node.state.name == stateName:
				return node
		
		assert false, "NState '${stateName}' couldn't be found."
