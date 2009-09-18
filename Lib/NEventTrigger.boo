## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
#import UnityEngine


class NEventTrigger (NTriggerBase):
	public triggerEvent as Type
	
	
	def IsMet(stateMachine as NStateMachine) as bool:
		for anEvent as NEventBase in stateMachine.activeEvents:
			if anEvent.GetType() == triggerEvent:
				return true
		
		return false
