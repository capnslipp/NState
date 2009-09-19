## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
import UnityEngine


[Serializable]
class NStateMap:
	[Serializable]
	class Node:
		public state as NState
		public transitions as (NStateTransition)
	
	# must be public to be serialized
	public nodes as (Node) = array(Node, 0)
	
	
	
	def HasState(stateName as string) as bool:
		for node as Node in nodes:
			if node.state.name == stateName:
				return true
		
		return false
	
	private def HasState(state as NState) as bool:
		for node as Node in nodes:
			if node.state is state:
				return true
		
		return false
	
	
	def GetState(stateName as string) as NState:
		for node as Node in nodes:
			if node.state.name == stateName:
				return node.state
		
		return null
	
	
	def AddState(stateName as string) as NState:
		state = NState(name: stateName)
		return AddState(state)
	
	private def AddState(state as NState) as NState:
		assert not HasState(state.name)
		nodes += (Node(state: state, transitions: array(NStateTransition, 0)),)
		return state
	
	
	def RemoveState(stateName as string) as NState:
		state as NState = GetState(stateName)
		assert state is not null, "NState '${stateName}' couldn't be removed because it couldn't be found."
		return RemoveState(state)
	
	private def RemoveState(state as NState) as NState:
		assert HasState(state) # necessary?
		
		# find the state object that actually _is_ the state object passed in
		nodeIndex as int = Array.FindIndex(
			nodes,
			{ n as Node | n.state is state }
		)
		assert nodeIndex >= 0, "NState '${state.name}' couldn't be removed because it couldn't be found."
		
		# slice off everything before and everything after the element we want to remove and put that back as the new array
		nodes = nodes[:nodeIndex] + nodes[(nodeIndex + 1):]
		return state
	
	
	stateCount as int:
		get:
			# there should be one and only one node for each state
			return nodes.Length
	
	
	
	def HasTransition(forStateName as string, transitionName as string) as bool:
		assert HasState(forStateName)
		node as Node = GetNode(forStateName)
		
		return HasTransition(node.state, transitionName)
	
	private def HasTransition(forState as NState, transitionName as string) as bool:
		assert HasState(forState)
		node as Node = GetNode(forState)
		
		for nodeTransition as NStateTransition in node.transitions:
			if nodeTransition.name == transitionName:
				return true
		
		return false
	
	#private def HasTransition(forState as NState, transition as NStateTransition) as bool:
	#	assert HasState(forState)
	#	node as Node = GetNode(forState)
	#	
	#	for nodeTransition as NStateTransition in node.transitions:
	#		if nodeTransition is transition:
	#			return true
	#	
	#	return false
	
	
	def GetTransition(forStateName as string, transitionName as string) as NStateTransition:
		for transition as NStateTransition in GetTransitions(forStateName):
			if transition.name == transitionName:
				return transition
		
		return null
	
	def GetTransition(node as Node, transitionName as string) as NStateTransition:
		for transition as NStateTransition in node.transitions:
			if transition.name == transitionName:
				return transition
		
		return null
	
	def GetTransitions(forStateName as string) as (NStateTransition):
		assert HasState(forStateName)
		node as Node = GetNode(forStateName)
		
		return node.transitions
	
	
	def AddTransition(forStateName as string, transitionName as string) as NStateTransition:
		transition = ScriptableObject.CreateInstance('NStateTransition')
		transition.name = transitionName
		return AddTransition(forStateName, transition)
	
	private def AddTransition(forStateName as string, transition as NStateTransition) as NStateTransition:
		assert HasState(forStateName)
		node as Node = GetNode(forStateName)
		
		assert not HasTransition(forStateName, transition.name)
		node.transitions += (transition,)
		
		return transition
	
	
	def RemoveTransition(forStateName as string, transitionName as string) as NStateTransition:
		assert HasState(forStateName)
		node as Node = GetNode(forStateName)
		assert node is not null, "NStateTransition '${transitionName}' couldn't be removed because the NState '${forStateName}' couldn't be found."
		
		transition as NStateTransition = GetTransition(node, transitionName)
		assert transition is not null, "NStateTransition '${transitionName}' couldn't be removed because it couldn't be found in NState '${forStateName}'."
		return RemoveTransition(node, transition)
	
	def RemoveTransition(node as Node, transition as NStateTransition) as NStateTransition:
		#assert HasTransition(node.state, transition) # necessary?
		
		# find the transition object that actually _is_ the transition object passed in
		transitionIndex as int = Array.FindIndex(
			node.transitions,
			{ t as NStateTransition | t is transition }
		)
		assert transitionIndex >= 0, "NStateTransition '${transition.name}' couldn't be removed because it couldn't be found in NState '${node.state.name}'."
		
		# slice off everything before and everything after the element we want to remove and put that back as the new array
		node.transitions = node.transitions[:transitionIndex] + node.transitions[(transitionIndex + 1):]
		return transition
	
	
	
	private def GetNode(stateName as string) as Node:
		for node as Node in nodes:
			if node.state.name == stateName:
				return node
		
		return null
	
	private def GetNode(state as NState) as Node:
		for node as Node in nodes:
			if node.state is state:
				return node
		
		return null
