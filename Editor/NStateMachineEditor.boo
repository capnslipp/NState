## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
import System.Collections
import System.Reflection
import UnityEditor
import UnityEngine


[CustomEditor(NStateMachine)]
class NStateMachineEditor (Editor):
	static final kPubFieldBindingFlags as BindingFlags = BindingFlags.Public | BindingFlags.Instance
	#static final kPrivFieldBindingFlags as BindingFlags = BindingFlags.NonPublic | BindingFlags.Instance
	#static final kPubAndPrivFieldBindingFlags as BindingFlags = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance
	#static final kPropertyBindingFlags as BindingFlags = BindingFlags.Public | BindingFlags.Instance
	
	static final kLabelStyle as GUIStyle
	
	static def constructor():
		kLabelStyle = GUIStyle(
			margin: RectOffset(left: 20),
			padding: RectOffset(),
			alignment: TextAnchor.MiddleLeft,
			fixedWidth: 150,
			stretchWidth: false
		)
	
	
	_stateElementsToRemove as (NState) = array(NState, 0)
	_stateCreateName as string = ""
	
	
	def OnInspectorGUI():
		#targetElementList as List = List(target.abilities as (NAbilityBase))
		#listHasBeenModified as bool = false
		#needsSort as bool = false
		
		return if target.map is null
		
		
		# create field
		if LayOutCreateWidget(target.map):
			pass
			#needsSort = true
			#listHasBeenModified = true
		
		
		# element fields
		for stateNode as NStateMap.Node in target.map.nodes:
			#EditorGUILayout.Separator()
			resultElement = LayOutStateElement(stateNode.state)
			EditorGUILayout.Separator()
			if resultElement is not stateNode.state:
				#listHasBeenModified = true
				stateNode.state = resultElement
		
		
		# clean up: destory objects that were marked to be removed
		if _stateElementsToRemove.Length != 0:
			for removeStateElement as NState in _stateElementsToRemove:
				target.map.RemoveState(removeStateElement.name)
			
			_stateElementsToRemove = array(NState, 0)
		
		
		#if listHasBeenModified:
		#	if needsSort:
		#		targetElementList.Sort(TypeNameSortComparer())
		#	
		#	# send the array back
		#	target.abilities = array(NAbilityBase, targetElementList)
	
	
	private def LayOutStateElement(element as NState) as NState:
		EditorGUILayout.BeginHorizontal()
		
		EditorGUILayout.Foldout(true, element.name)
		#GUILayout.Label(element.name)
		
		destroyPressed as bool = GUILayout.Button('Destory', GUILayout.Width(60))
		
		EditorGUILayout.EndHorizontal()
		
		if destroyPressed:
			_stateElementsToRemove += (element,)
			return null
		else:
			#element = LayOutElementFields(element)
			return element
	
	
	#private def LayOutElementFields(element as NAbilityBase) as NAbilityBase:
	#	origValue as object
	#	resultValue as object
	#	
	#	pubElementFields as (FieldInfo) = element.GetType().GetFields(kPubFieldBindingFlags)
	#	for field as FieldInfo in pubElementFields:
	#		if typeof(NAbilityBase).GetField(field.Name, kPubFieldBindingFlags):
	#			continue
	#		
	#		EditorGUILayout.BeginHorizontal()
	#		GUILayout.Label(ObjectNames.NicifyVariableName(field.Name), kLabelStyle)
	#		
	#		origValue = field.GetValue(element)
	#		resultValue = NEditorGUILayout.AutoField(origValue)
	#		#if resultValue.GetType() == origValue.GetType():
	#		try:
	#			field.SetValue(element, resultValue)
	#		except e as Exception:
	#			pass
	#		
	#		EditorGUILayout.EndHorizontal()
	#	
	#	# private fields get set back to 0 when the game starts (probably a Unity thing)
	#	#privElementFields as (FieldInfo) = element.GetType().GetFields(kPrivFieldBindingFlags)
	#	#for field as FieldInfo in privElementFields:
	#	#	if typeof(NReactionBase).GetField(field.Name, kPubAndPrivFieldBindingFlags):
	#	#		continue
	#	#	
	#	#	EditorGUILayout.BeginHorizontal()
	#	#	GUILayout.Label("(initial) ${ObjectNames.NicifyVariableName(field.Name)}", kLabelStyle)
	#	#	
	#	#	origValue = field.GetValue(element)
	#	#	resultValue = NEditorGUILayout.AutoField(origValue)
	#	#	#if resultValue.GetType() == field.GetType():
	#	#	try:
	#	#		field.SetValue(element, resultValue)
	#	#	except e as Exception:
	#	#		pass
	#	#	
	#	#	EditorGUILayout.EndHorizontal()
	#	
	#	# setting properties cause all kind of problems since the property can trigger other stuff to happen
	#	#elementProperties as (PropertyInfo) = element.GetType().GetProperties(kPropertyBindingFlags)
	#	#for property as PropertyInfo in elementProperties:
	#	#	if typeof(NAbilityBase).GetProperty(property.Name, kPropertyBindingFlags):
	#	#		continue
	#	#	
	#	#	EditorGUILayout.BeginHorizontal()
	#	#	EditorGUILayout.PrefixLabel(ObjectNames.NicifyVariableName(property.Name))
	#	#	
	#	#	origValue = property.GetValue(element, null)
	#	#	resultValue = NEditorGUILayout.AutoField(origValue)
	#	#	if resultValue.GetType() == origValue.GetType():
	#	#		property.SetValue(element, resultValue, null)
	#	#	
	#	#	EditorGUILayout.EndHorizontal()
	#	#	EditorGUILayout.Separator()
	#	
	#	return element
	
	
	private def LayOutCreateWidget(map as NStateMap) as bool:
		didCreate as bool
		
		EditorGUILayout.BeginHorizontal()
		
		_stateCreateName = EditorGUILayout.TextField(_stateCreateName)
		
		# @todo: ideally, disable the button when the name is not valid
		createPressed as bool = GUILayout.Button('Create State', GUILayout.Width(80))
		
		if createPressed:
			if StateCreateNameIsValid(map):
				map.AddState(_stateCreateName)
				_stateCreateName = ""
				didCreate = true
		
		EditorGUILayout.EndHorizontal()
		
		return didCreate
	
	private def StateCreateNameIsValid(map as NStateMap) as bool:
		return not String.IsNullOrEmpty(_stateCreateName) and not map.HasState(_stateCreateName)
	
	
	class TypeNameSortComparer (IComparer):
		def IComparer.Compare(early as object, late as object) as int:
			if early.GetType() == late.GetType():
				return (early as UnityEngine.Object).GetInstanceID().CompareTo(
					(late as UnityEngine.Object).GetInstanceID()
				)
			else:
				return early.GetType().Name.CompareTo(
					late.GetType().Name
				)
