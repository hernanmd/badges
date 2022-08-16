"
A ShBadgeCollectorTest is a test class for testing the behavior of ShBadgeCollector
"
Class {
	#name : #ShBadgeCollectorTest,
	#superclass : #ShBadgeAbstractTest,
	#instVars : [
		'collector'
	],
	#category : #'Badges-Tests-Core'
}

{ #category : #accessing }
ShBadgeCollectorTest >> collector [

	^ collector
]

{ #category : #accessing }
ShBadgeCollectorTest >> collector: anObject [

	collector := anObject
]

{ #category : #running }
ShBadgeCollectorTest >> setUp [ 

	super setUp.
	self collector: ShBadgeCollector new.
]

{ #category : #tests }
ShBadgeCollectorTest >> testBadgeCategories [

	self assert: (self collector badgeCategories isKindOf: Collection).
	self deny: self collector badgeCategories isEmpty.
]

{ #category : #tests }
ShBadgeCollectorTest >> testBadges [

	self assert: (collector badges isKindOf: ShBadgeCollection).
	self assert: collector badges hasShields.
]

{ #category : #tests }
ShBadgeCollectorTest >> testBadgesAt [

	| buildBadges |
	
	buildBadges := collector badgesAt: 'Build'.
	self deny: buildBadges isEmpty.
	self assert: (buildBadges allSatisfy: [ :b | b isKindOf: ShBadge ]).

	self should: [ collector badgesAt: String empty ] raise: NotFound.
	self should: [ collector badgesAt: nil ] raise: NotFound
]

{ #category : #tests }
ShBadgeCollectorTest >> testBuildPngURLString [

	self assert: ((collector buildPngURLString: '') isKindOf: String).
	self assert: ((collector buildPngURLString: '') beginsWith: ShBadge baseUrl).
	
	self assert: (collector buildPngURLString: '/test') equals: 'https://img.shields.io/test.png'.
	
]

{ #category : #tests }
ShBadgeCollectorTest >> testNewBadgeNamedCodeImgForm [

	| newBadge |
	
	newBadge := self collector newBadgeNamed: 'test' code: 'code' imgForm: self newMockForm.
	self
		assert: (newBadge isKindOf: ShBadge)
		description: 'It test that a new badge is actually a ShBadge'.

]

{ #category : #tests }
ShBadgeCollectorTest >> testShieldsUrl [

	self 
		assert: (self collector shieldsUrl isKindOf: String)
		description: 'It test the URL endpoint is a String'.
		
	self
		deny: self collector shieldsUrl isEmpty
		description: 'The endpoint URL must not be empty'
	
]
