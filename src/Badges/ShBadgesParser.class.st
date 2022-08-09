"
Parses an URL `String` templated with badge variables names following the Shields format.

The main method is `ShBadgesParser>>collectBadgeVariables:`
"
Class {
	#name : #ShBadgesParser,
	#superclass : #Object,
	#instVars : [
		'application'
	],
	#category : #'Badges-UI'
}

{ #category : #'instance creation' }
ShBadgesParser class >> newFor: aSpApplication [

	^ self new
		application: aSpApplication;
		yourself
]

{ #category : #accessing }
ShBadgesParser >> application [

	^ application
]

{ #category : #accessing }
ShBadgesParser >> application: anObject [

	application := anObject
]

{ #category : #private }
ShBadgesParser >> collectBadgeVariables: aString [
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
ShBadgesParser >> collectBadgeVariablesFromPath: aString [
	"Answer a <Collection> of <String> where variables separated by colons are tokenized"

	^ (aString findTokens: '/')
		  select: [ :c | c beginsWith: ':' ]
		  thenCollect: #allButFirst
]

{ #category : #private }
ShBadgesParser >> valueFor: badgeVarName [ 
	"Answer a <String> with the result of stored badge variable of badgeVarName"
	
	^ self application 
		badgeUserVariablesAt: badgeVarName
		ifAbsent: [ String empty ]
]
