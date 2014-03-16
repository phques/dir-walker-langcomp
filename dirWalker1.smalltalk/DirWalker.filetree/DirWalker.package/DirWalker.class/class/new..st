instance creation
new: stringPath
	""

	| dirFileRef |
	dirFileRef := stringPath asFileReference.
	dirFileRef isDirectory ifFalse: [ self error: 'Not a directory: ', stringPath ].
	
	^ self new readAt: dirFileRef.
	