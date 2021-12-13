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
			spec 
				package: 'Badges';
				package: 'Badges-Tests'	with: [ spec requires: #(Badges) ].
			spec 
				group: 'Core' 						with: #('Badges');
				group: 'Tests' 						with: #('Badges' 'Badges-Tests');
				group: 'default' 					with: #('Core' 'Tests') ]
]

{ #category : #baselines }
BaselineOfBadges >> soup: spec [ 

	spec 
		baseline: 'Soup'
		with: [ spec repository: 'github://Ducasse/Soup/repository' ]
]
