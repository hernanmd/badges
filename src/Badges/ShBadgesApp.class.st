Class {
	#name : #ShBadgesApp,
	#superclass : #SpApplication,
	#instVars : [
		'badgeUserVariables'
	],
	#category : #'Badges-UI'
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
	"Answer a <Dictionary> mapping the application's badge variable names and its values"

	^ badgeUserVariables
		ifNil: [ badgeUserVariables := Dictionary new ]
]

{ #category : #accessing }
ShBadgesApp >> badgeUserVariablesAt: aVariableName [

	^ self badgeUserVariables 
		at: aVariableName
		ifAbsent: [ String empty ]
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
ShBadgesApp >> configurationFile [
	"Answer a default <FileReference> for storing user defined badge variables"

	^ (StartupPreferencesLoader preferencesGeneralFolder / 'shBadgesConfig.ston') asFileReference
]

{ #category : #accessing }
ShBadgesApp >> deleteDefinedVariables [ 
	"Remove the user defined variables in a configuration file"

	badgeUserVariables := nil.
	self saveDefinedVariables.
]

{ #category : #initialization }
ShBadgesApp >> initialize [

	super initialize.
	self flag: #HowToUseChrysal.
"	ChrysalConfigurationBuilder new 
    	defineConfigurationClassNamed: #ShBadgesConfiguration packagedIn: 'Badges-Helper'; 
    	withDescriptionItems: self itemDescriptions"
]

{ #category : #initialize }
ShBadgesApp >> itemDescriptions [

	self flag: #HowToUseChrysal.
	^ {
		(StringConfigurationItem new
			propertyName: #user;
			default: '';
			yourself) .
		(StringConfigurationItem new
			propertyName: #repo;
			default: '';
			yourself) 
		}.
]

{ #category : #accessing }
ShBadgesApp >> loadDefinedVariables [
	"Load user defined files from the default configuration file"

	| data |
	data := STON fromStream: self configurationFile readStream.
	^ data
]

{ #category : #accessing }
ShBadgesApp >> saveDefinedVariables [ 
	"Save the user defined variables in a configuration file"

	self configurationFile writeStreamDo: [ :out | 
		(STON writer on: out) nextPut: self badgeUserVariables ].
]

{ #category : #running }
ShBadgesApp >> start [
	" Private - See superimplementor's comment "

	(ShBadgesPresenter newApplication: self) openWithSpec.
]
