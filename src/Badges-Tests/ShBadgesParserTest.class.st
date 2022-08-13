Class {
	#name : #ShBadgesParserTest,
	#superclass : #TestCase,
	#instVars : [
		'shBadgesParser'
	],
	#category : #'Badges-Tests-Core'
}

{ #category : #running }
ShBadgesParserTest >> setUp [

	super setUp.
	shBadgesParser := ShBadgesParser newFor: ShBadgesApp new.
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

	self 
		assertCollection: (shBadgesParser collectBadgeVariables: String empty)
		hasSameElements: Array empty.
	
	self 
		assertCollection: (shBadgesParser collectBadgeVariables: '/github/license/:user/:repo') 
		hasSameElements: (OrderedCollection new add: ('user'->''); add: ('repo'->''); yourself).

	self 
		assertCollection: (shBadgesParser collectBadgeVariables: '/github/commits-since/:user/:repo/:version/:branch*') 
		hasSameElements: (OrderedCollection new add: ('user'->''); add: ('repo'->''); add: ('version'->''); add: ('branch'->''); yourself).

	self should: [ shBadgesParser collectBadgeVariables: nil ] raise: MessageNotUnderstood.

]

{ #category : #test }
ShBadgesParserTest >> testCollectBadgeVariablesFromPath [

	self assert: ((shBadgesParser collectBadgeVariablesFromPath: String empty) isKindOf: Collection).
	self 
		assertCollection: (shBadgesParser collectBadgeVariablesFromPath: String empty)
		hasSameElements: OrderedCollection empty
]

{ #category : #tests }
ShBadgesParserTest >> testValueFor [

	self assert: ((shBadgesParser valueFor: String empty) isKindOf: String).
	
	self 
		assert: (shBadgesParser valueFor: '90202c95-11a2-0d00-b220-ad8e076d84e0') 
		equals: String empty.
	
	self 
		assert: (shBadgesParser valueFor: nil) 
		equals: String empty.

	
]
