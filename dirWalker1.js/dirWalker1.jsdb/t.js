
load('println.js');
load('show.js');

function setcwd(dir) {
  var cwd = system.cwd;
  system.cwd = dir;
  return (system.cwd === dir)
}

if (system.arguments.length == 1) {
  var dir = system.arguments[0];
  
  aa = system.attributes(dir);
  show2(aa);
  
  if (setcwd(dir)) {
    print(aa);
    aa.forEach(function(v) { print(v); } );
    
    print('------');
    print(aa);
    aa.forEach(function(v) { print(v); } );
  }
  else {
    print('unable to chdir to', dir);
  }
}

