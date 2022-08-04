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
		'badgesTextTarget',
		'badgeTextTemplate',
		'variablesToolbar',
		'badgeParser',
		'allVariablesTable'
	],
	#category : #'Badges-UI'
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
	"Answer a <Collection> of <ShBadge> collected from the Shields.io website"

	^ badgesCollector
		ifNil: [ badgesCollector := ShBadgeCollector new ]
]

{ #category : #private }
ShBadgesPresenter >> badgeParser [

	^ badgeParser 
		ifNil: [ badgeParser := ShBadgesParser newFor: self application ]
]

{ #category : #accessing }
ShBadgesPresenter >> badgeTextTemplate [
	" Answer a text widget of this presenter to display the original template for the selected badge "

	^ badgeTextTemplate
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

	^ self badgeParser collectBadgeVariables: aString
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

{ #category : #callbacks }
ShBadgesPresenter >> deleteDefinedVariables [
	"Delete defined variables for the current application"
	
	self application deleteDefinedVariables.
	self inform: 'Done'.
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
ShBadgesPresenter >> initializeBadgeTextTemplate [
		
	badgeTextTemplate := self newText.
	badgeTextTemplate 
		beNotEditable
]

{ #category : #initialization }
ShBadgesPresenter >> initializeBadgeVariablesPanes [

	variablesTable := self newTable.
	variablesTable
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key) beSortable;
		addColumn: (SpStringTableColumn new 
			title: 'Value';
			evaluated: [ : val | self application badgeUserVariablesAt: val key ];
			beEditable;
			onAcceptEdition: [: assoc : textField | 
				self application badgeUserVariablesAt: assoc key put: textField text.
				allVariablesTable update ]);
		showColumnHeaders;
		beResizable.
	allVariablesTable := self newTable.
	allVariablesTable
		addColumn: (SpStringTableColumn new
			title: 'Name'; 
			evaluated: #key) beSortable;
		addColumn: (SpStringTableColumn new 
			title: 'Value';
			evaluated: #value;
			beEditable);
		items: self application badgeUserVariables;
		showColumnHeaders;
		beResizable.
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
ShBadgesPresenter >> initializeBadgesTypes [

	self badgeTypes: self newList.
	self badgeTypes
		headerTitle: 'Badge types';
		items: self badgesCategories asSortedCollection;
		selectIndex: 1;
		whenSelectionChangedDo: [ 
			self badgeTypes selectedItem ifNotNil: [ self updateNewBadgeTypeSelected ].
			self checkButton disable.
			self copyButton disable.
			self badgeTextTemplate text: String empty ]
]

{ #category : #initialization }
ShBadgesPresenter >> initializeFocus [
	" Private - See superimplementor's comment "

	self focusOrder
		add: self badgeTypes;
		add: self badgesTable;
		add: self badgeTextTemplate;
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
					add: 'All variables' expand: false;
					add: #allVariablesTable;
					add: #variablesToolbar height: self class toolbarHeight;					
					yourself);
				yourself);
			add: #badgeTextTemplate height: 50;
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
		initializeBadgeTextTemplate;
		initilizeBadgesTextTarget;
		initializeBadgeVariablesPanes;
		initializeVariablesToolbar;
		initializeActionBar;
		initializeFocus;
		initializeLayout.
]

{ #category : #initialization }
ShBadgesPresenter >> initializeVariablesToolbar [

	variablesToolbar := self newToolbar
		addItem: (SpToolbarButtonPresenter new
			label: 'Browse';
			icon: (self iconNamed: #catalog);
			help: 'Browse all defined variables';
			action: [ self application badgeUserVariables inspect];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			label: 'Save';
			icon: (self iconNamed: #smallSave);
			help: 'Save current variables as global';
			action: [ self saveDefinedVariables ];
			yourself);
		addItem: (SpToolbarButtonPresenter new
			label: 'Clear';
			icon: (self iconNamed: #smallDelete);
			help: 'Clear all variables';
			action: [ self deleteDefinedVariables ];
			yourself);			
		yourself.	
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

{ #category : #callbacks }
ShBadgesPresenter >> saveDefinedVariables [
	"Save defined variables for the current application"
	
	self application saveDefinedVariables.
	self inform: 'Done'.
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

	self badgeTextTemplate text: (self buildBadgeMDUrl: badgeText).

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
ShBadgesPresenter >> updateNewBadgeTypeSelected [
	"Private - A new badge type has been selected, clear and update all related panes"

	self badgesTable roots: (self badgeCollector badgesAt: self selectedBadgeType).
	self badgeTextTemplate clearContent.
	self badgesTextTarget clearContent.
	self variablesTable items: Array empty.
]

{ #category : #accessing }
ShBadgesPresenter >> variablesTable [

	^ variablesTable
]
