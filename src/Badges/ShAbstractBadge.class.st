Class {
	#name : #ShAbstractBadge,
	#superclass : #Object,
	#instVars : [
		'badgeName',
		'badgeImg',
		'badgeCode'
	],
	#category : #Badges
}

{ #category : #accessing }
ShAbstractBadge >> badgeCode [
	^ badgeCode
]

{ #category : #accessing }
ShAbstractBadge >> badgeCode: anObject [
	badgeCode := anObject
]

{ #category : #accessing }
ShAbstractBadge >> badgeImg [
	^ badgeImg
]

{ #category : #accessing }
ShAbstractBadge >> badgeImg: aFormOrNil [
	" Set the receiver image as <Form> or nil if none found "

	badgeImg := aFormOrNil
]

{ #category : #accessing }
ShAbstractBadge >> badgeName [
	^ badgeName
]

{ #category : #accessing }
ShAbstractBadge >> badgeName: anObject [
	badgeName := anObject
]
