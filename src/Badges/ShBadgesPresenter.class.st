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
		'allVariablesTable',
		'stylingTable',
		'badgesImageTarget'
	],
	#category : #'Badges-UI'
}

{ #category : #'instance creation' }
ShBadgesPresenter class >> open [
	" Open the badges selection window "
	<script>

	self basicNew 
		initialize;
		open.
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
ShBadgesPresenter >> badgeUserVariables [

	^ self application badgeUserVariables
]

{ #category : #initialization }
ShBadgesPresenter >> badgeUserVariables: aDictionary [

	self application badgeUserVariables: aDictionary
]

{ #category : #accessing }
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

	| fullUrl |
	
	fullUrl := ShBadge baseUrl , text.
	^ String streamContents: [ : stream |
		stream
			<< '[![';
			<< self buildBadgeMDText;
			<< '](';
			<< fullUrl;
			<< ')](';
			<< fullUrl;
			<< $) ]
]

{ #category : #private }
ShBadgesPresenter >> builtBadgeMarkdownText [
	"Answer a <String> with the formatted Markdown image for the built badge"

	^ badgesTextTarget text
]

{ #category : #accessing }
ShBadgesPresenter >> checkButton [
	" Answer the receiver's <SpButtonPresenter> for the Check Badge "

	^ self toolbar presenters detect: [ : btn | btn label = 'Get' ]
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

	Clipboard clipboardText: self builtBadgeMarkdownText.
	self inform: 'Copied to clipboard'
]

{ #category : #callbacks }
ShBadgesPresenter >> deleteDefinedVariables [
	"Delete defined variables for the current application"
	
	(self confirm: 'This will clear all variables from the store.
Are you sure?')
		ifFalse: [ ^ self ].
	self application deleteDefinedVariables.
	allVariablesTable items: self badgeUserVariables associations.
	self inform: 'Cleared all variables'.
]

{ #category : #callbacks }
ShBadgesPresenter >> getSelectedBadge [
	"Private - Callback for get badge button"

	| badgeGetUrl |
	
	badgeGetUrl := self urlBuilder parseGetUrl: self builtBadgeMarkdownText.
	(self urlBuilder validateGetUrl: badgeGetUrl)
		ifFalse: [ badgesImageTarget image: (ZnEasy getPng: (self urlBuilder buildGetPngUrl: badgeGetUrl)) ]
		ifTrue: [ self inform: 'Not a valid target to get a badge' ].

]

{ #category : #initialization }
ShBadgesPresenter >> initialExtent [
	"Answer the initial extent for the receiver."
	
	^ 900 @ 600

]

{ #category : #initialization }
ShBadgesPresenter >> initializeActionBar [

	| closeButton checkButton copyButton |
	closeButton := self newCloseButton.
	checkButton := self newGetButton.
	copyButton := self newCopyButton.

	toolbar := self newButtonBar
		placeAtEnd;
		add: checkButton;
		add: copyButton;
		add: closeButton;
		yourself
]

{ #category : #initialization }
ShBadgesPresenter >> initializeAllBadgeVariablesPanes [

	allVariablesTable := self newTable.
	allVariablesTable
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #key) beSortable;
		addColumn: (SpStringTableColumn new 
			title: 'Value';
			evaluated: #value);
		showColumnHeaders;
		beResizable.

]

{ #category : #initialization }
ShBadgesPresenter >> initializeBadgePreviewTarget [

	badgesImageTarget := self newImage.
]

{ #category : #initialization }
ShBadgesPresenter >> initializeBadgeTextTarget [
		
	badgesTextTarget := self newText.

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
				 evaluated: [ :val | 
					 self application badgeUserVariablesAt: val key ];
				 beEditable;
				 onAcceptEdition: [ :assoc : text | self updateBadgeVariable: assoc value: text ]);
		showColumnHeaders;
		beResizable
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
		add: stylingTable;
		add: allVariablesTable;
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
					"add: 'Styling' expand: false;
					add: #stylingTable;"
					add: 'All variables' expand: false;
					add: #allVariablesTable;
					add: #variablesToolbar height: self class toolbarHeight;					
					yourself);
				yourself);
			add: 'Template' height: self class labelHeight;
			add: #badgeTextTemplate height: 50;
			add: 'Markdown' height: self class labelHeight;
			add: #badgesTextTarget height: 50;
			add: 'Preview' height: self class labelHeight;
			add: #badgesImageTarget height: 50;			
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
		initializeBadgeTextTarget;
		initializeBadgePreviewTarget;
		initializeBadgeVariablesPanes;
		initializeAllBadgeVariablesPanes;
		initializeVariablesToolbar;
		"initializeStylingPanes;"
		initializeActionBar;
		initializeFocus;
		initializeLayout.
]

{ #category : #initialization }
ShBadgesPresenter >> initializeVariablesToolbar [

	variablesToolbar := self newToolbar
		                    addItem: (SpToolbarButtonPresenter new
				                     label: 'Load';
				                     icon: (self iconNamed: #catalog);
				                     help: 'Load variables from a .ston file';
				                     action: [ self loadDefinedVariables ];
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
		                    yourself
]

{ #category : #initialization }
ShBadgesPresenter >> loadDefinedVariables [

	(UIManager default
		chooseExistingFileReference: 'Select a .ston file with badge variables' 
		extensions: #('ston')
		path: StartupPreferencesLoader preferencesGeneralFolder)
			ifNotNil: [ : selection | 
				self application 
					configurationFile: selection;
					loadDefinedVariables.
				allVariablesTable items: self badgeUserVariables associations ]
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

{ #category : #private }
ShBadgesPresenter >> newGetButton [

	^ self newButton
		  label: 'Get';
		  icon: (self iconNamed: #smallRemoteOpen);
		  help: 'Preview the selected shield badge';
		  action: [ self getSelectedBadge ];
		  enabled: false;
		  yourself
]

{ #category : #callbacks }
ShBadgesPresenter >> saveDefinedVariables [
	"Save defined variables for the current application"
	
	self application saveDefinedVariables.
	self inform: 'Done'.
]

{ #category : #callbacks }
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
		add: #toolbar;
		yourself
]

{ #category : #callbacks }
ShBadgesPresenter >> updateBadgePanes [

	self selectedBadgeItem ifNotNil: [ :selectedBadge | 
		self updateForSelectedBadge: selectedBadge.
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
			matchesReplacedWith: (varName value 
				ifEmpty: [ ':' , varName key ]
				ifNotEmpty: [ varName value ]) ].
	self badgesTextTarget text: (self buildBadgeMDUrl: targetBadgeText).

]

{ #category : #initialization }
ShBadgesPresenter >> updateBadgeVariable: assoc value: text [
	"Private - User has pressed enter to accept a new variable value"

	self application
		 badgeUserVariablesAt: assoc key
		 put: text.
	allVariablesTable items: self badgeUserVariables associations.
	self updateBadgeTarget: self selectedBadgeItem badgeCode.
]

{ #category : #callbacks }
ShBadgesPresenter >> updateForSelectedBadge: selectedBadge [

	| badgeText |

	badgeText := selectedBadge badgeCode.
	self updateBadgeSource: badgeText.
	self updateBadgeTarget: badgeText.
	variablesTable items: (self collectBadgeVariables: badgeText).

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
ShBadgesPresenter >> urlBuilder [

	^ ShBadgesUrlBuilder new
]

{ #category : #accessing }
ShBadgesPresenter >> variablesTable [

	^ variablesTable
]
