## Copyright © 2009 Slippy Douglas and Nectar Games. All rights reserved.
## @author	Slippy Douglas
## @purpose	Provides …


import System
import System.Reflection
import UnityEditor
import UnityEngine


class NStateEditorGUILayout:
	static final kPubFieldBindingFlags as BindingFlags = BindingFlags.Public | BindingFlags.Instance
	
	
	
	static def ConditionField(element as NConditionBase) as NConditionBase:
		EditorGUILayout.BeginVertical()
		
		
		conditionType as Type = null
		conditionType = element.GetType() if element is not null
		
		resultConditionType as Type = NEventEditorGUILayout.DerivedTypeField(conditionType, NConditionBase)
		
		
		if resultConditionType is null:
			if element is not null:
				ScriptableObject.DestroyImmediate(element)
				element = null
		else:
			if resultConditionType != conditionType:
				ScriptableObject.DestroyImmediate(element)
				element = ScriptableObject.CreateInstance(resultConditionType.FullName)
			
			pubElementFields as (FieldInfo) = element.GetType().GetFields(kPubFieldBindingFlags)
			for field as FieldInfo in pubElementFields:
				if typeof(NConditionBase).GetField(field.Name, kPubFieldBindingFlags):
					continue
			
				#EditorGUILayout.BeginHorizontal()
				#GUILayout.Label(ObjectNames.NicifyVariableName(field.Name), kLabelStyle)
			
				origValue = field.GetValue(element)
				resultValue = NEventEditorGUILayout.AutoField(origValue, field.FieldType)
			
				try:
					field.SetValue(element, resultValue)
				except e as Exception:
					pass
			
				#EditorGUILayout.EndHorizontal()
		
			# cannot use private fields or properties because:
			# 	private fields get set back to 0 when the game starts (probably a Unity thing)
			# 	setting properties cause all kind of problems since the property can trigger other stuff to happen
		
		
		EditorGUILayout.EndVertical()
		
		
		return element
