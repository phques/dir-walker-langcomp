// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

function showHierarchy(o) {
//~ return;
  var indent = "";
  while (o) {
    println(indent, Name(o));
    o = Object.getPrototypeOf(o);
    indent += "  ";
  }
}


function show1(o) {
  println('show1:');
  for (var p in o) {
    println(o.hasOwnProperty(p) ? "  o" : "  h", p);
  }
}

function show2(o) {
  println('show2:');
  for (var p in o) {
    if (o.hasOwnProperty(p)) {
      var v = o[p];
      if (typeof v == 'object') v = JSON.stringify(v);
      println(' ', p, ':', v) 
    }
  }
}
