import UnityEngine

class NStateTestCaseRunner (MonoBehaviour):
	def Start():
		suite = UUnitTestSuite()
		
		suite.AddAll( NStateTest() )
		
		
		result = suite.Run(null)
		Debug.Log(result.Summary())
		
		#result = suite.RunAllowingExceptions(null)
		#Debug.Log(result.Summary())
		
		
		if result.failedCount > 0: # fail
			Camera.main.backgroundColor = Color.red
