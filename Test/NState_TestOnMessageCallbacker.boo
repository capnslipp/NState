import UnityEngine


# can't use IQuackFu and QuackInvoke() because they don't get called from GameObject#SendMessage()
class NState_TestOnMessageCallbacker (MonoBehaviour):
	event callbacks as callable(string, (object))
	
	def OnNStateTest(args as (object)):
		callbacks('OnNStateTest', args)
