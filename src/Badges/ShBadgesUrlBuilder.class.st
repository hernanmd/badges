Class {
	#name : #ShBadgesUrlBuilder,
	#superclass : #Object,
	#instVars : [
		'badgeGetUrl'
	],
	#category : #'Badges-UI'
}

{ #category : #accessing }
ShBadgesUrlBuilder >> buildGetPngUrl: aBadgeGetUrl [

	^ (aBadgeGetUrl includes: $?)
		ifTrue: [ (aBadgeGetUrl copyUpTo: $?) , '.png?' , (aBadgeGetUrl copyAfter: $?) ]
		ifFalse: [ aBadgeGetUrl , '.png' ]
]

{ #category : #accessing }
ShBadgesUrlBuilder >> parseGetUrl: aMarkdownString [
	"Answer a <String> representing the built URL for the selected badge"
	
	^ (aMarkdownString copyAfterLast: $() copyUpTo: $)
]

{ #category : #accessing }
ShBadgesUrlBuilder >> validateGetUrl: anUrlString [
	"Answer <true> if anUrlString is valid to make a get request"
	
	^ (anUrlString allButFirst: 6) includes: $:
]
