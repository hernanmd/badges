Class {
	#name : #ShBadgeMockCollectionTest,
	#superclass : #TestCase,
	#instVars : [
		'shBadgeCollection'
	],
	#category : #'Badges-Tests'
}

{ #category : #running }
ShBadgeMockCollectionTest >> setUp [

	super setUp.
	shBadgeCollection := ShBadgeMockCollection new.
]

{ #category : #accessing }
ShBadgeMockCollectionTest >> shBadgeCollection [
	" Answer the shBadgeCollection of this ShBadgeCollectionTest "

	^ shBadgeCollection
]

{ #category : #accessing }
ShBadgeMockCollectionTest >> shBadgeCollection: anObject [
	" Sets the shBadgeCollection of this ShBadgeCollectionTest "

	shBadgeCollection := anObject
]

{ #category : #tests }
ShBadgeMockCollectionTest >> testBadgesAt [

	| aBadge |
	
	self should: [ shBadgeCollection badgesAt: 'a8f43f90-11a2-0d00-9eba-26b00bb38f8e' ] raise: KeyNotFound.
	self should: [ shBadgeCollection badgesAt: String empty ] raise: KeyNotFound.
		
	self should: [ shBadgeCollection badgesAt: nil ] raise: Error.
	
	aBadge := ShBadge new.
	shBadgeCollection badgesAt: 'sampleBadge' put: aBadge.
	self assert: (shBadgeCollection badgesAt: 'sampleBadge') equals: aBadge.
	
]

{ #category : #tests }
ShBadgeMockCollectionTest >> testBadgesAtIfAbsent [

	self assert: (shBadgeCollection badgesAt: 'a8f43f90-11a2-0d00-9eba-26b00bb38f8e' ifAbsent: [ nil ]) equals: nil.
	self should: [ shBadgeCollection badgesAt: String empty ifAbsent: [ KeyNotFound signal ] ] raise: KeyNotFound.


]

{ #category : #tests }
ShBadgeMockCollectionTest >> testHasShields [

	self assert: (shBadgeCollection hasShields isKindOf: Boolean).
	self assert: shBadgeCollection hasShields.
]
