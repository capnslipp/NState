## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
#import UnityEngine


[Serializable]
class NState:
	public name as string
	
	public entryAction as NEventAction
	public exitAction as NEventAction
