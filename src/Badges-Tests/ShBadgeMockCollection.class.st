Class {
	#name : #ShBadgeMockCollection,
	#superclass : #ShBadgeCollection,
	#category : #'Badges-Tests-Core'
}

{ #category : #initialization }
ShBadgeMockCollection >> hasShields [

	^ self badges isEmpty not
]

{ #category : #initialization }
ShBadgeMockCollection >> howMany [

	^ 50
]

{ #category : #initialization }
ShBadgeMockCollection >> initializeBadges [ 
	" Private - Set the receiver's badges. If there are any serialization of badges, read it first "

	badges := Dictionary new: self howMany.
	self mockBadges.
]

{ #category : #initialization }
ShBadgeMockCollection >> mockBadges [

	| bCollector |

	bCollector := ShBadgeCollector new.
	self howMany timesRepeat: [
		| bName|
		bName := UUIDGenerator new next asString.
		badges at: bName put: (bCollector 
			newBadgeNamed: bName
			code: UUIDGenerator new next asString
			imgForm: (Form extent: 1 @ 1)) ].
	^ badges
]
