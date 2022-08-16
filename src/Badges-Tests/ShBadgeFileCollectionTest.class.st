"
A ShBadgeFileCollectionTest is a test class for testing the behavior of ShBadgeFileCollection
"
Class {
	#name : #ShBadgeFileCollectionTest,
	#superclass : #TestCase,
	#instVars : [
		'badgesCollection'
	],
	#category : #'Badges-Tests-Core'
}

{ #category : #running }
ShBadgeFileCollectionTest >> setUp [
	
	super setUp.
	badgesCollection := ShBadgeFileCollection new.
	"Put here a common initialization logic for tests"
]

{ #category : #tests }
ShBadgeFileCollectionTest >> testHasShields [

	self assert: badgesCollection hasShields.
]

{ #category : #tests }
ShBadgeFileCollectionTest >> testReadShields [

	| shields |
	
	shields := badgesCollection readShields.
	self assert: (shields isKindOf: Dictionary).
	self deny: shields isEmpty.
	
	self assert: (shields anyOne allSatisfy: [ : b | b isKindOf: ShBadge ])
]

{ #category : #tests }
ShBadgeFileCollectionTest >> testShieldsFilename [

	self assert: (badgesCollection shieldsFilename isKindOf: String).
	self deny: badgesCollection shieldsFilename isEmpty.
	
]
