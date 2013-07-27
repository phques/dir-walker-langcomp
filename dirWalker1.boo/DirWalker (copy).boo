namespace dirWalker1

// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

import System
import System.IO


class OneDirBase:

	Name as string:
		get: return _dirInfo.Name
		
	FullName as string:
		get: return _dirInfo.FullName
		
	//_fileinfos as List[of string]
	_fileinfos as (FileInfo)
	_kids as List[of OneDirBase]
	_dirInfo as DirectoryInfo

	#-----------------
	
	// used for factory objects
	public def constructor():
		print 'base empty ctor'
#		pass
		
	protected def constructor(dirInfo as DirectoryInfo):
		print 'base real ctor'
		_dirInfo = dirInfo
		_kids = List[of OneDirBase]()
		_fileinfos = array(FileInfo, 0)
		walkDirInfo()

	private def walkDirInfo():
		if _dirInfo != null:
			// files
			_fileinfos = _dirInfo.GetFiles()
			
			// subdirs
			subdirs = _dirInfo.GetDirectories()
			for subdirInfo in subdirs:
				oneSubdir = Create(subdirInfo)
				_kids.Add(oneSubdir)
		else:
			print 'oops'
	
	#----------------
	
	private def _walk(level as int):
		processDir(level)
		
		for kid in _kids:
			kid._walk(level+1)
		
		for fileinfo in _fileinfos:
			processFilename(fileinfo.Name, level)
	
	public def walk():
		_walk(0)

	#----------------
	
	// overide this
	virtual protected def processDir(level as int):
		pass
		
	virtual protected def processFilename(filename as string, level as int):
		pass
		
	virtual protected def Create(dirInfo as DirectoryInfo) as OneDirBase  :
		return OneDirBase(dirInfo)

	public def Create(arg as string) as OneDirBase:
	"""use this to create root object"""
		if not System.IO.Directory.Exists(arg):
			print "Error, ${arg} is not a directory"
			return null
		else:
			return Create(DirectoryInfo(arg))

#-----------------

class DirWalkerPrint(OneDirBase):
	public def constructor():
		pass
		
	private def constructor(dirInfo as DirectoryInfo):
		super(dirInfo)
	
	override protected def Create(dirInfo as DirectoryInfo) as OneDirBase  :
		return DirWalkerPrint(dirInfo)

	override protected def processDir(level as int):
		spaces = String(" "[0], level*2)
		print "${spaces}+${self.Name}/"

	override protected def processFilename(filename as string, level as int):
		spaces = String(" "[0], (level+1)*2)
		print "${spaces}${filename}"
		
		
#-----------------

def doit():
	
	// get argument to program.
	args = Environment.GetCommandLineArgs()

	if args.Length == 2:
		print "arg=${args[1]}"
#		factory = OneDirBase()
		factory = DirWalkerPrint()
		rootDir = factory.Create(args[1])
		
		if rootDir:
			rootDir.walk()
	else:
		print "missing argument: rootDirectoryToScan"


doit()
Console.ReadKey() 
