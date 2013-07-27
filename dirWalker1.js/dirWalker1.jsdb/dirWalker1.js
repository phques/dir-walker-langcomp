// dirWalker1 test, javascript, JSDB engine (spiderMonkey internal)
// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

load('ooUtil.js');
load('println.js');
load('show.js');

OneDirBase = proto_(null,
{
  slots_ : { name : '', kids : [], filenames : [] },

  // 'static', use OneDirBase.readWith(path), creates object & reads
  readWith : function(dirPath) 
  {
    // separate dirPath in basePath & dirName (/home/philippe/test => [/home/philippe, test])
    var parts = dirPath.match(/(.+)\/(.+)/);
    if (!parts || parts.length != 3) {
      print("this only works if dirpath contains dir separator :-(");
      return null;
    }
    
    // create dir object & read
    var basePath = parts[1];
    var dirName = parts[2];
    var oneDir = create_(this);
    return oneDir._read(basePath, dirName);
  },
  
  // walk
  walk : function(level) {
    if (level == undefined)
      level = 0; // default val
    
    // self
    this.processDir(level);
    
    // subdirs
    this.kids.forEach(function(kid) { kid.walk(level+1); });

    // filenames
    var that = this;
    this.filenames.forEach(function(filename) { 
      that.processFile(level+1, filename);
    });
  },

  //---- overrides -----
  processDir : function(level) {},
  processFile : function(level, filename) {},
  
  //---------
  
  _setcwd : function(dir) {
    var cwd = system.cwd;
    system.cwd = dir;
    // check that we did change to the dir (use '/' path separ on both unix/windows)
    return (system.cwd.replace(/\\/g, '/') === dir);
  },
  
  
  // reads basePath/dirName directory & recurses
  _read : function(basePath, dirName) {
    //print(basePath+'/'+dirName); // debug
    
    // change to dir
    var path = basePath + '/' + dirName;
    if (!this._setcwd(path)) {
      print("can't change to dir ", path);
      return null;
    }
    
    // save name & filenames of dir
    this.name = dirName;
    this.filenames = system.files();
    
    // read kid dirs & recurse
    var proto = Object.getPrototypeOf(this);
    var folders = system.folders();
    
    for (var idx in folders) {
      // create kid object & read it & save it
      var subdir = folders[idx];
      var kid = create_(proto)._read(path, subdir);
      this.kids.push(kid);
      
      // set cwd back to here !
      system.cwd = path;
    };
    
    return this;
  }
 
});

//--------------

OneDirPrint = proto_(OneDirBase, 
{

  init_ : function() {
    // create _spaces string of > 1024 ' 's
    this._spaces = '  ';
    while (this._spaces.length < 1024)
      this._spaces += this._spaces;
  },

  spaces : function(level) { return this._spaces.substring(1, level*2); },

  //---- overrides -----
  processDir : function(level) { print(this.spaces(level) + '+' + this.name + '/'); },
  processFile : function(level, filename) { print(this.spaces(level), filename); }

});




//--- main

if (system.arguments.length == 1) {
  // always use '/' dir separ
  var dirPath = system.arguments[0].replace('\\', '/');
//~   var dir = OneDirBase.readWith(dirPath);
  var dir = OneDirPrint.readWith(dirPath);
  if (dir) {
    dir.walk();
  }
}
else {
  print('error, argument: directory to read');
}

