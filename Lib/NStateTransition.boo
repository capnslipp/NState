## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


#import UnityEngine


class NectarStateTransition:
	[Getter(name)]
	_name as string
	
	public target as NectarState
	
	public action as NectarEvent
	
	
	def constructor(name as string):
		_name = name
