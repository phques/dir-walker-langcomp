// jint javascript script

import System
import System.Collections.Generic

// Ctor
function OneDir()
{
  this.dirInfo = null
  this.Kids = []
  this.Fileinfos = []
}

// use this to create root object
OneDir.prototype.Read = function(arg)
{
  if (System.IO.Directory.Exists(arg))
  {
    var dirInfo = new System.IO.DirectoryInfo(arg)
    var oneDir = this.Create()
    oneDir.walkDirInfo(dirInfo)
    return oneDir;
  }

  print("Error, " + arg + " is not a directory")
  return null
}

OneDir.prototype.Walk = function()
{
  this._walk(0)
}

OneDir.prototype.Name = function() { return this.dirInfo.Name }
OneDir.prototype.FullName = function() { return this.dirInfo.FullName }


//--------

OneDir.prototype.walkDirInfo = function(dirInfo)
{
  this.dirInfo = dirInfo
  
  if (this.dirInfo != null)
  {
    // files
    // copy to js array
    this.Fileinfos = this.dirInfo.GetFiles()
    
    // subdirs
    var subdirs = this.dirInfo.GetDirectories()
    for (var i = 0; i < subdirs.Length; i++)
    {
      var oneSudbir = this.Create()
      this.Kids.push(oneSudbir)
      
      // recurse
      oneSudbir.walkDirInfo(subdirs[i])
    }
  }
  else
  {
    print('oops')
  }
}

OneDir.prototype._walk = function _walk(level)
{
  this.ProcessDir(level)
  
  for (var i in this.Kids)
  {
    var kid = this.Kids[i]
    kid._walk(level+1)
  }
  
  for (var i in this.Fileinfos)
  {
    var fileinfo = this.Fileinfos[i]
    this.ProcessFile(fileinfo.Name, level)
  }
}

// virtuals to override
OneDir.prototype.Create = function()
{
  return new OneDir()
}

OneDir.prototype.ProcessDir = function(level) { print("ProcessDir ") }
OneDir.prototype.ProcessFile = function(filename, level) { print("ProcessFile") }




//=========================

DirWalker.baseCTOR = OneDir
DirWalker.prototype = new DirWalker.baseCTOR()
function DirWalker()
{
  DirWalker.baseCTOR.call(this)
}

// overrides
DirWalker.prototype.Create = function()
{
  return new DirWalker()
}

DirWalker.prototype.ProcessDir = function(level)
{
  var spaces = new System.String(' ',level*2)
  Console.WriteLine("{0}+{1}/", spaces,  this.Name())
}

DirWalker.prototype.ProcessFile = function(filename, level)
{
  var spaces = new System.String(' ',(level+1)*2)
  Console.WriteLine("{0}{1}", spaces,  filename)
}


//=========================


function doit()
{
  var args = System.Environment.GetCommandLineArgs()

  if (args.Length == 2)
  {
    // factory !
//~     var oneDirFactory = new OneDir()
    var oneDirFactory = new DirWalker()
    var rootDir = oneDirFactory.Read(args[1])
    if (rootDir)
    {
      print('------')
      print(rootDir.FullName())
      print('------')
      rootDir.Walk()
    }
  }
  else
  {
    print("missing argument: rootDirectoryToScan")
  }
  
}

doit()

