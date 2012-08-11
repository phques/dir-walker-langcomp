/*
   Project: dirWalker1.GNUstep

   Copyright (C) 2010 Free Software Foundation

   Author: Philippe Quesnel,,,

   Created: 2010-10-17 17:31:22 -0400 by kwez

   This application is free software; you can redistribute it and/or
   modify it under the terms of the GNU General Public
   License as published by the Free Software Foundation; either
   version 2 of the License, or (at your option) any later version.

   This application is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Library General Public License for more details.

   You should have received a copy of the GNU General Public
   License along with this library; if not, write to the Free
   Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111 USA.
*/

#import "OneDirBase.h"

@implementation OneDirBase

- init
{
  kids = [NSMutableArray arrayWithCapacity: 16];
  filenames = [NSMutableArray arrayWithCapacity: 16];
  path = @"";
  fullPath = @"";
  basePath = @"";
  return self;
}


// makes immutable copies
- (NSArray*) kids       { return [NSArray arrayWithArray: kids] ; }
- (NSArray*) filenames  { return [NSArray arrayWithArray: filenames] ; }
- (NSString*) path      { return path; }
- (NSString*) fullPath  { return fullPath; }
- (NSString*) basePath  { return basePath; }

- (void)_setPaths:(NSString*)_path withBasePath:(NSString*)_basePath
{
  path = _path;
  basePath = _basePath;
  // need to 'inc ref' ??
  // ## this NO GOOD anyways...
  fullPath = [basePath stringByAppendingPathComponent: path];
}

- (void)_addFile:(NSString*)filename
{
  [filenames addObject:filename];
}

- (void)_addKid:(OneDirBase*)kid
{
  [kids addObject:kid];
}


//---------------

- (void)_walk:(int)level
{
  NSEnumerator *enumer = nil;
  
  // process current subdir
  [self processSubdirLevel: level];
  
  // process kid subdirs
  OneDirBase* kid = nil;
  enumer = [kids objectEnumerator];
  while ((kid = [enumer nextObject]))
  {
    [kid _walk: level+1];
  }

  // process current files
  NSString* filename = nil;
  enumer = [filenames objectEnumerator];
  while ((filename = [enumer nextObject]))
  {
    [self processFile:filename atLevel:level];
  }
}


- (void)walk
{
  [self _walk:0];
}

// overide these two for specific processing
- (void)processSubdirLevel:(int)level { }
- (void)processFile:(NSString*)filename atLevel:(int)level { }


//---------------

// walk thru directory enumerator, creating new instances & filling kids/filenames
+ (OneDirBase*) _walkEnumerator:(NSDirectoryEnumerator*)directoryEnumerator withBasePath:(NSString*)basePath
{
  // dir stack to handle recursion
  NSMutableArray* dirStack = [NSMutableArray arrayWithCapacity:16];
  
  // class object to create new instance of proper type (if OneBaseDir subclassed)
  Class classObj = [self class];
  
  OneDirBase* oneDir = nil; //start dir, return val
  OneDirBase* currentDir = nil;
  int level = 0;

  // create start dir
  currentDir = [[classObj alloc] init];
  [currentDir _setPaths:@"" withBasePath:basePath];

  // is 1st level dir
  oneDir = currentDir;

  // go thru all files & subdirs
  NSString *subdirPath = nil;
  while ((subdirPath = [directoryEnumerator nextObject]))
  {
    NSString* fileType = [[directoryEnumerator fileAttributes] fileType];
//~     NSLog(@"PATH: %@, type=%@", subdirPath, fileType);
  
    // check if we changed level to parentdir
    int itemParentLevel = [[subdirPath pathComponents] count] - 1;
    if (itemParentLevel < level)
    {
      // up a level (to parent of curr dir), pop prev subdir
      currentDir = [dirStack lastObject];
      [dirStack removeLastObject];
      level--;
    }
    
    // check attrib of curr enumerated obj,
    // if it is a file, add it to current dir
    if (fileType == NSFileTypeRegular)
    {
      [currentDir _addFile:subdirPath];
    }
    else if (fileType == NSFileTypeDirectory)
    {
      // push current on top of dirs stack
      [dirStack addObject:currentDir];
      level++;
    
      // going deeper, subdir, create kid onedir
      // create onedir
      NSString* subdirName = [subdirPath lastPathComponent];

      OneDirBase* newKid = [[classObj alloc] init];
      [newKid _setPaths:subdirName withBasePath:basePath];
      
      // save kid in current & kid becomes current
      [currentDir _addKid: newKid];
      currentDir = newKid;
    }
  }
  
  return oneDir;
}


// static class method
// creates a OneDirBase object with kids & filenames
+ (OneDirBase*) withPath: (NSString*)pathname
{
  OneDirBase* oneDir = nil;

  NSFileManager* manager = [NSFileManager defaultManager];
  BOOL isDirectory = NO;

  if ([manager fileExistsAtPath:pathname isDirectory:&isDirectory])
  {
    if (isDirectory)
    {
      NSDirectoryEnumerator *directoryEnumerator = [manager enumeratorAtPath:pathname];
      if (directoryEnumerator)
      {
        // class object to create new instance of proper type (if OneBaseDir subclassed)
        Class classObj = [self class];
        oneDir = [classObj _walkEnumerator:directoryEnumerator withBasePath:pathname];
      }
      else
      {
        printf("Unable to get directory enumerator for %s\n", [pathname cString]);
      }
    }
    else
    {
      printf("%s is NOT a directory\n", [pathname cString]);
    }
  }
  else
  {
    printf("[%s] is not a valid path\n", [pathname cString]);
  }
  
  return oneDir;
}

@end
