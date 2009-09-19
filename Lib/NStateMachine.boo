## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
import UnityEngine


[RequireComponent(NEventSocket)]
[RequireComponent(NEventPlug)]
class NStateMachine (MonoBehaviour):
	# map
	
	public map as NStateMap
	
	
	# states/transitions
	
	public initialState as string
	
	_currentState as NState
	currentState as string:
		get:
			return _currentState.name
	
	_currentStateTransitions as (NStateTransition)
	
	
	# event socket/plug
	
	_eventSocket as NEventSocket
	
	[Getter(eventPlug)]
	_eventPlug as NEventPlug
	
	
	def Awake():
		_eventSocket = GetComponent(NEventSocket)
		assert _eventSocket is not null
		
		_eventPlug = GetComponent(NEventPlug)
		assert _eventPlug is not null
		_eventPlug.enabled = false
	
	def Start():
		# make sure the NEventPlug wasn't re-enabled
		assert not _eventPlug.enabled, "The NEventPlug will be updated by this NStateMachine, therefore it must be disabled to prevent normal Update() calls."
		
		# make sure the NEventPlug wasn't re-enabled
		assert map is not null, "\"map\" was null; an instance of a NStateMap is required by this NStateMachine."
		assert map.stateCount > 0, "There must be at least one State for the StateMap to be usable."
		
		state as NState = map.GetState(initialState)
		assert state is not null, "Could not find initial state \"${initialState}\" in the state map."
		LoadState(state)
	
	
	## only has data during the NCondition check in the Update (null otherwise)
	[Getter(activeEvents)]
	_activeEvents as (NEventBase) = null
	
	def Update():
		_activeEvents = _eventSocket.Flush()
		
		# loop through the transitions and ask each one if it's conditions have been met
		for transition as NStateTransition in _currentStateTransitions:
			if transition.condition.IsMet(self):
				DoTransition(transition)
				break
		
		_activeEvents = null
		
		_eventPlug.SendEvents()
	
	
	
	private def LoadState([Required(state is not null)] state as NState) as void:
		_currentState = state
		_currentStateTransitions = map.GetTransitionsForState(_currentState.name)
	
	private def EnterCurrentState() as void:
		if _currentState.entryAction is not null:
			_currentState.entryAction.Send(gameObject)
	
	private def ExitCurrentState() as void:
		if _currentState.exitAction is not null:
			_currentState.exitAction.Send(gameObject)
	
	
	private def DoTransition([Required(transition is not null)] transition as NStateTransition) as void:
		transition.action.Send(gameObject)
		
		ExitCurrentState()
		LoadState(transition.targetState)
		EnterCurrentState()
