Class {
	#name : #BaselineOfBadges,
	#superclass : #BaselineOf,
	#category : #BaselineOfBadges
}

{ #category : #baselines }
BaselineOfBadges >> baseline: spec [
  <baseline>
	spec
		for: #(common)
		do: [ 
			spec preLoadDoIt: #preLoad.	
			self soup: spec.
			self stringExtensions: spec.
			"self chrysal: spec."
	
			spec 
				package: 'Badges'			with: [ spec requires: #(Soup StringExtensions) ];
				package: 'Badges-Tests'	with: [ spec requires: #(Badges) ].
			spec 
				group: 'Core' 						with: #('Badges');
				group: 'Tests' 						with: #('Badges' 'Badges-Tests');
				group: 'default' 					with: #('Tests') ]
]

{ #category : #preloading }
BaselineOfBadges >> ensureMetacelloFileDownload [
   
	Metacello new           
		baseline: 'MetacelloFileDownload';              
		repository: 'github://hernanmd/MetacelloFileDownload';          
		load.
]

{ #category : #preloading }
BaselineOfBadges >> platformFilesUrl [

	^ Array with: (String streamContents: [ : stream |		
		stream
			nextPutAll: 'https://github.com/hernanmd/resources/raw/main/shields.zip' ])
	
]

{ #category : #preloading }
BaselineOfBadges >> preLoad [

	self ensureMetacelloFileDownload.
	super preLoad.
]

{ #category : #baselines }
BaselineOfBadges >> soup: spec [ 

	spec 
		baseline: 'Soup'
		with: [ spec 
			repository: 'github://seandenigris/Soup-for-Pharo/repository';
			loads: 'Core' ]
]

{ #category : #baselines }
BaselineOfBadges >> stringExtensions: spec [

	spec
		baseline: 'StringExtensions' 
		with: [ spec repository: 'github://hernanmd/StringExtensions/repository' ].
]
