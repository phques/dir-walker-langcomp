navigation
enterDirectory: name
	self indent.
	self outputDirIn: name.
	level := level + 1