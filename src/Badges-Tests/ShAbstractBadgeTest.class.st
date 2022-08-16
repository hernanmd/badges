"
A ShAbstractBadgeTest is a test class for testing the behavior of ShAbstractBadge
"
Class {
	#name : #ShAbstractBadgeTest,
	#superclass : #ShBadgeAbstractTest,
	#instVars : [
		'badge'
	],
	#category : #'Badges-Tests-Core'
}

{ #category : #running }
ShAbstractBadgeTest >> badgeMockCode [

	^ '[Mock](http://img.shields.io/Mock.png)'
]

{ #category : #running }
ShAbstractBadgeTest >> badgeMockName [

	^ 'MockBadge'
]

{ #category : #running }
ShAbstractBadgeTest >> setUp [

	super setUp.
	badge := ShBadge 
		named: self badgeMockName
		code: self badgeMockCode
		img: self newMockForm.	

]

{ #category : #tests }
ShAbstractBadgeTest >> testBadgeCode [

	| badgeCode |
	
	badgeCode := badge badgeCode.
	self assert: (badgeCode isKindOf: String).
	self deny: badgeCode isEmpty.
	
	self assert: badgeCode equals: self badgeMockCode.
]

{ #category : #tests }
ShAbstractBadgeTest >> testBadgeImg [

	| badgeImg |
	
	badgeImg := badge badgeImg.
	self assert: (badgeImg isKindOf: Form).

]

{ #category : #tests }
ShAbstractBadgeTest >> testBadgeName [

	| badgeName |
	
	badgeName := badge badgeName.
	self assert: (badgeName isKindOf: String).
	self deny: badgeName isEmpty.
	
	self assert: badgeName equals: self badgeMockName.
]

{ #category : #tests }
ShAbstractBadgeTest >> testBaseUrl [

	| baseUrl |
	
	baseUrl := badge baseUrl.
	self assert: (baseUrl isKindOf: String).
	self deny: baseUrl isEmpty.
	
	self assert: (baseUrl beginsWith: 'http')
]
