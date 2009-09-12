## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


#import UnityEngine


class NectarState:
	[Getter(name)]
	_name as string
	
	
	def constructor(name as string):
		_name = name
	
	def constructor(name as string, entryAction as NectarEvent, exitAction as NectarEvent):
		self(name) # call the basic constructor
		
		self.entryAction = entryAction
		self.exitAction = exitAction
	
	
	public entryAction as NectarEvent
	
	public exitAction as NectarEvent
	