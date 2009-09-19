## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
#import System.Collections
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
	_stateCreateName as string = ''
	
	
	# only valid during OnInspectorGUI(); null otherwise
	_map as NStateMap = null
	
	
	def OnInspectorGUI():
		return if target.map is null
		_map = target.map
		
		
		#targetElementList as List = List(target.abilities as (NAbilityBase))
		#listHasBeenModified as bool = false
		#needsSort as bool = false
		
		
		# create field
		if LayOutCreateWidget():
			pass
			#needsSort = true
			#listHasBeenModified = true
		
		
		# initial state field
		resultInitialState = LayOutInitialStateWidget(target.initialState)
		if resultInitialState != target.initialState:
			target.initialState = resultInitialState
		
		
		# element fields
		for stateNode as NStateMap.Node in _map.nodes:
			state as NState = stateNode.state
			
			resultElement as NState = LayOutStateElement(state)
			EditorGUILayout.Separator()
			
			if resultElement is not null and resultElement is not state:
				#listHasBeenModified = true
				state = resultElement # this actually won't do anything if the resultElement is a different type (i.e null)
		
		
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
		
		
		_map = null
	
	
	private def LayOutStateElement(element as NState) as NState:
		EditorGUILayout.BeginHorizontal()
		
		EditorGUILayout.Foldout(true, "${element.name} State")
		#GUILayout.Label(element.name)
		
		destroyPressed as bool = GUILayout.Button('Destory', GUILayout.Width(60))
		
		EditorGUILayout.EndHorizontal()
		
		if destroyPressed:
			_stateElementsToRemove += (element,)
			return null
		else:
			element = LayOutStateElementFields(element)
			return element
	
	
	private def LayOutStateElementFields(element as NState) as NState:
		# name
		
		EditorGUILayout.BeginHorizontal()
		
		GUILayout.Label('Name', kLabelStyle)
		
		resultElementName as string = EditorGUILayout.TextField(element.name)
		if StateNameIsValid(resultElementName, element.name):
			element.name = resultElementName
		
		EditorGUILayout.EndHorizontal()
		
		
		# entry action
		
		EditorGUILayout.BeginHorizontal()
		GUILayout.Label('Entry Action', kLabelStyle)
		NEditorGUILayout.AutoField(element.entryAction)
		EditorGUILayout.EndHorizontal()
		
		
		# exit action
		
		EditorGUILayout.BeginHorizontal()
		GUILayout.Label('Exit Action', kLabelStyle)
		NEditorGUILayout.AutoField(element.exitAction)
		EditorGUILayout.EndHorizontal()
		
		
		return element
	
	
	#private def LayOutTransitionElementFields(element as NAbilityBase) as NAbilityBase:
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
	#	return element
	
	
	private def LayOutCreateWidget() as bool:
		didCreate as bool
		
		EditorGUILayout.BeginHorizontal()
		
		_stateCreateName = EditorGUILayout.TextField(_stateCreateName)
		
		# @todo: ideally, disable the button when the name is not valid
		createPressed as bool = GUILayout.Button('Create State', GUILayout.Width(80))
		
		if createPressed:
			if StateNameIsValid(_stateCreateName):
				_map.AddState(_stateCreateName)
				_stateCreateName = ''
				didCreate = true
		
		EditorGUILayout.EndHorizontal()
		
		return didCreate
	
	
	private def LayOutInitialStateWidget(initialStateName as string) as string:
		EditorGUILayout.BeginHorizontal()
		
		GUILayout.Label('Initial State', kLabelStyle)
		
		stateNames as (string) = GetStateNames()
		
		selectionIndex as int = Array.FindIndex(
			stateNames,
			{ n as string | n == initialStateName }
		)
		newSelectionIndex as int = EditorGUILayout.Popup(
			selectionIndex,
			GetStateNames()
		)
		
		EditorGUILayout.EndHorizontal()
		
		if newSelectionIndex < 0:
			return null
		else:
			return stateNames[newSelectionIndex]
	
	
	
	# utility
	
	
	private def StateNameIsValid(stateName as string) as bool:
		return not String.IsNullOrEmpty(stateName) and not _map.HasState(stateName)
	
	
	private def StateNameIsValid(stateName as string, exceptName as string) as bool:
		return stateName == exceptName or StateNameIsValid(stateName)
	
	
	private def GetStateNames() as (string):
		stateNames as (string) = array(string, 0)
		
		for stateNode as NStateMap.Node in _map.nodes:
			stateNames += (stateNode.state.name,)
		
		return stateNames
