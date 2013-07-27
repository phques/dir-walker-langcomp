// DirWalker project
// Copyright 2013 Philippe Quesnel
// Licensed under the Academic Free License version 3.0

/* Utility functions for prototype OO,
 using javascript 1.5 Object.create, 
 and Object.getPrototypeOf(), xx.hasOwnProperty()

 this version only uses basic Object.create(baseProto); 
 w/o the second arg for new properties to be added
 
 nb: DONT use A.prototype, use proto_(A) (ie Object.getPrototypeOf), they are not the same !
 
 Works with spiderMonkey, jsdb, and now, gluescript
 cf bellow for replacement functions for Object.create() etc...
*/


//=================

// do we have Object.create() ?

// Crockford,  modified PQ 2011-09
// ## Note, as of JS 5, ths is supported natively (and w. more functionality)
// pq: re-use fixed function object to avoid creation of temp dummy ctor function
if (typeof Object.create !== 'function') {
    function F__() {}
    Object.create = function (proto) {
        F__.prototype = proto;
        return new F__();
    };
// orig Crockford:
//~     Object.create = function (o) {
//~         function F() {}
//~         F.prototype = o;
//~         return new F();
//~     };
}

// do we have Object.getPrototypeOf ??
// we should in our code : protoOf_()
if (typeof Object.getPrototypeOf == 'function') {
  // yes, use it
  protoOf_ = Object.getPrototypeOf;
}
else {
  // works because WE set .prototype__ when creating objs/protos
  // (of course if called w. obj not from create_() ... tough luck !
  protoOf_ = function(o) { return o.prototype__; }
}


// do we have JSON ? (only JSON.stringify needed actually)
if (typeof JSON == 'undefined') {
  // nope,
  print('no JSON\n');
  // include json.js & do some magic w. Gluescript
  if (typeof glue !== 'undefined' && glue.glue !== undefined && glue.version != undefined) {
    print('got glue\n');
    JSON = include('json.js');      // defines o.toJSONString() for basic JS types
    JSON.stringify = function(o) {  // make look like std javascript JSON
      if (o == null) return 'null';
      return o.toJSONString();
    };
  }
}


//==========

/* Create new prototype/object, inheriting from baseProto w. copied methods/properties of newMethodsProps

  Basically just like Object.create(baseProto, newMethodsProps);  
  where newMethodsProps needs to be in property descriptor format
  ie: so is the same (but more direct) as Object.create(baseProto, prepProps(newMethods));

  If newMethodsProps contains (a string) called 'slots_', 
    an init_() method is added to new proto that will create empty (null) slots.
  Also works for slots_ = {a:1, b:[12,34] ... }

   traits.B = proto_(traits.A, { overrideMethA : function() {...} });
|  objB = proto_(traits.B, {a : 2, b: [3]} ); // ?? not advisable
|  obj  = proto_(parentProto, { slots:'a, b', doit : function() { print('allo') } });

Calling:
  newProto = proto_(baseProto, methodsProps) 
    => creates new 'subclassed' prototype, with copied own properties of methodsProps 
    eg:  traits.B = proto_(traits.A, { overrideMethA : function() {...} });

  topProto = proto_(null, methodsProps) => similar, but for top level prototype (inherit from Object)

*/
//~ function proto_(baseProto, newMethodsProps) {
//~     // 
//~     if (baseProto == null) {
//~       // no base, we're defining a top level proto
//~       return baseProto__(newMethodsProps);
//~     } 
//~     else {
//~       // new inheriting proto
//~       return proto__(baseProto, newMethodsProps);
//~     }
//~ }

//----------

// Used for 1st level of hierarchy, 
// so that SubProto = baseProto__( { slots_:'a,b,c', m: function(){} } )
// makes SubProto a proto with the init_ method added, w/o creating a new object that inherits from A
// *** Normally, use proto_(null, {}) ***
//~ function baseProto__(newMethodsProps)
//~ {
//~     // add an init method to new proto that creates the empty slots
//~     if (newMethodsProps.hasOwnProperty('slots_')) {
//~       newMethodsProps[genInitFuncName__] = createCtorFunc__(newMethodsProps.slots_);
//~       delete newMethodsProps.slots_;
//~     }
//~     
//~     // add .prototype__ in case we dont have getPrototypeOf
//~     newMethodsProps.prototype__ = Object.prototype;
//~     
//~     return newMethodsProps;
//~ }



//===========


