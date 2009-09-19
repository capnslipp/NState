## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


#import System
#import System.Reflection
#import UnityEngine


abstract class NConditionBase (UnityEngine.ScriptableObject):
	abstract def IsMet(stateMachine as NStateMachine) as bool:
		pass
