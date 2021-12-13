Class {
	#name : #ShBadgeCollection,
	#superclass : #ShAbstractBadgeCollection,
	#category : #Badges
}

{ #category : #accessing }
ShBadgeCollection class >> new [ 

	^ super new 
		initializeBadges;
		yourself
]

{ #category : #accessing }
ShBadgeCollection >> badgesAt: aString [ 
	" Answer a <Dictionary> of the receiver's badges <CGShieldBadge> which matches category name aString "

	^ self badges at: aString
]

{ #category : #accessing }
ShBadgeCollection >> badgesAt: aString ifAbsent: aBlock [
	" Answer a <Dictionary> of the receiver's badges <CGShieldBadge> which matches category name aString "

	^ self badges at: aString ifAbsent: aBlock

]

{ #category : #initialization }
ShBadgeCollection >> getShields [
	" Connect to the remote repository, download and serialize the available badges  "

	FLSerializer 
		serialize: ShBadgeCollector new collectAllBadges
		toFileNamed: self shieldsFilename
]

{ #category : #testing }
ShBadgeCollection >> hasShields [
	" Answer <true> if the receiver has any badges "

	^ self shieldsFilename asFileReference exists
]

{ #category : #initialization }
ShBadgeCollection >> initializeBadges [ 
	" Private - Set the receiver's badges. If there are any serialization of badges, read it first "

	self hasShields 
		ifFalse: [ self getShields ].
	self badges: self readShields.
]

{ #category : #initialization }
ShBadgeCollection >> readShields [
	" Answer the contents of the receiver's badges file "

	^ FLMaterializer materializeFromFileNamed: self shieldsFilename 
]

{ #category : #initialization }
ShBadgeCollection >> shieldsFilename [

	^ 'shields.badges'
]
