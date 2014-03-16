output implementation
outputDirIn: name
	stream
		nextPutAll: '<dir name="' , name , '">';
		cr