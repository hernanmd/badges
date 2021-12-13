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
		'badgesSelection',
		'username',
		'repository',
		'branch'
	],
	#category : #Badges
}

{ #category : #specs }
ShBadgesPresenter class >> defaultSpec [
    <spec>
    ^ SpBoxLayout newLeftToRight
			add: #badgeTypes width: 100;
			spacing: 3;
			add: (SpBoxLayout new
				add: (SpGridLayout new 
					beColumnNotHomogeneous;				
					add: 'Username' at: 1 @ 1;
					add: #username at: 2 @ 1;
					add: 'Repository' at: 3 @ 1;
					add: #repository at: 4 @ 1;
					add: 'Branch' at: 5 @ 1;
					add: #branch at: 6 @1;
					yourself) height: 50;
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

{ #category : #accessing }
ShBadgesPresenter >> branch [

	^ branch
]

{ #category : #accessing }
ShBadgesPresenter >> branch: anObject [

	branch := anObject
]

{ #category : #initialization }
ShBadgesPresenter >> buildBadgeUrl [

	^ String << [ : stream |
		stream 
			<< ShBadge baseUrl;
			<< self badgesTextArea text ]
]

{ #category : #initialization }
ShBadgesPresenter >> copySelection: aCollection [

	WebBrowser openOn: self buildBadgeUrl.

	Clipboard clipboardText: self buildBadgeUrl.
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
		label: 'Get Badge'; 
		action: [ self copySelection: self  ];
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
"		beMultipleSelection;
		addColumn: ((SpCheckBoxTableColumn evaluated: [ : badge | self badgesSelection includes: badge ])
			onActivation: [ : badge | self badgesSelection add: badge];
			onDeactivation: [ : badge | self badgesSelection remove: badge ];
			width: 20;
			yourself);"
		addColumn: (SpImageTableColumn
			title: 'Image' 
			evaluated: [ : badgeNode | badgeNode badgeImg asMorph ]);
		addColumn: (SpStringTableColumn 
			title: 'Name'
			evaluated: [ : badgeNode | badgeNode badgeName ]);
		whenSelectedItemChangedDo: [ : item | item ifNotNil: [ self updateBadgeText ] ];
		roots: (self badgeCollector badgesAt: self selectedBadgeType).

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
		add: self username;
		add: self repository;
		add: self badgesList;
		add: self badgesTextArea;
		add: self toolbar
]

{ #category : #initialization }
ShBadgesPresenter >> initializePresenters [
	" Private - See superimplementor's comment "

	self 
		initializeUserRepo;
		initializeBadgesTypes;
		initializeBadgesList;
		initializeBadgesTextArea;
		initializeActionBar;
		initializeFocus
]

{ #category : #initialization }
ShBadgesPresenter >> initializeUserRepo [

	username := self newTextInput.
	repository := self newTextInput.
	branch := self newTextInput text: 'master'; yourself.
]

{ #category : #accessing }
ShBadgesPresenter >> repository [

	^ repository
]

{ #category : #accessing }
ShBadgesPresenter >> repository: anObject [

	repository := anObject
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

	| text |
	text := self selectedBadgeItem badgeCode copyReplaceAll: ':user' with: self username text.
	text := text copyReplaceAll: ':repo' with: self repository text.
	text := text copyReplaceAll: ':branch' with: self  branch text.
	self badgesTextArea text: text
]

{ #category : #callbacks }
ShBadgesPresenter >> updateBadgesList [

	self badgesList 
		roots: (self badgeCollector badgesAt: self selectedBadgeType)
]

{ #category : #accessing }
ShBadgesPresenter >> username [

	^ username
]

{ #category : #accessing }
ShBadgesPresenter >> username: anObject [

	username := anObject
]
