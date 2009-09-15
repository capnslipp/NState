## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import UnityEngine


class NStateMap (ScriptableObject):
	[Getter(name)]
	_name as string
	
	
	def constructor(name as string):
		_name = name
	
	
	_states as Hash
	_transitions as Hash
	
	
	def GetStateNames() as (string):
		return array(_states.Keys)
	
	def GetState(stateName as string) as NState:
		return _states[stateName]
	
	def AddState(stateToAdd as NState) as void:
		assert not _states.ContainsKey(stateToAdd.name)
		_states[stateToAdd.name] = stateToAdd
	
	
	def AddTransition(fromStateName as string, transitionToAdd as NStateTransition) as void:
		if not _transitions.ContainsKey(fromStateName):
			_transitions[fromStateName] = (transitionToAdd,)
		else:
			_transitions[fromStateName] = _transitions[fromStateName] as (NStateTransition) + (transitionToAdd,)
	
	def GetTransitionsForState(stateName as string) as (NStateTransition):
		return _transitions[stateName]
