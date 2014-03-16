private tree building
readAt: dirFileRef
	"reads directory, recursing into child dirs"

	path := dirFileRef path.
	filenames := dirFileRef fileNames.
	children := dirFileRef directories collect: [ :kidDirRef | self class new readAt: kidDirRef ]