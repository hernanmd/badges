"
Wrapper for serializing and materializing shields, currently in FUEL format.
"
Class {
	#name : #ShBadgeFileCollection,
	#superclass : #ShBadgeCollection,
	#category : #'Badges-Core'
}

{ #category : #initialization }
ShBadgeFileCollection >> getShields [
	" Connect to the remote repository, download and serialize the available badges  "

	FLSerializer 
		serialize: ShBadgeCollector new collectAllBadges
		toFileNamed: self shieldsFilename
]

{ #category : #testing }
ShBadgeFileCollection >> hasShields [
	" Answer <true> if the receiver has any badges "

	^ self shieldsFilename asFileReference exists
]

{ #category : #initialization }
ShBadgeFileCollection >> initializeBadges [ 
	" Private - Set the receiver's badges. If there are any serialization of badges, read it first "

	self hasShields 
		ifFalse: [ self getShields ].
	self badges: self readShields.
]

{ #category : #initialization }
ShBadgeFileCollection >> readShields [
	"Answer a <Collection> with the contents of the receiver's badges file"

	^ FLMaterializer materializeFromFileNamed: self shieldsFilename 
]

{ #category : #initialization }
ShBadgeFileCollection >> shieldsFilename [
	"Answer a <String> representing the file where badges are stored"

	^ 'shields.badges'
]
