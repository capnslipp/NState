import UnityEngine

class NState_TestCaseRunner (MonoBehaviour):
	def Awake():
		Camera.main.backgroundColor = Color.green
	
	
	def Start():
		suite = UUnitTestSuite()
		
		suite.AddAll( NState_TestCase() )
		
		
		result = suite.Run(null)
		Debug.Log(result.Summary())
		
		#result = suite.RunAllowingExceptions(null)
		#Debug.Log(result.Summary())
		
		
		if result.failedCount > 0: # fail
			Camera.main.backgroundColor = Color.red
