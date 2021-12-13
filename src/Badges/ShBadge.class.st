"
A badge is a validated indicator of accomplishment, skill, quality or interest that can be earned in various learning environments.

This class provides attributes related with a Shields.io badge.

A custom badge:

CGShieldsBadge custom
	subject: 'Test';
	status: 'Status';
	color: Color red;
	getBadge.

(CGShieldsBadge for: #travisOrg)
	repository: 'ProjectFramework';
	user: 'hernanmd';
	getBadge.

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
	#category : #Badges
}

{ #category : #'instance creation' }
ShBadge class >> for: serviceSelector [
	" Answer a new instance of the receiver configured for serviceSelector service "

	^ self new
		service: serviceSelector uncapitalized;
		yourself.
]

{ #category : #'instance creation' }
ShBadge class >> named: nameString code: codeString img: aFormOrNil [
	" Answer a new instance receiver with nameString as name and imgStringOrNil as the representative image "

	^ self new
		badgeName: nameString;
		badgeCode: codeString;
		badgeImg: aFormOrNil;
		yourself
]

{ #category : #'instance creation' }
ShBadge class >> named: nameString img: aFormOrNil [
	" Answer a new instance receiver with nameString as name and imgStringOrNil as the representative image "

	^ self new
		badgeName: nameString;
		badgeImg: aFormOrNil;
		yourself
]

{ #category : #'accessing - url' }
ShBadge >> baseUrl [
	" Answer a <String> with the receiver's base url "

	^ 'https://img.shields.io/'
]

{ #category : #printing }
ShBadge >> printOn: aStream [
	" Private - See superimplementor's comment "
	
	aStream 	
		<< $(
		<< badgeName asString
		<< $) 
]
