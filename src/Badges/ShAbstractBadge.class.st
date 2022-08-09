Class {
	#name : #ShAbstractBadge,
	#superclass : #Object,
	#instVars : [
		'badgeName',
		'badgeImg',
		'badgeCode'
	],
	#category : #'Badges-Core'
}

{ #category : #'instance creation' }
ShAbstractBadge class >> named: nameString code: codeString img: aFormOrNil [
	" Answer a new instance receiver with nameString as name and imgStringOrNil as the representative image "

	^ self new
		badgeName: nameString;
		badgeCode: codeString;
		badgeImg: aFormOrNil;
		yourself
]

{ #category : #accessing }
ShAbstractBadge >> badgeCode [
	"Answer a <String> representing the code to generate a visual representation of the receiver"

	^ badgeCode
]

{ #category : #accessing }
ShAbstractBadge >> badgeCode: anObject [
	badgeCode := anObject
]

{ #category : #accessing }
ShAbstractBadge >> badgeImg [
	"Answer a <Form> image, a visual view of the receiver"

	^ badgeImg
]

{ #category : #accessing }
ShAbstractBadge >> badgeImg: aFormOrNil [
	" Set the receiver image as <Form> or nil if none found "

	badgeImg := aFormOrNil
]

{ #category : #accessing }
ShAbstractBadge >> badgeName [
	"Answer a <String> to identify the receiver"

	^ badgeName
]

{ #category : #accessing }
ShAbstractBadge >> badgeName: anObject [
	badgeName := anObject
]

{ #category : #'accessing - url' }
ShAbstractBadge >> baseUrl [
	" Answer a <String> with the receiver's base url "

	^ self class baseUrl
]

{ #category : #printing }
ShAbstractBadge >> printOn: aStream [
	" Private - See superimplementor's comment "
	
	aStream 	
		<< $(
		<< badgeName asString
		<< $) 
]
