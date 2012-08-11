// jint javascript script

//System.Console.WriteLine('allo toi')

// Ctor
function OneDir(_dirInfo)
{
  this.dirInfo = _dirInfo
  this.Kids = []
  this.Filenames = []
  
  //this.Filenames = new System.Collections.Generic.List<string>()
  
  print(_dirInfo.FullName)
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
      this.Kids.push(oneSudbir)
    }
  }
  else
  {
    print('oops')
  }
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
    }
  }
  else
  {
    print("missing argument: rootDirectoryToScan")
  }
  
}

doit()
