output implementation
outputFile: name
	stream
		nextPutAll: '<file>', name, '</file>';
		cr