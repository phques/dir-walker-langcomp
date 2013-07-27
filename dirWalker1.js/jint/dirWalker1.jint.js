// jint javascript script
// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

//System.Console.WriteLine('allo toi')

// Ctor
function OneDir(_dirInfo)
{
  this.dirInfo = _dirInfo
  this.Kids = new System.Collections.Generic.List{System.Object}()
  this.Filenames = []
  
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
    this.Filenames = this.dirInfo.GetFiles()
    
    // subdirs
    var subdirs = this.dirInfo.GetDirectories()
    for (var subdirInfo in subdirs)
    {
      var oneSudbir = new OneDir(subdirInfo)
      this.Kids.Add(oneSudbir)
    }
  }
  else
  {
    print('oops')
  }
}

OneDir.prototype.Walk = function()
{
  function _walk(oneDir, level)
  {
    this.ProcessKid(oneDir, level)
    
    for (var kid in oneDir.Kids)
    {
      this.ProcessKid(kid, level)
      _walk(kid, level+1)
    }
    
    for (var filename in oneDir.Filenames)
    {
      this.ProcessFile(filename, level)
    }
  }
  
  _walk(this, 0)
}

OneDir.prototype.ProcessKid = function(oneDirKid, level)
{
  print('processkid -->')
  print(oneDirKid)
  print(oneDirKid.FullName())
  print('<-- processkid')
}

OneDir.prototype.ProcessFile = function(filename, level)
{
  print(filename)
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
  if (args.Length == 3)
  {
    var rootDir = OneDir.Create(args[2])
    if (rootDir)
    {
      print('------')
      print(rootDir.FullName())
      for (var filename in rootDir.Filenames)
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
