"
A badge is a validated indicator of accomplishment, skill, quality or interest that can be earned in various learning environments.

This class represents a badge obtained through the badge generation service Shields.io.

## Examples

A custom badge:

```language=pharo
ShBadge custom
	subject: 'Test';
	status: 'Status';
	color: Color red;
	getBadge.
```

Generate a Shield badge for a Github repository:

```language=pharo
(CGShieldsBadge for: #travisOrg)
	repository: 'ProjectFramework';
	user: 'hernanmd';
	getBadge.
```

CGShieldsBadge forTravisBranch
	repository: 'BioSmalltalk';
	user: 'hernanmd';
	branch: 'dev';
	getBadge.

    Instance Variables
	badgeImg:		<Object>
	badgeName:		<Object>
	color:		<Object>
	colorA:		<Object>
	colorB:		<Object>
	logo:		<Object>
	status:		<Object>
	style:		<Object>
	subject:		<Object>


    Implementation Points
"
Class {
	#name : #ShBadge,
	#superclass : #ShAbstractBadge,
	#category : #'Badges-Core'
}

{ #category : #'accessing - url' }
ShBadge class >> baseUrl [
	" Answer a <String> with the receiver's base url "

	^ 'https://img.shields.io'
]
