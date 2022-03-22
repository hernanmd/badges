"
Provides the main window for browsing and selection of badges.

See class side for opening.

"
Class {
	#name : #ShBadgesPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'badgeTypes',
		'toolbar',
		'badgesCollector',
		'badgesTable',
		'variablesTable',
		'badgesTextSource',
		'badgesTextTarget'
	],
	#category : #Badges
}

{ #category : #'instance creation' }
ShBadgesPresenter class >> open [
	" Open the badges selection window "
	<script>

	self basicNew 
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
ShBadgesPresenter >> badgesTextSource [
	" Answer the badgesTextArea of this presenter "

	^ badgesTextSource
]

{ #category : #accessing }
ShBadgesPresenter >> badgesTextTarget [

	^ badgesTextTarget
]

{ #category : #callbacks }
ShBadgesPresenter >> buildBadgeMDText [
	" Answer a <String> formatted for describing a URL link in Markdown format "
	
	^ self selectedBadgeItem badgeName 
	
]

{ #category : #callbacks }
ShBadgesPresenter >> buildBadgeMDUrl: text [
	" Answer a <String> with the text in Markdown format to be pasted in a README file "

	^ String streamContents: [ : stream |
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

	^ String streamContents: [ : stream |
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

{ #category : #private }
ShBadgesPresenter >> collectBadgeVariables: aString [

	"Parse aString and extract variables. Answer a <Collection> of <Association>"

	| tmpVarTable vars |
	tmpVarTable := OrderedCollection new.
	vars := self collectBadgeVariablesFromPath: aString.
	vars
		collect: [ :varName | varName copyUpToAny: { $*. $?. $+ } ]
		thenDo: [ :varName | tmpVarTable add: varName -> (self valueFor: varName) ].
	^ tmpVarTable
]

{ #category : #private }
ShBadgesPresenter >> collectBadgeVariablesFromPath: aString [

	^ (aString findTokens: '/')
		  select: [ :c | c beginsWith: ':' ]
		  thenCollect: #allButFirst
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
ShBadgesPresenter >> initializeBadgesTextSource [
		
	badgesTextSource := self newText.
	badgesTextSource 
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
			self badgesTextSource text: String empty ]
]

{ #category : #initialization }
ShBadgesPresenter >> initializeFocus [
	" Private - See superimplementor's comment "

	self focusOrder
		add: self badgeTypes;
		add: self badgesTable;
		add: self badgesTextSource;
		add: variablesTable;
		add: self toolbar
]

{ #category : #initialization }
ShBadgesPresenter >> initializeLayout [

	self layout: (SpPanedLayout newLeftToRight
		positionOfSlider: 0.2;
		add: #badgeTypes;
		add: (SpBoxLayout newTopToBottom 
			add: (	SpPanedLayout newLeftToRight
				positionOfSlider: 0.7;
				add: #badgesTable;
				add: (SpBoxLayout newTopToBottom
					add: 'Badge variables' expand: false;
					add: #variablesTable;
					yourself);
				yourself);
			add: #badgesTextSource height: 50;
			add: #badgesTextTarget height: 50;
			spacing: 4;
			add: self toolbarLayout height: self class toolbarHeight;				
			yourself);
		yourself)
]

{ #category : #initialization }
ShBadgesPresenter >> initializePresenters [
	" Private - See superimplementor's comment "

	self 
		initializeBadgesTypes;
		initializeBadgesTable;
		initializeBadgesTextSource;
		initilizeBadgesTextTarget;
		initializeVariablesPane;
		initializeActionBar;
		initializeFocus;
		initializeLayout.
]

{ #category : #initialization }
ShBadgesPresenter >> initializeVariablesPane [

	variablesTable := self newTable.
	variablesTable
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key) beSortable;
		addColumn: (SpStringTableColumn new 
			title: 'Value';
			evaluated: #value;
			beEditable;
			onAcceptEdition: [: assoc : textField | 
				self application badgeUserVariablesAt: assoc key put: textField text ]);
		showColumnHeaders;
		beResizable.
]

{ #category : #initialization }
ShBadgesPresenter >> initilizeBadgesTextSource [
		
	badgesTextSource := self newText.
	badgesTextSource beNotEditable

]

{ #category : #initialization }
ShBadgesPresenter >> initilizeBadgesTextTarget [
		
	badgesTextTarget := self newText.

]

{ #category : #private }
ShBadgesPresenter >> newCheckButton [

	^ self newButton
		  label: 'Check';
		  icon: (self iconNamed: #smallRemoteOpen);
		  help: 'Open a web browser with the selected shield badge';
		  action: [ self checkSelectedBadge ];
		  enabled: false;
		  yourself
]

{ #category : #private }
ShBadgesPresenter >> newCloseButton [

	^ self newButton
		  label: 'Quit';
		  icon: (self iconNamed: #smallQuit);
		  help: 'Close this window';
		  action: [ self window close ];
		  yourself
]

{ #category : #private }
ShBadgesPresenter >> newCopyButton [

	^ self newButton
		  label: 'Copy';
		  icon: (self iconNamed: #smallCopy);
		  help: 'Copy the Markdown text of the selected shield badge';
		  action: [ self copySelectedBadge ];
		  enabled: false;
		  yourself
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

{ #category : #initialization }
ShBadgesPresenter >> toolbarLayout [

	^ SpBoxLayout newLeftToRight
		spacing: 3;
		add: #toolbar width: 600;
		yourself
]

{ #category : #callbacks }
ShBadgesPresenter >> updateBadgePanes [

	self selectedBadgeItem ifNotNil: [ :selectedBadge | 

		| badgeText |
		badgeText := selectedBadge badgeCode.
		self updateBadgeSource: badgeText.
		self updateBadgeTarget: badgeText.
		variablesTable items: (self collectBadgeVariables: badgeText).	
		self copyButton enable.
		self checkButton enable ]
]

{ #category : #callbacks }
ShBadgesPresenter >> updateBadgeSelection: item [

	item 
		ifNil: [ self checkButton ]
		ifNotNil: [ self updateBadgePanes ]
]

{ #category : #callbacks }
ShBadgesPresenter >> updateBadgeSource: badgeText [

	self badgesTextSource text: (self buildBadgeMDUrl: badgeText).

]

{ #category : #callbacks }
ShBadgesPresenter >> updateBadgeTarget: badgeText [
	"Replace badgeText URL variables with values supplied by user and update the target text area"

	| varMappings targetBadgeText |
	
	varMappings := self collectBadgeVariables: badgeText.
	targetBadgeText := badgeText copy.
	varMappings do: [ : varName | 
		targetBadgeText := targetBadgeText 
			copyWithRegex: '\:' , varName key 
			matchesReplacedWith: varName value ].
	self badgesTextTarget text: (self buildBadgeMDUrl: targetBadgeText).

]

{ #category : #callbacks }
ShBadgesPresenter >> updateBadgesList [

	self badgesTable 
		roots: (self badgeCollector badgesAt: self selectedBadgeType)
]

{ #category : #private }
ShBadgesPresenter >> valueFor: badgeVarName [ 
	"Answer a <String> with the result of stored badge variable of badgeVarName"
	
	^ self application 
		badgeUserVariablesAt: badgeVarName
		ifAbsent: [ String empty ]
]

{ #category : #accessing }
ShBadgesPresenter >> variablesTable [

	^ variablesTable
]
