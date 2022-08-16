Extension { #name : #SpImageTableColumn }

{ #category : #'*Badges' }
SpImageTableColumn class >> example [

	SpTablePresenter new
		addColumn:
			((SpImageTableColumn title: 'Icon' evaluated: #systemIcon)
				width: 50;
				yourself);
		addColumn: (SpStringTableColumn title: 'Name' evaluated: #name);
		items: self class environment allClasses;
		beResizable;
		open.
]
