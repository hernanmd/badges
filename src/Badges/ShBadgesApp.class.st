Class {
	#name : #ShBadgesApp,
	#superclass : #SpApplication,
	#instVars : [
		'badgeUserVariables'
	],
	#category : #Badges
}

{ #category : #'world menu' }
ShBadgesApp class >> menuCommandOn: aBuilder [ 
	<worldMenu> 
	
	(aBuilder item: #'Badges')
		parent: #Tools;
		action:[ self new run ];
		icon: self taskbarIcon.
]

{ #category : #accessing }
ShBadgesApp >> badgeUserVariables [

	^ badgeUserVariables
		ifNil: [ badgeUserVariables := Dictionary new ]
]

{ #category : #accessing }
ShBadgesApp >> badgeUserVariablesAt: aVariableName ifAbsent: aBlock [

	^ self badgeUserVariables 
		at: aVariableName
		ifAbsent: aBlock
]

{ #category : #accessing }
ShBadgesApp >> badgeUserVariablesAt: aVariableName put: aString [

	^ self badgeUserVariables 
		at: aVariableName
		put: aString
]

{ #category : #accessing }
ShBadgesApp >> start [
	" Private - See superimplementor's comment "

	(ShBadgesPresenter newApplication: self) openWithSpec.
]
