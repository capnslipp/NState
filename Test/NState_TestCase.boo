#import UnityEngine



class NState_TestCase (UUnitTestCase):
	testCaseEvent as NEventAction
	
	
	def SetUp():
		testCaseEvent = NEventAction(NState_TestEvent)
	
	
	[UUnitTest]
	def TestStateCreation():
		aState = NState(name: 'BlahA')
		UUnitAssert.EqualString('BlahA', aState.name, "")
		
		bState = NState(name: 'BlahB', entryAction: testCaseEvent, exitAction: testCaseEvent)
		UUnitAssert.EqualString('BlahB', bState.name, "")
		
