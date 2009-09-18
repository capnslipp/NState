## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
import UnityEngine


class NStateTransition (ScriptableObject):
	public trigger as NTriggerBase
	
	public targetState as NState
	public action as NEventAction
