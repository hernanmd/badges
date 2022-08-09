Class {
	#name : #ShBadgesParserTest,
	#superclass : #TestCase,
	#instVars : [
		'shBadgesParser'
	],
	#category : #'Badges-Tests'
}

{ #category : #running }
ShBadgesParserTest >> setUp [
	super setUp.

]

{ #category : #accessing }
ShBadgesParserTest >> shBadgesParser [
	" Answer the shBadgesParser of this ShBadgesParserTest "

	^ shBadgesParser
]

{ #category : #accessing }
ShBadgesParserTest >> shBadgesParser: anObject [
	" Sets the shBadgesParser of this ShBadgesParserTest "

	shBadgesParser := anObject
]

{ #category : #tests }
ShBadgesParserTest >> testCollectBadgeVariables [

	self assert: ((shBadgesParser collectBadgeVariables: String empty) isKindOf: Collection).
	
	self assert: ((shBadgesParser collectBadgeVariables: 'be622c95-11a2-0d00-88cc-3f3d03df4f1e') isKindOf: Collection).
	
	self assert: ((shBadgesParser collectBadgeVariables: nil) isKindOf: Collection).
	
	self assert: ((shBadgesParser collectBadgeVariables: '7a642c95-11a2-0d00-a7f3-cf7008d7b186') equals: Collection).
	
]

{ #category : #tests }
ShBadgesParserTest >> testValueFor [

	self assert: ((shBadgesParser valueFor: String empty) isKindOf: String).
	
	self assert: ((shBadgesParser valueFor: '90202c95-11a2-0d00-b220-ad8e076d84e0') isKindOf: String).
	
	self assert: ((shBadgesParser valueFor: nil) isKindOf: String).
	
	self assert: ((shBadgesParser valueFor: '2e242c95-11a2-0d00-be63-40910247ff42') equals: String).
	
]
