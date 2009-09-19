## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
#import UnityEngine


[Serializable]
class NStateTransition:
	public name as string
	
	public condition as NConditionBase
	
	public action as NEventAction
	
	public targetState as NState
