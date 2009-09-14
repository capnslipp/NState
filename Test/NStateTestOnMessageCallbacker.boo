import UnityEngine


# can't use IQuackFu and QuackInvoke() because they don't get called from GameObject#SendMessage()
class NStateTestOnMessageCallbacker (MonoBehaviour):
	event callbacks as callable(string, (object))
	
	def OnNStateTest(args as (object)):
		callbacks('OnNStateTest', args)
