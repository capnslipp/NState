## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
import UnityEngine


[RequireComponent(NEventSocket)]
[RequireComponent(NEventPlug)]
class NStateMachine (MonoBehaviour):
	public map as NStateMap
	
	public initialState as string
	
	_currentState as NState
	currentState as string:
		get:
			return _currentState.name
	
	
	_eventSocket as NEventSocket
	
	[Getter(eventPlug)]
	_eventPlug as NEventPlug
	
	# only has data during the NTrigger check in the Update (null otherwise)
	[Getter(activeEvents)]
	_activeEvents as (NEventBase) = null
	
	
	def Awake():
		_eventSocket = GetComponent(NEventSocket)
		assert _eventSocket is not null
		
		_eventPlug = GetComponent(NEventPlug)
		assert _eventPlug is not null
		assert not _eventPlug.enabled, "The NEventPlug will be updated by this NStateMachine, therefore it must be enabled to prevent normal Update() calls."
	
	
	def Start():
		_currentState = map.GetState(initialState)
	
	
	def Update():
		_activeEvents = _eventSocket.Flush()
		
		# @todo: loop through the transitions and ask each one if it's conditions have been met
		
		_activeEvents = null
		
		_eventPlug.SendEvents()
