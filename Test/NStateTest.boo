#import UnityEngine



class NStateTest (UUnitTestCase):
	testCaseEvent as NEventAction
	
	
	def SetUp():
		testCaseEvent = NEventAction( NStateTestEvent(value: 7) )
	
	
	[UUnitTest]
	def TestStateCreation():
		aState = NState('BlahA')
		UUnitAssert.EqualString('BlahA', aState.name, "")
		
		bState = NState('BlahB', testCaseEvent, testCaseEvent)
		UUnitAssert.EqualString('BlahB', bState.name, "")
		
