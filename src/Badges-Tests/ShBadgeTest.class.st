Class {
	#name : #ShBadgeTest,
	#superclass : #TestCase,
	#instVars : [
		'badge'
	],
	#category : #'Badges-Tests'
}

{ #category : #accessing }
ShBadgeTest >> badge [
	" Answer the badge of this ShBadgeTest "

	^ badge
]

{ #category : #accessing }
ShBadgeTest >> badge: anObject [
	" Sets the badge of this ShBadgeTest "

	badge := anObject
]

{ #category : #running }
ShBadgeTest >> badgeName [

	^ 'MyCoolBadge'
]

{ #category : #running }
ShBadgeTest >> setUp [

	super setUp.
	badge := ShBadge 
		named: self badgeName
		code: '/service/commit-activity/:interval/:user/:repo/:branch*'
		img: (Form extent: 100 @ 100 depth: 1)

]

{ #category : #tests }
ShBadgeTest >> testBadgeCode [

	self assert: (badge badgeCode isKindOf: String).
	self deny: badge badgeCode isEmpty.
]

{ #category : #tests }
ShBadgeTest >> testBadgeImg [

	self assert: (badge badgeImg isKindOf: Form).

]

{ #category : #tests }
ShBadgeTest >> testBadgeName [

	self assert: badge badgeName equals: self badgeName.

]

{ #category : #tests }
ShBadgeTest >> testBaseUrl [

	self assert: (badge class baseUrl isKindOf: String).
	self assert: badge class baseUrl equals: 'https://img.shields.io'
]
