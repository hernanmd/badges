Class {
	#name : #ShBadgesApp,
	#superclass : #SpApplication,
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
ShBadgesApp >> start [
	" Private - See superimplementor's comment "

	(ShBadgesPresenter newApplication: self) openWithSpec.
]
