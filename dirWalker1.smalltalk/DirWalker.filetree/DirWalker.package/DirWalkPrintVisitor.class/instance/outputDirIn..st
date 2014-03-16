output implementation
outputDirIn: name
	stream
		nextPutAll: '+' , name , '/';
		cr