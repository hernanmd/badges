"
Provides the main window for browsing and selection of badges.

See class side for opening.

"
Class {
	#name : #ShBadgesPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'badgesList',
		'badgeTypes',
		'badgesTextArea',
		'toolbar',
		'badgesCollector',
		'badgesSelection'
	],
	#category : #Badges
}

{ #category : #specs }
ShBadgesPresenter class >> defaultSpec [
    <spec>
    ^ SpBoxLayout newLeftToRight
			add: #badgeTypes width: 100;
			spacing: 3;
			add: (SpBoxLayout newTopToBottom
				add: #badgesList;
				spacing: 3;
				add: #badgesTextArea height: 80;
				add: #toolbar height: self toolbarHeight;
				yourself);
			yourself
]

{ #category : #'instance creation' }
ShBadgesPresenter class >> open [
	" Open the badges selection window "
	<script>

	ShBadgesPresenter basicNew 
		initialize;
		openWithSpec.
]

{ #category : #accessing }
ShBadgesPresenter >> badgeCollector [
	
	^ badgesCollector
		ifNil: [ badgesCollector := ShBadgeCollector new ]
]

{ #category : #accessing }
ShBadgesPresenter >> badgeTypes [
	" Answer a <SpListPresenter> "

	^ badgeTypes
]

{ #category : #accessing }
ShBadgesPresenter >> badgeTypes: anObject [
	badgeTypes := anObject
]

{ #category : #initialization }
ShBadgesPresenter >> badgesCategories [
	" See comment in shields collector #badgeCategories "

	^ self badgeCollector badgeCategories
]

{ #category : #accessing }
ShBadgesPresenter >> badgesList [
	" Answer the badgesList of this CGBadgesSelector_UI "

	^ badgesList
]

{ #category : #accessing }
ShBadgesPresenter >> badgesList: anObject [
	" Sets the badgesList of this CGBadgesSelector_UI "

	badgesList := anObject
]

{ #category : #accessing }
ShBadgesPresenter >> badgesSelection [
	^ badgesSelection
		ifNil: [ badgesSelection := OrderedCollection new ]
]

{ #category : #accessing }
ShBadgesPresenter >> badgesSelection: anObject [
	badgesSelection := anObject
]

{ #category : #accessing }
ShBadgesPresenter >> badgesTextArea [
	" Answer the badgesTextArea of this CGBadgesSelector_UI "

	^ badgesTextArea
]

{ #category : #accessing }
ShBadgesPresenter >> badgesTextArea: anObject [
	" Sets the badgesTextArea of this CGBadgesSelector_UI "

	badgesTextArea := anObject
]

{ #category : #initialization }
ShBadgesPresenter >> copySelections: aCollection [

	Clipboard clipboardText: (
		String streamContents: [:stream |
			aCollection do: [:each | 
				stream 
					<< each badgeCode; 
					cr ] ]).
	self inform: 'Copied to clipboard'
]

{ #category : #initialization }
ShBadgesPresenter >> initialExtent [
	"Answer the initial extent for the receiver."
	
	^ 600 @ 400

]

{ #category : #initialization }
ShBadgesPresenter >> initialize [

	super initialize.
	badgesCollector := nil.
]

{ #category : #initialization }
ShBadgesPresenter >> initializeActionBar [

	| closeButton copyButton |
	closeButton := self newButton
		label: 'Close';
		action: [ self window close ];
		yourself.
	copyButton := self newButton
		label: 'Copy'; 
		action: [ self copySelections: self badgesList selectedItems ];
		yourself.

	toolbar := self newActionBar
		add: closeButton;
		add: copyButton;
		yourself.
]

{ #category : #initialization }
ShBadgesPresenter >> initializeBadgesList [

	self badgesList: self newTreeTable.
	self badgesList
		beMultipleSelection;
		addColumn: ((SpCheckBoxTableColumn evaluated: [ : badge | self badgesSelection includes: badge ])
			onActivation: [ : badge | self badgesSelection add: badge];
			onDeactivation: [ : badge | self badgesSelection remove: badge ];
			width: 20;
			yourself);
		addColumn: (SpImageTableColumn
			title: 'Image' 
			evaluated: [ : badgeNode | badgeNode badgeImg asMorph ]);
		addColumn: (SpStringTableColumn 
			title: 'Name'
			evaluated: [ : badgeNode | badgeNode badgeName ]);
		whenSelectedItemChangedDo: [ : item | item ifNotNil: [ self updateBadgeText ] ];
		roots: (self badgeCollector collectBadgesAt: self selectedBadgeType).

]

{ #category : #initialization }
ShBadgesPresenter >> initializeBadgesTextArea [
		
	badgesTextArea := self newText.
	badgesTextArea 
		beNotEditable
]

{ #category : #initialization }
ShBadgesPresenter >> initializeBadgesTypes [

	self badgeTypes: self newList.
	self badgeTypes
		headerTitle: 'Badge types';
		items: self badgesCategories asSortedCollection;
		selectIndex: 1;
		whenSelectionChangedDo: [ 
			self badgeTypes selectedItem ifNotNil: [ self updateBadgesList ] ]
]

{ #category : #initialization }
ShBadgesPresenter >> initializeFocus [
	" Private - See superimplementor's comment "

	self focusOrder
		add: self badgeTypes;
		add: self badgesList;
		add: self badgesTextArea
]

{ #category : #initialization }
ShBadgesPresenter >> initializePresenters [
	" Private - See superimplementor's comment "

	self 
		initializeBadgesTypes;
		initializeBadgesList;
		initializeBadgesTextArea;
		initializeActionBar;
		initializeFocus
]

{ #category : #accessing }
ShBadgesPresenter >> selectedBadgeItem [
	" Answer the currently selected badge type <String> "

	^ self badgesList selectedItem
]

{ #category : #accessing }
ShBadgesPresenter >> selectedBadgeType [
	" Answer the currently selected badge type <String> "

	^ self badgeTypes selectedItem 
]

{ #category : #initialization }
ShBadgesPresenter >> title [
	" Private - See superimplementor's comment "

	^ 'Shield Badges'
]

{ #category : #accessing }
ShBadgesPresenter >> toolbar [
	" Answer the toolbar of this CGBadgesSelector_UI "

	^ toolbar
]

{ #category : #accessing }
ShBadgesPresenter >> toolbar: anObject [
	" Sets the toolbar of this CGBadgesSelector_UI "

	toolbar := anObject
]

{ #category : #callbacks }
ShBadgesPresenter >> updateBadgeText [

	self badgesTextArea text: self selectedBadgeItem halt
]

{ #category : #callbacks }
ShBadgesPresenter >> updateBadgesList [

	self badgesList 
		roots: (self badgeCollector badgesAt: self selectedBadgeType)
]
