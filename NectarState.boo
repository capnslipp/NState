## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


#import UnityEngine


class NectarState:
	[Getter(name)]
	_name as string
	
	
	def constructor(name as string):
		_name = name
	
	def constructor(name as string, entry as NectarEvent, exit as NectarEvent):
		self(name) # call the basic constructor
		
		self.entry = entry
		self.exit = exit
	
	
	public entry as NectarEvent
	
	public exit as NectarEvent
	