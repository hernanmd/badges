Extension { #name : #Color }

{ #category : #'*Badges' }
Color >> asBadgeStyleValue [

	^ SpImagePresenter new 
		image: self;
		yourself
]
