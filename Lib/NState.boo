## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Reflection
import UnityEngine


class NState (ScriptableObject):
	def constructor(stateName as string):
		name = stateName
	
	def constructor(stateName as string, entryAction as NEventAction, exitAction as NEventAction):
		self(stateName) # call the basic constructor
		
		self.entryAction = entryAction
		self.exitAction = exitAction
	
	
	public entryAction as NEventAction
	
	public exitAction as NEventAction
	