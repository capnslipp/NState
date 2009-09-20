## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
#import UnityEngine


class NCallbackCondition (NConditionBase):
	callable ConditionCallable(stateMachine as NStateMachine) as bool
	
	public callback as ConditionCallable
	
	
	def IsMet(stateMachine as NStateMachine) as bool:
		if callback is null:
			return false
		else:
			return callback(stateMachine)
