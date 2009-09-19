## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
#import UnityEngine


class NCallbackTrigger (NTriggerBase):
	private callable TriggerCallable(stateMachine as NStateMachine) as bool
	
	public callback as TriggerCallable
	
	
	def IsMet(stateMachine as NStateMachine) as bool:
		return callback(stateMachine)
