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

{ #category : #test }
ShBadgeCollectorTest >> setUp [ 

	self collector: ShBadgeCollector new.
]

{ #category : #test }
ShBadgeCollectorTest >> testBadgeCategories [

	self assert: (self collector badgeCategories isKindOf: Collection).
	self deny: self collector badgeCategories isEmpty.
]
