## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
import UnityEngine


class NStateTransition (ScriptableObject):
	[Getter(name)]
	_name as string
	
	public target as NState
	
	public action as NEventAction
	
	
	def constructor(name as string):
		_name = name
