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
			add: (SpBoxLayout newTopToBottom
				add: self repositoryLayoutSettings height: 45;
				add: #badgesList;
				spacing: 3;
				add: #badgesTextArea height: 80;
				add: (SpBoxLayout newLeftToRight
					add: #toolbar width: 600) height: self toolbarHeight;
				yourself);
			yourself
]

{ #category : #'instance creation' }
ShBadgesPresenter class >> open [
	" Open the badges selection window "
	<script>

	self class basicNew 
		initialize;
		openWithSpec.
]

{ #category : #specs }
ShBadgesPresenter class >> repositoryLayoutSettings [

	^ SpGridLayout new 
			beColumnNotHomogeneous;

			add: (SpBoxLayout newLeftToRight
						add: 'Username' width: 70;
						add: #username width: 120;
						yourself) at: 1 @ 1;

			add: (SpBoxLayout newLeftToRight
						add: 'Repository' width: 70;
						add: #repository width: 120;
						yourself) at: 2 @ 1;
						
			add: (SpBoxLayout newLeftToRight
						add: 'Branch' width: 50;
						add: #branch width: 120;
						yourself) at: 3 @ 1;
	
			yourself
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
ShBadgesPresenter >> checkButton [
	" Answer the receiver's <SpButtonPresenter> for the Check Badge "

	^ self toolbar presenters detect: [ : btn | btn label = 'Check' ]
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
	
	^ 900 @ 600

]

{ #category : #initialization }
ShBadgesPresenter >> initialize [

	super initialize.
	badgesCollector := nil.
]

{ #category : #initialization }
ShBadgesPresenter >> initializeActionBar [

	| closeButton checkButton |
	closeButton := self newButton
		label: 'Quit';
		icon: (self iconNamed: #smallQuit);
		help: 'Close this window';
		action: [ self window close ];
		yourself.

	checkButton := self newButton
		label: 'Check';
		icon: (self iconNamed: #smallRemoteOpen);
		help: 'Open a web browser with the selected shield badge';
		action: [ self copySelection: self  ];
		enabled: false;
		yourself.

	toolbar := self newActionBar
		add: closeButton;
		add: checkButton;
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
		whenSelectionChangedDo: [ : item | self updateBadgeSelection: item ];
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
			self badgeTypes selectedItem ifNotNil: [ self updateBadgesList ].
			self checkButton disable.
			self badgesTextArea text: String empty ]
]

{ #category : #initialization }
ShBadgesPresenter >> initializeFocus [
	" Private - See superimplementor's comment "

	self focusOrder
		add: self badgeTypes;
		add: self username;
		add: self repository;
		add: self branch;
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
ShBadgesPresenter >> updateBadgeSelection: item [

	item 
		ifNil: [ self checkButton ]
		ifNotNil: [ self updateBadgeText ]
]

{ #category : #callbacks }
ShBadgesPresenter >> updateBadgeText [

	self selectedBadgeItem 
		ifNotNil: [ : selectedBadge |
			| text |
			text := selectedBadge badgeCode copyReplaceAll: ':user' with: self username text.
			text := text copyReplaceAll: ':repo' with: self repository text.
			text := text copyReplaceAll: ':branch' with: self  branch text.
			self badgesTextArea text: text.
			
			self checkButton enable ]
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