// Create new prototype, 
// inheriting from baseProto w. copied methods/properties of newMethodsProps
function proto_(baseProto, newMethodsProps)
{
  // create new proto object, 
  var proto = null;
  if (baseProto) {
    // add .prototype__ in case we dont have getPrototypeOf
    proto = Object.create(baseProto); 
    proto.prototype__ = baseProto; 
  }
  else {
    // add .prototype__ in case we dont have getPrototypeOf
    proto = Object.create(Object.prototype); 
    proto.prototype__ = Object.prototype; 
  }
  

  // create methods/properties & init_ method in new proto
  if (newMethodsProps) 
  {
    // copy properties (methods/data) from newMethodsProps
    // process special properties like slots_, traits_, mixins_
    for (var propertyName in newMethodsProps)
    {
      if (newMethodsProps.hasOwnProperty(propertyName))
      {
        if (propertyName == 'slots_') {
          // add an init method to new proto from 'slots_ = ...'
          proto[genInitFuncName__] = createCtorFunc__(newMethodsProps.slots_);
        }
        else if (propertyName == 'traits_') {
          // traits array
          for (var traits in newMethodsProps.traits_) 
            addTraits_(proto,newMethodsProps.traits_[traits]);
        }
        else if (propertyName == 'mixins_') {
          // mixins array
          for (var mixins in newMethodsProps.mixins_) 
            addMixins_(proto,newMethodsProps.mixins_[mixins]);
        }
        else {
          // copy property
          proto[propertyName] = newMethodsProps[propertyName];
        }
      }
    }
  } 
  
  return proto;  
}


//=================

// Create new object with Proto as prototype,
//   then call chain of init_()s (deepest 1st) 
// If initArgs = [args..], call newObj.init() with initArgs
// pass [] if no params in init()
function create_(proto, initArgs) {
  var newobj = Object.create(proto);
  
  // add .prototype__ in case we dont have getPrototypeOf
  newobj.prototype__ = proto;
  
  callInits_(newobj);
  
  // if we have an init() in proto & initArgs, call newobj.init() with the arguments
  if (initArgs && proto.hasOwnProperty('init'))
    newobj.init.apply(newobj, initArgs);
  
  return newobj;
}

//=================

// names of init methods called autom. on create_()
var genInitFuncName__ = "init__";  // name of the generated constructor method
var userInitFuncName__ = "init_";  // name of the user init / constructor method

// ##since we get them in reverse order, need to be in reverse here too
// ie we want to exec genInitFuncName__ 1st
var initFuncNames__ = [userInitFuncName__, genInitFuncName__];


// calls all init_ methods of object o, deepest 1st
function callInits_(o) {
  findAllInProtos_(o, initFuncNames__)
    .reverse()
      .forEach( function(init) { 
        init.call(o)
      });
  return o;
}

// find all o[names.foreach], through proto chain
// returns array
function findAllInProtos_(o, names) {
  var found = [];
  while (o) {
    // multiple names to lookup, same order as in names
    names.forEach(function(name){ 
      if (o.hasOwnProperty(name)) {
        //print(Name(o), name, o[name])
        found.push(o[name])
      }
    });
    o = protoOf_(o);
  }
  return found;
}


//=================

function addTraits_(obj, traits) {
  for (var traitNm in traits) {
    if (traits.hasOwnProperty(traitNm) && typeof traits[traitNm] == 'function') {
      obj[traitNm] = makeTraitsProxy__(traits, traitNm);
    }    
  }
}

function addMixins_(obj, traits) {
  for (var traitNm in traits) {
    if (traits.hasOwnProperty(traitNm) && typeof traits[traitNm] == 'function') {
      obj[traitNm] = traits[traitNm];
    }    
  }
}

function makeTraitsProxy__(traits, traitNm) {
  return function() { 
    return traits[traitNm].apply(this, arguments); 
  }
}


//=================

// Create a constructor function object (method that creates slots)
// a) slotDefs = 'a, b ,c' (empty/null) slots
// b) slotDefs = {a:1, b: [12, 13], c: "toto"}

/* Generate a constructor function object
  function() {
      this.a = 1;
      this.b = [12, 13];
      this.c = "allo";
  }
  from slots_ = {a:1, b:[12,13], c:"allo"}
*/
function createCtorFunc__(slotDefs) {

  // convert string 'a, b, ...' to {a:null, b:null ..} 
  slotDefs = prepCtorFuncParam__(slotDefs);
  
  // create a string version of the constructor method we want (see comment above)
  var funcStrs = [];

  // for each slot xyz : abc, add string 'this.xyz = abc;' to function string
  for (var slotName in slotDefs) {
    // Convert slot value to string using JSON
    // nb: dont use slotValue.toSource(), because xx=1 becomes 'xx = new Number(1)' !!
    if (slotDefs.hasOwnProperty(slotName)) {
      var valStr = JSON.stringify(slotDefs[slotName]);
      funcStrs.push(String.concat('this.', slotName, ' = ', valStr, ';'));
    }
  }
  
  // generate function object 
  return Function(funcStrs.join('\n')); 
}


