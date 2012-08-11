// jint javascript script

import System
import System.Collections.Generic

// Ctor
function OneDir(_dirInfo)
{
  this.dirInfo = _dirInfo
  this.Kids = []
  this.Fileinfos = []
  
//~   print(_dirInfo.FullName)
  this.walkDirInfo()
}

OneDir.prototype.Name = function()
{
  return this.dirInfo.Name
}
OneDir.prototype.FullName = function()
{
  return this.dirInfo.FullName
}

OneDir.prototype.walkDirInfo = function()
{
  if (this.dirInfo != null)
  {
    // files
    // copy to js array
    this.Fileinfos = this.dirInfo.GetFiles()
    
    // subdirs
    var subdirs = this.dirInfo.GetDirectories()
    for (var i = 0; i < subdirs.Length; i++)
    {
      var subdirInfo = subdirs[i]
      var oneSudbir = new OneDir(subdirInfo)
      this.Kids.push(oneSudbir)
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

OneDir.prototype.Walk = function()
{
  this._walk(0)
}

OneDir.prototype.ProcessDir = function(level)
{
//~   print(oneDirKid.FullName())
  var spaces = new System.String(' ',level*2)
  Console.WriteLine("{0}+{1}/", spaces,  this.Name())
}

OneDir.prototype.ProcessFile = function(filename, level)
{
//~   print(filename)
  var spaces = new System.String(' ',(level+1)*2)
  Console.WriteLine("{0}{1}", spaces,  filename)
}


// 'static class method', use this create root object
OneDir.Create = function(arg)
{
  if (System.IO.Directory.Exists(arg))
  {
    var dirInfo = new System.IO.DirectoryInfo(arg)
    return new OneDir(dirInfo)
  }

  print("Error, " + arg + " is not a directory")
  return null
}


function doit()
{
  var args = System.Environment.GetCommandLineArgs()

  if (args.Length == 2)
  {
    var rootDir = OneDir.Create(args[1])
    if (rootDir)
    {
      print('------')
      print(rootDir.FullName())
      for (var filename in rootDir.Fileinfos)
        print(filename)

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

