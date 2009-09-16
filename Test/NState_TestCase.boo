#import UnityEngine



class NState_TestCase (UUnitTestCase):
	testCaseEvent as NEventAction
	
	
	def SetUp():
		testCaseEvent = NEventAction(NState_TestEvent)
	
	
	[UUnitTest]
	def TestStateCreation():
		aState = NState('BlahA')
		UUnitAssert.EqualString('BlahA', aState.name, "")
		
		bState = NState('BlahB', testCaseEvent, testCaseEvent)
		UUnitAssert.EqualString('BlahB', bState.name, "")
		