// convert string 'a, b, c' => {a:null, b:null, c:null}
// or return as is if already {...}
function prepCtorFuncParam__(slotDefs)
{  
  // 'a, b, c' => {a:null, b:null, c:null}
  if (typeof slotDefs == "string") {
    // => array of slotNames
    var slotnames = slotDefs.split(/\s*,\s*/);
    
    // => {a:null, b:null ...}
    slotDefs = {}; // start empty
    for (var slotname in slotnames) {
      if (slotnames.hasOwnProperty(slotname)) {
        slotDefs[slotnames[slotname]] = null;
      }
    }
  }
 
  return slotDefs;
}


//--------------------- older version, stuff, etc.. ------------

//~ // Create an init_() method that creates slots
//~ // a) slotDefs = 'a, b ,c' (empty/null) slots
//~ // b) slotDefs = {a:1, b: [12, 13]}
//~ function addInitMethod__(o, slotDefs) {
//~   if (typeof slotDefs == 'string') {
//~     // 'a, b ,c'
//~     var slotDefsArr = slotDefs.split(/\s*,\s*/)
//~     o.init_ = function() { createSlots__(this, slotDefsArr); }
//~   }
//~   else {
//~     // {a:1, b: [12, 13]}
//~     // see createSlotsEval__() for evalSlotDefs
//~     var evalSlotDefs = {};
//~     for (var slotName in slotDefs) {
//~       //w. toSource(), a:1 becomes a:new Number(1) !!
//~       //evalSlotDefs[slotName] = slotDefs[slotName].toSource();
//~       evalSlotDefs[slotName] = JSON.stringify(slotDefs[slotName]);
//~     }
//~     
//~     o.init_ = function() { createSlotsEval__(this, evalSlotDefs); }
//~   }
//~ }

//~ //----------

//~ // (called by generated init_())
//~ // Create slots in o from slotDefs 
//~ // ['a', 'b', 'c'] => empty(null) slots
//~ function createSlots__(o, slotDefs) {
//~ //println('createslots_');
//~   slotDefs.forEach( function(slotName) {
//~     o[slotName] = null;   // create empty slot
//~   });
//~ }

//~ // (called by generated init_())
//~ // Create slots in o from slotDefs, 
//~ // slotDef is hash, values are strings created w toSource() to use with eval()
//~ // {a:"1", b:"\"allo\"", c:"[12,3]"}
//~ //   this is to force creation of NEW objects like [12,3], 
//~ //   otherwise we get a ref to [12,3], not a new copy
//~ function createSlotsEval__(o, slotDefs) {
//~ //println('createslotsEval_');
//~   for (var slotName in slotDefs) {
//~     o[slotName] = eval(slotDefs[slotName]);
//~   }
//~ }



/*
if (typeof Object.getOwnPropertyNames === 'function') {

  // (code from the net)
  // potential danger: we dont get 'real copies' for data members that are objects, but references to the prototype.member !
  function copy(o){  
    var copy = Object.create( Object.getPrototypeOf(o) );  
    var propNames = Object.getOwnPropertyNames(o);  
    propNames.forEach(function(name){  
                        var desc = Object.getOwnPropertyDescriptor(o, name);  
                        Object.defineProperty(copy, name, desc);  
                      });  
    return copy;  
  }

  var o1 = {a:1, b:2};  
  var o2 = copy(o1); // o2 looks like o1 now
}
*/

//------------------------------------------------

// find all o in name, start from deepest in proto chain
/*function findAllDeep1st(o, name) {
  var found = [];
  function recurse(o, name) {
    if (o) {
      recurse(Object.getPrototypeOf(o), name);
      if (o.hasOwnProperty(name)) {
        found.push(o[name])
      }
    }
  };
  recurse(o,name);
  return found;
}

//  c = Object.create(C);
//  callAllDeep1st(c, 'init');
function callAllDeep1st(o, name) {
  findAllDeep1st(o, name).forEach( 
    function(v) { v.call(o) } 
  );
}

// more efficient/direct version 
function callAllDeep1st(o, name) {
  if (o) {
    callAllDeep1st(Object.getPrototypeOf(o), name);
    if (o.hasOwnProperty(name))
      o[name].call(o);
    return o; // so can do : callAllDeep1st(proto_(pp), 'init');
  }
} 


// version that doesnt make eveything 'dynamic'
function proto_(baseProto, newMethodsProps) {
  var proto = Object.create(baseProto);
  
  if (newMethodsProps) {
    // this keeps the writable, enumerable, configurable flags of the original methods/properties
    var propNames = Object.getOwnPropertyNames(newMethodsProps);  
    propNames.forEach(function(name){  
                        var desc = Object.getOwnPropertyDescriptor(newMethodsProps, name);  
                        Object.defineProperty(proto, name, desc);  
                      });  
  }
  
  return proto;
}
*/
