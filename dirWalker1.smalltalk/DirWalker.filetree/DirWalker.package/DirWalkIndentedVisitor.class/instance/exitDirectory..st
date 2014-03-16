navigation
exitDirectory: name
	level := level - 1.
	self indent.
	self outputDirOut: name.
	level = 0 ifTrue: [ stream flush ]