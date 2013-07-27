// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

var printlutil;

if (!printlutil) {

  printlutil = true;
  
  var isGlue = false;
  if (typeof glue !== 'undefined' && glue.glue !== undefined && glue.version != undefined) {
    isGlue = true;
  }  
  
  // spidermonkey's print == jsdb println
  // except spidermonkey print(a,b,c) adds spaces
  if (typeof println !== 'function' && !isGlue) {
    // spidermonkey, no println, def println as print
    println = print;
  }
  else {
    // jsdb, print/ln dont add spaces between arguments
    oldprint_ = print;
    if (!isGlue)
      oldprintln_ = println;
    
    // def print same as in spidermonkey
    var __print = function() {
      for (var i = 0; i < arguments.length; i++)
        oldprint_(arguments[i], ' ');
      oldprint_('\n');
    };

    if (isGlue) {
      glue.print = __print; // doesnt work, cant replace print !
      glue.println = __print;
    }
    else {
      print = __print;
      println = __print;
    }
  }

}

/*
// spidermonkey's print == jsdb println
// except print(a,b,c) adds spaces in spidermonkey
if (typeof println !== 'function') {
  // def println as print in spidermonkey (so we always use println)
  println = print;
}
else {
  // jsdb print(ln) doesnt add spaces between arguments
  // redefine it (so we always use println)
  oldprintln = println;
  println = function() {
    for (var i = 0; i < arguments.length; i++)
      print(arguments[i], ' ');
    print('\n');
  }
}

*/