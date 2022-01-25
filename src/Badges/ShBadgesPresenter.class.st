"
Provides the main window for browsing and selection of badges.

See class side for opening.

"
Class {
	#name : #ShBadgesPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'badgeTypes',
		'badgesTextArea',
		'toolbar',
		'badgesCollector',
		'username',
		'repository',
		'branch',
		'badgesTable'
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
				add: #badgesTable;
				spacing: 3;
				add: #badgesTextArea height: 80;
				add: (SpBoxLayout newLeftToRight
					spacing: 3;
					add: #toolbar width: 600) height: self toolbarHeight;
				yourself);
			spacing: 1;
			add: self repositoryLayoutSettings;			
			yourself
]

{ #category : #'instance creation' }
ShBadgesPresenter class >> open [
	" Open the badges selection window "
	<script>

	self basicNew 
		initialize;
		openWithSpec.
]

{ #category : #specs }
ShBadgesPresenter class >> repositoryLayoutSettings [

	^ SpGridLayout new 

			add: (SpBoxLayout newLeftToRight
						add: 'Username' width: 70;
						add: #username width: 120;
						yourself) at: 1 @ 1;

			add: (SpBoxLayout newLeftToRight
						add: 'Repository' width: 70;
						add: #repository width: 120;
						yourself) at: 1 @ 2;
						
			add: (SpBoxLayout newLeftToRight
						add: 'Branch' width: 50;
						add: #branch width: 120;
						yourself) at: 1 @ 3;
	
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
ShBadgesPresenter >> badgesTable [
	" Answer the badgesList of this presenter "

	^ badgesTable
]

{ #category : #accessing }
ShBadgesPresenter >> badgesTable: anObject [
	" Sets the badgesList of this presenter "

	badgesTable := anObject
]

{ #category : #accessing }
ShBadgesPresenter >> badgesTextArea [
	" Answer the badgesTextArea of this presenter "

	^ badgesTextArea
]

{ #category : #accessing }
ShBadgesPresenter >> badgesTextArea: anObject [
	" Sets the badgesTextArea of this presenter "

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

{ #category : #callbacks }
ShBadgesPresenter >> buildBadgeMDText [
	" Answer a <String> formatted for describing a URL link in Markdown format "
	
	^ self selectedBadgeItem badgeName 
	
]

{ #category : #callbacks }
ShBadgesPresenter >> buildBadgeMDUrl: text [
	" Answer a <String> with the text in Markdown format to be pasted in a README file "

	^ String << [ : stream |
		stream
			<< $[;
			<< self buildBadgeMDText;
			<< $];
			<< $(;
			<< ShBadge baseUrl;
			<< text;
			<< $) ]
]

{ #category : #initialization }
ShBadgesPresenter >> buildBadgeUrl [

	^ String << [ : stream |
		stream 
			<< ShBadge baseUrl;
			<< self selectedBadgeItem badgeCode ]
]

{ #category : #accessing }
ShBadgesPresenter >> checkButton [
	" Answer the receiver's <SpButtonPresenter> for the Check Badge "

	^ self toolbar presenters detect: [ : btn | btn label = 'Check' ]
]

{ #category : #callbacks }
ShBadgesPresenter >> checkSelectedBadge [
	" Private - Callback for Check button "

	WebBrowser openOn: self buildBadgeUrl.
	self copySelectedBadge.
]

{ #category : #accessing }
ShBadgesPresenter >> copyButton [
	" Answer the receiver's <SpButtonPresenter> for the Copy Badge "

	^ self toolbar presenters detect: [ : btn | btn label = 'Copy' ]
]

{ #category : #callbacks }
ShBadgesPresenter >> copySelectedBadge [
	" Private - Callback for Copy badge Markdown button "

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

	| closeButton checkButton copyButton |
	closeButton := self newCloseButton.
	checkButton := self newCheckButton.
	copyButton := self newCopyButton.

	toolbar := self newActionBar
					add: closeButton;
					add: checkButton;
					add: copyButton;
					yourself
]

{ #category : #initialization }
ShBadgesPresenter >> initializeBadgesTable [

	self badgesTable: self newTreeTable.
	self badgesTable
		beResizable;
		searchMatching: [ :item :textToSearch | self searchItem: item text: textToSearch ];		
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
			self copyButton disable.
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
		add: self badgesTable;
		add: self badgesTextArea;
		add: self toolbar
]

{ #category : #initialization }
ShBadgesPresenter >> initializePresenters [
	" Private - See superimplementor's comment "

	self 
		initializeUserRepo;
		initializeBadgesTypes;
		initializeBadgesTable;
		initializeBadgesTextArea;
		initializeActionBar;
		initializeFocus
]

{ #category : #initialization }
ShBadgesPresenter >> initializeUserRepo [

	username := self newTextInput
		placeholder: 'Enter your username';
		whenTextChangedDo: [ self updateBadgeText ];
		autoAccept: true.
	repository := self newTextInput
		placeholder: 'Enter the repository name';
		whenTextChangedDo: [ self updateBadgeText ];
		autoAccept: true.
	branch := self newTextInput text: 'master'; yourself.
]

{ #category : #initialization }
ShBadgesPresenter >> newCheckButton [

	^ self newButton
		  label: 'Check';
		  icon: (self iconNamed: #smallRemoteOpen);
		  help: 'Open a web browser with the selected shield badge';
		  action: [ self checkSelectedBadge ];
		  enabled: false;
		  yourself
]

{ #category : #initialization }
ShBadgesPresenter >> newCloseButton [

	^ self newButton
		  label: 'Quit';
		  icon: (self iconNamed: #smallQuit);
		  help: 'Close this window';
		  action: [ self window close ];
		  yourself
]

{ #category : #initialization }
ShBadgesPresenter >> newCopyButton [

	^ self newButton
		  label: 'Copy';
		  icon: (self iconNamed: #smallCopy);
		  help: 'Copy the Markdown text of the selected shield badge';
		  action: [ self copySelectedBadge ];
		  enabled: false;
		  yourself
]

{ #category : #accessing }
ShBadgesPresenter >> repository [

	^ repository
]

{ #category : #accessing }
ShBadgesPresenter >> repository: anObject [

	repository := anObject
]

{ #category : #initialization }
ShBadgesPresenter >> searchItem: item text: textToSearch [

	^ item badgeName asLowercase beginsWith: textToSearch asLowercase 
]

{ #category : #accessing }
ShBadgesPresenter >> selectedBadgeItem [
	" Answer the currently selected badge type <String> "

	^ self badgesTable selectedItem
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
			self badgesTextArea text: (self buildBadgeMDUrl: text).
			
			self copyButton enable.
			self checkButton enable ]
]

{ #category : #callbacks }
ShBadgesPresenter >> updateBadgesList [

	self badgesTable 
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
