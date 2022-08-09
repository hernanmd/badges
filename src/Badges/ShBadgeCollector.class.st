"
Builds a Collection of badges collected from the Shields.io website.

Internal Representation and Key Implementation Points.

    Instance Variables
	badges:		<Object>


    Implementation Points
"
Class {
	#name : #ShBadgeCollector,
	#superclass : #Object,
	#instVars : [
		'badges',
		'soupTable'
	],
	#category : #'Badges-Core'
}

{ #category : #accessing }
ShBadgeCollector >> badgeCategories [
	" Answer a <Collection> of <String> with the available badge categories for the receiver "
	
	^ #(
		'Build'
		'Chat'
		'Dependencies'
		'Downloads'
		'Funding'
		'Issue Tracking'
		'License'
		'Rating'
		'Social'
		'Version'
		'Other'
		'Platform Support'
		'Monitoring'
		'Activity'
		'Size'
		'Analysis'
		'Coverage'
		)
]

{ #category : #accessing }
ShBadgeCollector >> badgeImageAt: imgURLString [
	" Answer a <Form> located at the receiver's endpoint imgURLString "

	^ [ ZnEasy getPng: (self buildPngURLString: imgURLString) ]
		on: ZnUnexpectedContentType 
		do: [ : ex | 
			self trace: imgURLString , ' is not a PNG image and could not be displayed in the Badges Navigator'. 
			nil ]
	

]

{ #category : #accessing }
ShBadgeCollector >> badges [
	"Answer a <ShBadgeCollection> instance"

	^ badges
		ifNil: [ badges := ShBadgeFileCollection new ]
]

{ #category : #accessing }
ShBadgeCollector >> badgesAt: badgesCategory [ 
	" Answer a <Collection> of <ShBadge> of category String badgesCategory "

	^ self badges badgesAt: badgesCategory
]

{ #category : #accessing }
ShBadgeCollector >> buildPngURLString: aString [

	^ String streamContents: [ : stream |
			stream 
				<< ShBadge baseUrl;
				<< (((aString copyWithoutAll: '"') withoutPrefix: '/') withoutSuffix: '/');
				<< '.png' ]
			

]

{ #category : #accessing }
ShBadgeCollector >> collectAllBadges [
	" Answer a <Collection> of all available <CGShieldsBadge> "

	| badgesDict |
	badgesDict := Dictionary new.
	[ : job | 
		job title: 'Collecting Badges'.
		self badgeCategories doWithIndex: [ : badgeCat : index |
			job 
				progress: (0.1 * index); 
				title: badgeCat printString.
			badgesDict 
				at: badgeCat 
				put: (self collectBadgesAt: badgeCat asLowercase).
		] ]  asJob run.
	^ badgesDict 

]

{ #category : #accessing }
ShBadgeCollector >> collectBadgesAt: categoryName [
	" Answer a <Collection> of <ShBadge> for categoryName "

	| tmpBadges |			

	tmpBadges := OrderedCollection new: 50.
	(self selectBadgeExamplesAt: categoryName asLowercase)
		do: [ : t | self collectBadgesFromTable: t into: tmpBadges ]
		displayingProgress: 'Please wait while retrieving shield badges...'.
	^ tmpBadges

]

{ #category : #accessing }
ShBadgeCollector >> collectBadgesFromTable: t into: tmpBadges [

	t childTagsDo: [ : tBody |
		tBody childTagsDo: [ : tr | 
			| rowElems |
			rowElems := tr children.
			tmpBadges add: (self
				newBadgeNamed: rowElems first next text
				code: rowElems third next text
				img: (rowElems second next next attributeAt: 'src')) ] ]
]

{ #category : #accessing }
ShBadgeCollector >> newBadgeNamed: nameString code: codeString img: imgURLString [
	" Add a new shields badge identified by nameString with image located at imgURLString "

	^ ShBadge 
		named: nameString 
		code: codeString
		img: (self badgeImageAt: imgURLString)
]

{ #category : #accessing }
ShBadgeCollector >> newBadgeNamed: nameString code: codeString imgForm: aForm [
	" Add a new shields badge identified by nameString with image aForm "

	^ ShBadge 
		named: nameString 
		code: codeString
		img: aForm
]

{ #category : #accessing }
ShBadgeCollector >> selectBadgeExamplesAt: categoryName [
	" Retrieve and parse shields at categoryName <String>. Answer a <Collection> with the badges"

	| shieldsCatName |
	
	shieldsCatName := categoryName copyReplaceAll: ' ' with: '-'.
	^ ((Soup fromUrl: self shieldsUrl , shieldsCatName) findAllTags: 'table') 
			select: [ :t | (t hasAttribute: 'class') and: [ t @ 'class' beginsWith: 'badge-examples' ] ]
]

{ #category : #accessing }
ShBadgeCollector >> shieldsUrl [

	^ ShBadge baseUrl , '/'
]
