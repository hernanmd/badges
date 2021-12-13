Class {
	#name : #ShAbstractBadgeCollection,
	#superclass : #Object,
	#instVars : [
		'badges'
	],
	#category : #Badges
}

{ #category : #accessing }
ShAbstractBadgeCollection class >> availableBadges [
	" Answer a <Collection> of available badges "
	
	^ self organization listAtCategoryNamed: 'accessing-badges'
]

{ #category : #'instance creation' }
ShAbstractBadgeCollection class >> new [

	^ self basicNew 
		badges: self availableBadges;
		initialize;
		yourself
]

{ #category : #'accessing-badges' }
ShAbstractBadgeCollection >> badgeMIT [

	^ '[![license-badge](https://img.shields.io/badge/license-MIT-blue.svg)](https://img.shields.io/badge/license-MIT-blue.svg)'

]

{ #category : #accessing }
ShAbstractBadgeCollection >> badgeNames [

	^ self badges collect: #yourself
]

{ #category : #'accessing-badges' }
ShAbstractBadgeCollection >> badgePR [

	^ '[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
'

]

{ #category : #'accessing-badges' }
ShAbstractBadgeCollection >> badgeRepoStatusAbandoned [

	^ '[![Project Status: Abandoned – Initial development has started, but there has not yet been a stable, usable release; the project has been abandoned and the author(s) do not intend on continuing development.](http://www.repostatus.org/badges/latest/abandoned.svg)](http://www.repostatus.org/#abandoned)'

]

{ #category : #'accessing-badges' }
ShAbstractBadgeCollection >> badgeRepoStatusActive [

	^ '[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)'

]

{ #category : #'accessing-badges' }
ShAbstractBadgeCollection >> badgeRepoStatusConcept [

	^ '[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](http://www.repostatus.org/badges/latest/concept.svg)](http://www.repostatus.org/#concept)'

]

{ #category : #'accessing-badges' }
ShAbstractBadgeCollection >> badgeRepoStatusInactive [

	^ '[![Project Status: Inactive – The project has reached a stable, usable state but is no longer being actively developed; support/maintenance will be provided as time allows.](http://www.repostatus.org/badges/latest/inactive.svg)](http://www.repostatus.org/#inactive)'

]

{ #category : #'accessing-badges' }
ShAbstractBadgeCollection >> badgeRepoStatusMoved [

	^ '[![Project Status: Moved to http://example.com – The project has been moved to a new location, and the version at that location should be considered authoritative.](http://www.repostatus.org/badges/latest/moved.svg)](http://www.repostatus.org/#moved) to [http://example.com](http://example.com)'

]

{ #category : #'accessing-badges' }
ShAbstractBadgeCollection >> badgeRepoStatusSuspended [

	^ '[![Project Status: Suspended – Initial development has started, but there has not yet been a stable, usable release; work has been stopped for the time being but the author(s) intend on resuming work.](http://www.repostatus.org/badges/latest/suspended.svg)](http://www.repostatus.org/#suspended)'

]

{ #category : #'accessing-badges' }
ShAbstractBadgeCollection >> badgeRepoStatusUnsupported [

	^ '[![Project Status: Unsupported – The project has reached a stable, usable state but the author(s) have ceased all work on it. A new maintainer may be desired.](http://www.repostatus.org/badges/latest/unsupported.svg)](http://www.repostatus.org/#unsupported)'

]

{ #category : #'accessing-badges' }
ShAbstractBadgeCollection >> badgeRepoStatusWIP [

	^ '[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)'

]

{ #category : #'accessing-badges' }
ShAbstractBadgeCollection >> badgeTravisBuildStatus [

	^ '[![Build Status](https://travis-ci.org/$1/$repo.svg?branch=master)](https://travis-ci.org/$1/$repo)"' format: { self repositoryName }

]

{ #category : #accessing }
ShAbstractBadgeCollection >> badges [
	^ badges
		ifNil: [ badges := OrderedCollection new ]
]

{ #category : #accessing }
ShAbstractBadgeCollection >> badges: anObject [
	badges := anObject
]
