"
A ShBadgesAppTest is a test class for testing the behavior of ShBadgesApp
"
Class {
	#name : #ShBadgesAppTest,
	#superclass : #TestCase,
	#instVars : [
		'badgesApp'
	],
	#category : #'Badges-Tests-UI'
}

{ #category : #running }
ShBadgesAppTest >> setUp [

	super setUp.
	badgesApp := ShBadgesApp new.
]

{ #category : #tests }
ShBadgesAppTest >> testBadgeUserVariables [

	self assert: (badgesApp badgeUserVariables isKindOf: Dictionary).
	self assert: badgesApp badgeUserVariables isEmpty.
]

{ #category : #tests }
ShBadgesAppTest >> testBadgeUserVariablesAt [

	self assert: (badgesApp badgeUserVariablesAt: String empty) equals: String empty.
	self assert: (badgesApp badgeUserVariablesAt: 'MockVar') equals: String empty.

]

{ #category : #tests }
ShBadgesAppTest >> testBadgeUserVariablesAtPut [

	self assert: (badgesApp badgeUserVariablesAt: String empty put: 'MockValue1') equals: 'MockValue1'.
	self assert: (badgesApp badgeUserVariablesAt: 'MockVar' put: 'MockValue2') equals: 'MockValue2'.

]

{ #category : #tests }
ShBadgesAppTest >> testConfigurationFile [

	self assert: (badgesApp configurationFile isKindOf: FileReference).
	self assert: badgesApp configurationFile exists.
]

{ #category : #tests }
ShBadgesAppTest >> testDefaultConfigurationFile [

	self assert: (badgesApp defaultConfigurationFile isKindOf: FileReference).
	self assert: badgesApp defaultConfigurationFile exists.
]

{ #category : #tests }
ShBadgesAppTest >> testDeleteDefinedVariables [

	badgesApp badgeUserVariablesAt: 'mockVar' put: 'mockValue'.
	self assert: badgesApp badgeUserVariables size equals: 1. 
	badgesApp deleteDefinedVariables.
	self assert: badgesApp badgeUserVariables isEmpty.
]

{ #category : #tests }
ShBadgesAppTest >> testLoadDefinedVariables [

	badgesApp badgeUserVariablesAt: 'mockVar' put: 'mockValue'.
	badgesApp saveDefinedVariables.

	badgesApp badgeUserVariablesAt: 'mockVar' put: 'anotherValue'.
	
	badgesApp loadDefinedVariables.
	self assert: (badgesApp badgeUserVariablesAt: 'mockVar') equals: 'mockValue'
	
]

{ #category : #tests }
ShBadgesAppTest >> testSaveDefinedVariables [

	badgesApp badgeUserVariablesAt: 'mockVar' put: 'mockValue'.
	badgesApp saveDefinedVariables.
	self deny: badgesApp configurationFile size equals: 0
]
