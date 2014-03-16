navigating
walkWith: visitor
	visitor enterDirectory: self basename.
	children do: [ :kid | kid walkWith: visitor ].
	filenames do: [ :filename | visitor processFile: filename ].
	visitor exitDirectory: self basename