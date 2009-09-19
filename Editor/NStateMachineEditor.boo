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
	static final kIndentStyle as GUIStyle
	
	static def constructor():
		kLabelStyle = GUIStyle(
			margin: RectOffset(left: 20),
			padding: RectOffset(),
			alignment: TextAnchor.MiddleLeft,
			fixedWidth: 150,
			stretchWidth: false
		)
		kIndentStyle = GUIStyle(
			margin: RectOffset(left: 35),
			padding: RectOffset()
		)
	
	
	_stateElementsToRemove as (NState) = array(NState, 0)
	
	struct StateTransitionRemovalData:
		forState as NState
		transition as NStateTransition
	_stateTransitionElementsToRemove as (StateTransitionRemovalData) = array(StateTransitionRemovalData, 0)
	
	
	_stateCreateName as string = ''
	_transitionCreateName as string = ''
	
	
	# only valid during OnInspectorGUI(); null otherwise
	_map as NStateMap = null
	
	
	def OnInspectorGUI():
		return if target.map is null
		_map = target.map
		
		
		#targetElementList as List = List(target.abilities as (NAbilityBase))
		#listHasBeenModified as bool = false
		#needsSort as bool = false
		
		
		# create field
		LayOutCreateStateWidget()
		
		
		# initial state field
		resultInitialState as string = StateWidget('Initial State', target.initialState)
		if resultInitialState != target.initialState:
			target.initialState = resultInitialState
		
		
		# element fields
		for stateNode as NStateMap.Node in _map.nodes:
			# Node#state
			
			state as NState = stateNode.state
			LayOutStateElement(state)
			
			
			# Node#transitions
			
			transitions as (NStateTransition) = stateNode.transitions
			LayOutTransitions(state, transitions)
			
			
			EditorGUILayout.Separator()
		
		
		# clean up: destory objects that were marked to be removed
		
		if _stateElementsToRemove.Length > 0:
			for removeStateElement as NState in _stateElementsToRemove:
				target.map.RemoveState(removeStateElement.name)
			
			_stateElementsToRemove = array(NState, 0)
			
		if _stateTransitionElementsToRemove.Length > 0:
			for removeStateElement as StateTransitionRemovalData in _stateTransitionElementsToRemove:
				target.map.RemoveTransition(removeStateElement.forState.name, removeStateElement.transition.name)
			
			_stateTransitionElementsToRemove = array(StateTransitionRemovalData, 0)
		
		
		
		#if listHasBeenModified:
		#	if needsSort:
		#		targetElementList.Sort(TypeNameSortComparer())
		#	
		#	# send the array back
		#	target.abilities = array(NAbilityBase, targetElementList)
		
		
		_map = null
	
	
	private def StateWidget(label as string, stateName as string) as string:
		EditorGUILayout.BeginHorizontal()
		
		GUILayout.Label(label, kLabelStyle)
		
		stateNames as (string) = GetStateNames()
		
		selectionIndex as int = Array.FindIndex(
			stateNames,
			{ n as string | n == stateName }
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
	
	
	private def LayOutCreateStateWidget() as void:
		EditorGUILayout.BeginHorizontal()
		
		_stateCreateName = EditorGUILayout.TextField(_stateCreateName)
		
		# @todo: ideally, disable the button when the name is not valid
		createPressed as bool = GUILayout.Button('Create State', GUILayout.Width(80))
		
		if createPressed:
			if StateNameIsValid(_stateCreateName):
				_map.AddState(_stateCreateName)
				_stateCreateName = ''
		
		EditorGUILayout.EndHorizontal()
	
	
	private def LayOutStateElement(element as NState) as void:
		EditorGUILayout.BeginHorizontal()
		
		EditorGUILayout.Foldout(true, "${element.name} State")
		#GUILayout.Label(element.name)
		
		destroyPressed as bool = GUILayout.Button('Destroy', GUILayout.Width(60))
		
		EditorGUILayout.EndHorizontal()
		
		if destroyPressed:
			_stateElementsToRemove += (element,)
		else:
			LayOutStateElementFields(element)
	
	
	private def LayOutStateElementFields(element as NState) as void:
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
		element.entryAction = NEventEditorGUILayout.EventActionField(element.entryAction)
		EditorGUILayout.EndHorizontal()
		
		
		# exit action
		
		EditorGUILayout.BeginHorizontal()
		GUILayout.Label('Exit Action', kLabelStyle)
		element.exitAction = NEventEditorGUILayout.EventActionField(element.exitAction)
		EditorGUILayout.EndHorizontal()
	
	
	private def LayOutTransitions(forState as NState, elements as (NStateTransition)) as void:
		EditorGUILayout.BeginHorizontal()
		
		#EditorGUILayout.Foldout(true, 'Transitions')
		GUILayout.Label('Transitions', kLabelStyle)
		
		EditorGUILayout.EndHorizontal()
		
		
		EditorGUILayout.BeginVertical(kIndentStyle) # indent group
		
		# create field
		LayOutCreateTransitionWidget(forState)
		
		
		for element as NStateTransition in elements:
			LayOutTransitionElement(forState, element)
		
		
		EditorGUILayout.EndVertical() # indent group
	
	
	private def LayOutCreateTransitionWidget(forState as NState) as void:
		EditorGUILayout.BeginHorizontal()
		
		_transitionCreateName = EditorGUILayout.TextField(_transitionCreateName)
		
		# @todo: ideally, disable the button when the name is not valid
		createPressed as bool = GUILayout.Button('Create Transition', GUILayout.Width(110))
		
		if createPressed:
			if TransitionNameIsValid(_transitionCreateName):
				_map.AddTransition(forState.name, _transitionCreateName)
				_transitionCreateName = ''
		
		EditorGUILayout.EndHorizontal()
	
	
	private def LayOutTransitionElement(forState as NState, element as NStateTransition) as void:
		EditorGUILayout.BeginHorizontal()
		
		EditorGUILayout.Foldout(true, "Transition ${element.name}")
		#GUILayout.Label(element.name)
		
		destroyPressed as bool = GUILayout.Button('Destroy', GUILayout.Width(60))
		
		EditorGUILayout.EndHorizontal()
		
		if destroyPressed:
			_stateTransitionElementsToRemove += (StateTransitionRemovalData(forState: forState, transition: element),)
		else:
			LayOutTransitionElementFields(element)
	
	
	private def LayOutTransitionElementFields(element as NStateTransition) as void:
		# name
		
		EditorGUILayout.BeginHorizontal()
		
		GUILayout.Label('Name', kLabelStyle)
		
		resultElementName as string = EditorGUILayout.TextField(element.name)
		if StateNameIsValid(resultElementName, element.name):
			element.name = resultElementName
		
		EditorGUILayout.EndHorizontal()
		
		
		# condition
		
		EditorGUILayout.BeginHorizontal()
		GUILayout.Label('Condition', kLabelStyle)
		NEventEditorGUILayout.AutoField(element.condition, NConditionBase)
		EditorGUILayout.EndHorizontal()
		
		
		# action
		
		EditorGUILayout.BeginHorizontal()
		GUILayout.Label('Action', kLabelStyle)
		element.action = NEventEditorGUILayout.EventActionField(element.action)
		EditorGUILayout.EndHorizontal()
		
		
		# target state
		
		EditorGUILayout.BeginHorizontal()
		targetStateName as string
		targetStateName = element.targetState.name if element.targetState is not null
		resultTargetStateName as string = StateWidget('Target State', targetStateName)
		if resultTargetStateName != targetStateName:
			element.targetState = _map.GetState(resultTargetStateName)
		EditorGUILayout.EndHorizontal()
	
	
	
	# utility
	
	
	private def StateNameIsValid(stateName as string) as bool:
		return not String.IsNullOrEmpty(stateName) and not _map.HasState(stateName)
	
	
	private def StateNameIsValid(stateName as string, exceptName as string) as bool:
		return stateName == exceptName or StateNameIsValid(stateName)
	
	
	private def TransitionNameIsValid(transitionName as string) as bool:
		return not String.IsNullOrEmpty(transitionName) #and not _map.HasState(transitionName)
	
	
	private def GetStateNames() as (string):
		stateNames as (string) = array(string, 0)
		
		for stateNode as NStateMap.Node in _map.nodes:
			stateNames += (stateNode.state.name,)
		
		return stateNames
