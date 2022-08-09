"
A ShBadgeCollectorTest is a test class for testing the behavior of ShBadgeCollector
"
Class {
	#name : #ShBadgeCollectorTest,
	#superclass : #TestCase,
	#instVars : [
		'collector'
	],
	#category : #'Badges-Tests'
}

{ #category : #accessing }
ShBadgeCollectorTest >> collector [

	^ collector
]

{ #category : #accessing }
ShBadgeCollectorTest >> collector: anObject [

	collector := anObject
]

{ #category : #tests }
ShBadgeCollectorTest >> newForm [

	^ Form extent: 1 @ 1
]

{ #category : #running }
ShBadgeCollectorTest >> setUp [ 

	super setUp.
	self collector: ShBadgeCollector new.
]

{ #category : #test }
ShBadgeCollectorTest >> testBadgeCategories [

	self assert: (self collector badgeCategories isKindOf: Collection).
	self deny: self collector badgeCategories isEmpty.
]

{ #category : #tests }
ShBadgeCollectorTest >> testNewBadgeNamedCodeImgForm [

	| newBadge |
	
	newBadge := self collector newBadgeNamed: 'test' code: 'code' imgForm: self newForm.
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
