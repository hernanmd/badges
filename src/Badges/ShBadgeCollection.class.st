"
Abstract class providing an interface for accessing badges as `Dictionary`.

Subclasses may implement file based access to badges or mocks.

"
Class {
	#name : #ShBadgeCollection,
	#superclass : #Object,
	#instVars : [
		'badges'
	],
	#category : #'Badges-Core'
}

{ #category : #accessing }
ShBadgeCollection class >> new [ 

	^ super new 
		initializeBadges;
		yourself
]

{ #category : #accessing }
ShBadgeCollection >> badges [
	^ badges
]

{ #category : #accessing }
ShBadgeCollection >> badges: anObject [
	badges := anObject
]

{ #category : #accessing }
ShBadgeCollection >> badgesAt: aString [ 
	" Answer a <Dictionary> of the receiver's badges <ShBadge> which matches category name aString "

	^ self badges at: aString
]

{ #category : #accessing }
ShBadgeCollection >> badgesAt: aString ifAbsent: aBlock [
	" Answer a <Dictionary> of the receiver's badges <CGShieldBadge> which matches category name aString "

	^ self badges at: aString ifAbsent: aBlock

]

{ #category : #accessing }
ShBadgeCollection >> badgesAt: aString put: anObject [
	" Answer a <Dictionary> of the receiver's badges <ShBadge> which matches category name aString "

	^ self badges at: aString put: anObject
]

{ #category : #testing }
ShBadgeCollection >> hasShields [

	self subclassResponsibility
]

{ #category : #initialization }
ShBadgeCollection >> initializeBadges [

	self subclassResponsibility 
]
